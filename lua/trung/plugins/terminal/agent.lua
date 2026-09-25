local snacks_search = require 'trung.utils.snacks_search'

local M = {}

M.agent_cmds = {
  agy = 'agy --dangerously-skip-permissions',
  claude = 'claude --dangerously-skip-permissions',
  codex = 'codex --dangerously-bypass-approvals-and-sandbox',
  opencode = 'opencode',
}

---@class AgentSession
---@field id integer
---@field agent string
---@field name string
---@field cmd string
---@field cwd string
---@field term snacks.terminal

---@type AgentSession[]
M.sessions = {}
M.active_id = nil
M.next_id = 101

local function setup_highlights()
  local is_light = vim.o.background == 'light'

  local fill_bg = is_light and '#f3f3f3' or '#181818'
  local fill_fg = is_light and '#616161' or '#888888'

  -- Active tab: distinct accent pill
  local active_bg = is_light and '#007acc' or '#094771'
  local active_fg = '#ffffff'
  local active_close = is_light and '#d0e7ff' or '#a0cfff'

  -- Inactive tab: soft neutral pill
  local inactive_bg = is_light and '#e2e2e2' or '#2a2a2a'
  local inactive_fg = is_light and '#555555' or '#999999'
  local inactive_close = is_light and '#888888' or '#666666'

  -- Add (+) button: matching neutral pill with accent plus
  local btn_bg = is_light and '#e2e2e2' or '#2a2a2a'
  local btn_fg = is_light and '#007acc' or '#4fc1ff'

  local info_fg = is_light and '#666666' or '#888888'

  vim.api.nvim_set_hl(0, 'AgentWinBarFill', { bg = fill_bg, fg = fill_fg })
  vim.api.nvim_set_hl(0, 'AgentWinBarActive', { bg = active_bg, fg = active_fg, bold = true })
  vim.api.nvim_set_hl(0, 'AgentWinBarActiveClose', { bg = active_bg, fg = active_close, bold = true })
  vim.api.nvim_set_hl(0, 'AgentWinBarInactive', { bg = inactive_bg, fg = inactive_fg })
  vim.api.nvim_set_hl(0, 'AgentWinBarInactiveClose', { bg = inactive_bg, fg = inactive_close })
  vim.api.nvim_set_hl(0, 'AgentWinBarBtn', { bg = btn_bg, fg = btn_fg, bold = true })
  vim.api.nvim_set_hl(0, 'AgentWinBarInfo', { bg = fill_bg, fg = info_fg })
end

--- Get terminal window configuration
---@param id integer
---@param cwd string
local function agent_opts(id, cwd)
  return {
    count = id,
    cwd = cwd,
    win = {
      position = 'right',
      width = math.floor(vim.o.columns * 0.4),
      stack = false,
      wo = {
        winbar = "%{%v:lua.require'trung.plugins.terminal.agent'.render_winbar()%}",
      },
    },
  }
end

local function hide_visible_agent_window()
  for _, s in ipairs(M.sessions) do
    if s.term and s.term:win_valid() then
      s.term:hide()
    end
  end
end

--- Get session by its unique ID
---@param id integer|nil
---@return AgentSession?
function M.get_session_by_id(id)
  if not id then
    return nil
  end
  for _, s in ipairs(M.sessions) do
    if s.id == id then
      return s
    end
  end
  return nil
end

--- Get currently active session
---@return AgentSession?
function M.get_active_session()
  return M.get_session_by_id(M.active_id)
end

--- Get currently opened / active terminal instance
--- Prioritizes:
--- 1. Session matching current buffer
--- 2. Currently visible agent window
--- 3. Active session
--- 4. First session
---@return snacks.terminal?, AgentSession?
function M.get_opened_term()
  local cur_buf = vim.api.nvim_get_current_buf()
  for _, s in ipairs(M.sessions) do
    if s.term and s.term.buf == cur_buf and s.term:buf_valid() then
      M.active_id = s.id
      return s.term, s
    end
  end

  for _, s in ipairs(M.sessions) do
    if s.term and s.term:win_valid() and s.term:buf_valid() then
      M.active_id = s.id
      return s.term, s
    end
  end

  if M.active_id then
    local s = M.get_session_by_id(M.active_id)
    if s and s.term and s.term:buf_valid() then
      return s.term, s
    end
  end

  if #M.sessions > 0 then
    local s = M.sessions[1]
    if s.term and s.term:buf_valid() then
      M.active_id = s.id
      return s.term, s
    end
  end

  return nil, nil
end

--- Render winbar string listing all opened agents with click support
---@return string
function M.render_winbar()
  if #M.sessions == 0 then
    return ''
  end

  local parts = { '%#AgentWinBarFill# ' }

  for i, s in ipairs(M.sessions) do
    local is_active = (s.id == M.active_id)
    local tab_hl = is_active and '%#AgentWinBarActive#' or '%#AgentWinBarInactive#'
    local close_hl = is_active and '%#AgentWinBarActiveClose#' or '%#AgentWinBarInactiveClose#'

    local label = string.format(' %d:%s ', i, s.agent)
    local tab_item = string.format("%s%%%d@v:lua.require'trung.plugins.terminal.agent'.on_click@%s%%X", tab_hl, i, label)
    local close_item = string.format("%s%%%d@v:lua.require'trung.plugins.terminal.agent'.on_click@× %%X", close_hl, 1000 + i)

    table.insert(parts, tab_item .. close_item)
    table.insert(parts, '%#AgentWinBarFill# ')
  end

  -- [+] Button to create new agent
  table.insert(parts, "%#AgentWinBarBtn#%9999@v:lua.require'trung.plugins.terminal.agent'.on_click@ + %X")

  -- Right-aligned info
  table.insert(parts, '%#AgentWinBarFill#%=')
  local active = M.get_active_session()
  if active and active.cwd then
    local short_cwd = vim.fn.fnamemodify(active.cwd, ':t')
    table.insert(parts, string.format('%%#AgentWinBarInfo#📁 %s ', short_cwd))
  end

  return table.concat(parts, '')
end

--- Create a single agent session
---@param agent_type string
---@param cwd string
---@return AgentSession
local function create_session(agent_type, cwd)
  hide_visible_agent_window()

  local id = M.next_id
  M.next_id = M.next_id + 1

  local cmd = M.agent_cmds[agent_type] or agent_type

  local count_for_type = 0
  for _, s in ipairs(M.sessions) do
    if s.agent == agent_type then
      count_for_type = count_for_type + 1
    end
  end
  local name = agent_type .. (count_for_type > 0 and (' #' .. (count_for_type + 1)) or '')

  local term = Snacks.terminal.get(cmd, agent_opts(id, cwd))

  local session = {
    id = id,
    agent = agent_type,
    name = name,
    cmd = cmd,
    cwd = cwd,
    term = term,
  }

  table.insert(M.sessions, session)
  return session
end

--- Switch to an agent session by its ID
---@param target_id integer
function M.switch_to_session(target_id)
  local target = M.get_session_by_id(target_id)
  if not target then
    return
  end

  if M.active_id and M.active_id ~= target_id then
    local current = M.get_session_by_id(M.active_id)
    if current and current.term and current.term:win_valid() then
      current.term:hide()
    end
  end

  M.active_id = target_id

  if target.term then
    if not target.term:win_valid() then
      target.term:show()
    end
    target.term:focus()
    vim.cmd 'startinsert'
  end

  pcall(function()
    if package.loaded['edgy'] then
      require('edgy').update()
    end
  end)

  pcall(function()
    vim.cmd.redrawstatus()
  end)
end

--- Switch to an agent session by its 1-based index
---@param idx integer
function M.switch_to_index(idx)
  if idx >= 1 and idx <= #M.sessions then
    M.switch_to_session(M.sessions[idx].id)
  end
end

--- Close an agent session by index or ID
---@param idx_or_id integer
function M.close_session(idx_or_id)
  local s, idx
  if idx_or_id <= #M.sessions then
    idx = idx_or_id
    s = M.sessions[idx]
  else
    for i, session in ipairs(M.sessions) do
      if session.id == idx_or_id then
        s = session
        idx = i
        break
      end
    end
  end

  if not s then
    return
  end

  local was_active = (s.id == M.active_id)

  if s.term then
    if s.term:win_valid() then
      s.term:close()
    elseif s.term:buf_valid() then
      pcall(vim.api.nvim_buf_delete, s.term.buf, { force = true })
    end
  end

  table.remove(M.sessions, idx)

  if was_active then
    if #M.sessions > 0 then
      local next_idx = math.min(idx, #M.sessions)
      M.switch_to_session(M.sessions[next_idx].id)
    else
      M.active_id = nil
      pcall(function()
        if package.loaded['edgy'] then
          require('edgy').update()
        end
      end)
    end
  end

  pcall(function()
    vim.cmd.redrawstatus()
  end)
end

--- Switch to next agent session
function M.next_session()
  if #M.sessions <= 1 then
    return
  end
  for i, s in ipairs(M.sessions) do
    if s.id == M.active_id then
      local next_idx = (i % #M.sessions) + 1
      M.switch_to_session(M.sessions[next_idx].id)
      return
    end
  end
  M.switch_to_session(M.sessions[1].id)
end

--- Switch to previous agent session
function M.prev_session()
  if #M.sessions <= 1 then
    return
  end
  for i, s in ipairs(M.sessions) do
    if s.id == M.active_id then
      local prev_idx = i - 1
      if prev_idx < 1 then
        prev_idx = #M.sessions
      end
      M.switch_to_session(M.sessions[prev_idx].id)
      return
    end
  end
  M.switch_to_session(M.sessions[#M.sessions].id)
end

--- Interactive selector to choose an open agent session
function M.select_session()
  if #M.sessions == 0 then
    vim.notify('No active agent sessions', vim.log.levels.INFO, { title = 'Agent Coding' })
    return
  end

  local items = {}
  for i, s in ipairs(M.sessions) do
    local is_active = (s.id == M.active_id) and ' [Active]' or ''
    local short_cwd = vim.fn.fnamemodify(s.cwd, ':t')
    table.insert(items, {
      index = i,
      id = s.id,
      label = string.format('%d: %s (%s)%s', i, s.name, short_cwd, is_active),
    })
  end

  vim.ui.select(items, {
    prompt = 'Select Agent Session:',
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if choice then
      M.switch_to_session(choice.id)
    end
  end)
end

--- Handle clicks from the winbar
---@param minwid integer
---@param clicks integer
---@param button string 'l'|'m'|'r'
---@param mods string
function M.on_click(minwid, clicks, button, mods)
  if minwid == 9999 then
    M.open_new()
    return
  end

  if minwid >= 1000 and minwid < 9000 then
    local idx = minwid - 1000
    M.close_session(idx)
    return
  end

  if minwid >= 1 and minwid <= #M.sessions then
    if button == 'm' then
      M.close_session(minwid)
    else
      M.switch_to_index(minwid)
    end
    return
  end
end

--- UI prompt to pick agent type and cwd
---@param callback fun(agent_choice: string, cwd: string)
function M.pick_agent_and_cwd(callback)
  local choices = vim.tbl_keys(M.agent_cmds)
  table.sort(choices)

  vim.ui.select(choices, {
    prompt = 'Select Coding Agent:',
  }, function(agent_choice)
    if not agent_choice then
      return
    end

    local default_root = snacks_search.get_project_root()
    local short_root = vim.fn.fnamemodify(default_root, ':t')

    vim.ui.select({
      string.format('Project root (%s)', short_root),
      'Current folder',
    }, {
      prompt = string.format('Open %s terminal in:', agent_choice),
    }, function(cwd_choice)
      if not cwd_choice then
        return
      end

      local cwd = cwd_choice:find '^Project root' and default_root or vim.uv.cwd()
      callback(agent_choice, cwd)
    end)
  end)
end

--- Open agent session
---@param agent_choice string
---@param cwd string
---@param cb? fun(term: snacks.terminal)
function M.open_agent(agent_choice, cwd, cb)
  local s = create_session(agent_choice, cwd)
  M.switch_to_session(s.id)
  if cb then
    cb(s.term)
  end
end

--- Toggle active agent terminal or prompt to open first agent
function M.open_or_toggle()
  if #M.sessions == 0 then
    M.pick_agent_and_cwd(function(agent_choice, cwd)
      M.open_agent(agent_choice, cwd)
    end)
    return
  end

  local active = M.get_active_session()
  if active and active.term then
    active.term:toggle()
  else
    local term, s = M.get_opened_term()
    if s then
      M.switch_to_session(s.id)
    end
  end
end

--- Open a new agent session (prompt or direct)
---@param agent_choice? string
---@param cwd? string
function M.open_new(agent_choice, cwd)
  if agent_choice and cwd then
    M.open_agent(agent_choice, cwd)
    return
  end

  M.pick_agent_and_cwd(function(choice, selected_cwd)
    M.open_agent(choice, selected_cwd)
  end)
end

--- Send text to the currently opened agent terminal
---@param text string
function M.send(text)
  local function do_send(term)
    if not term then
      return
    end
    if not term:win_valid() then
      term:show()
    end
    term:focus()

    vim.defer_fn(function()
      if not (term and term:buf_valid()) then
        return
      end
      local chan = vim.bo[term.buf].channel
      if chan and chan > 0 then
        vim.api.nvim_chan_send(chan, text)
      end
      if term and term:win_valid() then
        term:focus()
        vim.cmd 'startinsert'
      end
    end, 100)
  end

  local term = M.get_opened_term()
  if term then
    do_send(term)
    return
  end

  M.pick_agent_and_cwd(function(agent_choice, cwd)
    M.open_agent(agent_choice, cwd, function(new_term)
      do_send(new_term)
    end)
  end)
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

local function is_agent_buf(bufnr)
  for _, s in ipairs(M.sessions) do
    if s.term and s.term.buf == bufnr then
      return true
    end
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
  if is_agent_buf(bufnr) then
    return
  end
  if is_term_or_overseer(bufnr) then
    local text = get_last_lines(bufnr, 50)
    if vim.trim(text) ~= '' then
      M.send(text .. '\n')
    end
    return
  end
  local file = vim.fn.expand '%'
  local line = vim.fn.line '.'
  M.send(string.format('%s:L%d\n', file, line))
end

function M.send_selection()
  local bufnr = vim.api.nvim_get_current_buf()
  if is_agent_buf(bufnr) then
    return
  end
  if is_term_or_overseer(bufnr) then
    local text = get_visual_selection_text()
    if vim.trim(text) ~= '' then
      M.send(text .. '\n')
    end
    return
  end
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local file = vim.fn.expand '%'
  M.send(string.format('@%s:L%d-L%d\n', file, start_pos[2], end_pos[2]))
end

function M.send_line()
  local bufnr = vim.api.nvim_get_current_buf()
  if is_agent_buf(bufnr) then
    return
  end
  if is_term_or_overseer(bufnr) then
    local text = get_last_lines(bufnr, 50)
    if vim.trim(text) ~= '' then
      M.send(text .. '\n')
    end
    return
  end
  local file = vim.fn.expand '%'
  local line = vim.fn.line '.'
  M.send(string.format('@%s:L%d\n', file, line))
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
    vim.notify('No diagnostics found', vim.log.levels.INFO, { title = 'Agent Coding' })
    return
  end

  local lines = {}
  for _, diag in ipairs(diags) do
    table.insert(lines, format_diagnostic(diag, file))
  end

  local text = string.format('Fix the following diagnostic%s:\n%s\n', #diags > 1 and 's' or '', table.concat(lines, '\n'))
  M.send(text)
end

function M.setup()
  setup_highlights()

  vim.api.nvim_create_autocmd({ 'TermClose', 'BufWipeout' }, {
    group = vim.api.nvim_create_augroup('agent_terminal_monitor', { clear = true }),
    callback = function(ev)
      for i, s in ipairs(M.sessions) do
        if s.term and s.term.buf == ev.buf then
          local was_active = (s.id == M.active_id)
          table.remove(M.sessions, i)
          if was_active then
            if #M.sessions > 0 then
              local next_idx = math.min(i, #M.sessions)
              M.switch_to_session(M.sessions[next_idx].id)
            else
              M.active_id = nil
            end
          end
          pcall(function()
            vim.cmd.redrawstatus()
          end)
          break
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('agent_winbar_hl', { clear = true }),
    callback = setup_highlights,
  })
end

return M
