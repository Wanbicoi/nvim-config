local M = {}

local ai_patterns = { 'claude', 'codex', 'agy', 'opencode'}

--- Parse zellij list-panes JSON output
---@return table[]
local function get_zellij_panes()
  local out = vim.fn.system { 'zellij', 'action', 'list-panes', '-a', '-j' }
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local ok, panes = pcall(vim.json.decode, out)
  if not ok or type(panes) ~= 'table' then
    return {}
  end
  return panes
end

--- Check if command matches known AI agent patterns
---@param cmd string|nil
---@return boolean
local function is_ai_cmd(cmd)
  -- `terminal_command` is JSON null for panes with no running command (eg. a
  -- plain shell or a plugin). vim.json.decode turns that null into vim.NIL,
  -- which is truthy, so a nil check is not enough -- `cmd:match` would then
  -- blow up with "attempt to index vim.NIL". Guard on the type instead.
  if type(cmd) ~= 'string' or cmd == '' then
    return false
  end

  -- Match only the executable name, not the whole command line. A substring
  -- search would also hit paths and arguments (e.g. a pane whose cwd or file
  -- argument contains "opencode" would be mistaken for the agent).
  local exe = cmd:match '^%s*(%S+)' or ''
  exe = exe:match '[^/]+$' or exe -- strip any directory part
  exe = exe:lower()

  for _, pat in ipairs(ai_patterns) do
    if exe == pat then
      return true
    end
  end
  return false
end

--- Find target AI zellij pane without prompting
---@return string|nil pane_id e.g. "terminal_3"
---@return string|nil cmd_or_err
function M.find_target_pane()
  if not vim.env.ZELLIJ or vim.env.ZELLIJ == '' then
    return nil, 'Not running inside zellij'
  end

  local panes = get_zellij_panes()
  local current_id = vim.env.ZELLIJ_PANE_ID

  -- Find which tab Neovim itself runs in, so we can prefer an agent on the
  -- same tab over one that happens to be elsewhere in the session.
  local current_tab
  for _, pane in ipairs(panes) do
    if not pane.is_plugin and tostring(pane.id) == current_id then
      current_tab = pane.tab_id
      break
    end
  end

  local same_tab = {}
  local other_tab = {}

  for _, pane in ipairs(panes) do
    -- Skip plugins and the pane Neovim itself runs in
    if not pane.is_plugin and tostring(pane.id) ~= current_id then
      -- zellij 0.45+ reports the running command as `pane_command`; the legacy
      -- `terminal_command` field is still present but is always null. Fall back
      -- to it so this keeps working on older zellij builds.
      local cmd = pane.pane_command or pane.terminal_command

      if is_ai_cmd(cmd) then
        local entry = { id = 'terminal_' .. pane.id, cmd = cmd }
        if current_tab ~= nil and pane.tab_id == current_tab then
          table.insert(same_tab, entry)
        else
          table.insert(other_tab, entry)
        end
      end
    end
  end

  local best = same_tab[1] or other_tab[1]
  if best then
    return best.id, best.cmd
  end

  return nil, 'No AI agent pane found'
end

--- Send text to target zellij pane
---@param text string
function M.send(text)
  if not text or text == '' then
    return
  end

  local target_pane, cmd_or_err = M.find_target_pane()
  if not target_pane then
    vim.notify(cmd_or_err or 'No target zellij pane found', vim.log.levels.WARN, { title = 'Zellij Agent' })
    return
  end

  if text:sub(-1) ~= '\n' then
    text = text .. '\n'
  end

  -- Use bracketed paste so TUI agents receive the text as a single payload.
  vim.fn.system { 'zellij', 'action', 'paste', '-p', target_pane, text }

  M.focus_pane(target_pane)
end

--- Focus the given zellij pane
---@param pane_id string
function M.focus_pane(pane_id)
  if not pane_id then
    return
  end
  vim.fn.system { 'zellij', 'action', 'focus-pane-id', pane_id }
end

local function is_term_or_overseer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local bt = vim.bo[bufnr].buftype
  local ft = (vim.bo[bufnr].filetype or ''):lower()
  local name = vim.api.nvim_buf_get_name(bufnr):lower()

  if bt == 'terminal' or ft == 'terminal' or name:match '^term://' then
    return true
  end
  if ft:find 'overseer' or vim.b[bufnr].overseer_task ~= nil or name:match '^overseer://' then
    return true
  end
  if vim.b[bufnr].snacks_terminal ~= nil then
    return true
  end
  return false
end

local function get_last_lines(bufnr, count)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  count = count or 50
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  while #lines > 0 and vim.trim(lines[#lines]) == '' do
    table.remove(lines)
  end
  if #lines == 0 then
    return ''
  end
  local start_idx = math.max(1, #lines - count + 1)
  local last_lines = {}
  for i = start_idx, #lines do
    table.insert(last_lines, lines[i])
  end
  return table.concat(last_lines, '\n')
end

local function get_visual_selection_text()
  local mode = vim.fn.mode()
  if mode:match '[vV\22]' then
    vim.cmd 'normal! \27'
  end
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  if start_pos[2] == 0 or end_pos[2] == 0 then
    return ''
  end
  local vmode = vim.fn.visualmode()
  local lines = vim.fn.getregion(start_pos, end_pos, { type = vmode ~= '' and vmode or 'v' })
  return table.concat(lines, '\n')
end

function M.send_file()
  local bufnr = vim.api.nvim_get_current_buf()
  if is_term_or_overseer(bufnr) then
    local text = get_last_lines(bufnr, 50)
    if vim.trim(text) ~= '' then
      M.send(text)
    end
    return
  end
  local file = vim.fn.expand '%'
  M.send(string.format('@%s', file))
end

function M.send_line()
  local bufnr = vim.api.nvim_get_current_buf()
  if is_term_or_overseer(bufnr) then
    local text = get_last_lines(bufnr, 50)
    if vim.trim(text) ~= '' then
      M.send(text)
    end
    return
  end
  local file = vim.fn.expand '%'
  local line = vim.fn.line '.'
  M.send(string.format('@%s:L%d', file, line))
end

function M.send_selection()
  local bufnr = vim.api.nvim_get_current_buf()
  if is_term_or_overseer(bufnr) then
    local text = get_visual_selection_text()
    if vim.trim(text) ~= '' then
      M.send(text)
    end
    return
  end
  local mode = vim.fn.mode()
  if mode:match '[vV\22]' then
    vim.cmd 'normal! \27'
  end
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local file = vim.fn.expand '%'
  M.send(string.format('@%s:L%d-L%d', file, start_pos[2], end_pos[2]))
end

local function format_diagnostic(diag, file)
  local severity_names = {
    [vim.diagnostic.severity.ERROR] = 'ERROR',
    [vim.diagnostic.severity.WARN] = 'WARN',
    [vim.diagnostic.severity.INFO] = 'INFO',
    [vim.diagnostic.severity.HINT] = 'HINT',
  }
  local sev = severity_names[diag.severity] or 'DIAGNOSTIC'
  local code = diag.code and string.format(' (%s)', diag.code) or (diag.source and string.format(' (%s)', diag.source) or '')
  local line = (diag.lnum or 0) + 1
  local col = (diag.col or 0) + 1
  return string.format('@%s:L%d:C%d [%s] %s%s', file, line, col, sev, vim.trim(diag.message or ''), code)
end

function M.send_diagnostic()
  local bufnr = vim.api.nvim_get_current_buf()
  local file = vim.fn.expand '%'
  if file == '' then
    file = vim.api.nvim_buf_get_name(bufnr)
  end

  local mode = vim.fn.mode()
  local diags = {}

  if mode == 'v' or mode == 'V' or mode == '\22' then
    vim.cmd 'normal! \27'
    local start_line = vim.fn.getpos("'<")[2] - 1
    local end_line = vim.fn.getpos("'>")[2] - 1
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    for _, d in ipairs(vim.diagnostic.get(bufnr)) do
      if d.lnum >= start_line and d.lnum <= end_line then
        table.insert(diags, d)
      end
    end
  else
    local cur_line = vim.fn.line '.' - 1
    local line_diags = vim.diagnostic.get(bufnr, { lnum = cur_line })
    diags = #line_diags > 0 and line_diags or vim.diagnostic.get(bufnr)
  end

  if #diags == 0 then
    vim.notify('No diagnostics found', vim.log.levels.INFO, { title = 'Zellij Agent' })
    return
  end

  local lines = {}
  for _, diag in ipairs(diags) do
    table.insert(lines, format_diagnostic(diag, file))
  end

  local text = string.format('Fix the following diagnostic%s:\n%s', #diags > 1 and 's' or '', table.concat(lines, '\n'))
  M.send(text)
end

return {
  'zellij-agent',
  dir = vim.fn.stdpath 'config',
  -- expose the helpers so popup-menu entries and other callers can reach them
  send = M.send,
  send_file = M.send_file,
  send_line = M.send_line,
  send_selection = M.send_selection,
  send_diagnostic = M.send_diagnostic,
  find_target_pane = M.find_target_pane,
  focus_pane = M.focus_pane,
  keys = {
    {
      '<leader>af',
      M.send_file,
      mode = 'n',
      desc = '[A]gent zellij: send file',
    },
    {
      '<leader>at',
      M.send_line,
      mode = 'n',
      desc = '[A]gent zellij: send line',
    },
    {
      '<leader>at',
      M.send_selection,
      mode = 'x',
      desc = '[A]gent zellij: send selection',
    },
    {
      '<leader>ad',
      M.send_diagnostic,
      mode = { 'n', 'x' },
      desc = '[A]gent zellij: send diagnostic',
    },
  },
}
