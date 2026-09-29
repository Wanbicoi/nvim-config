--- tmux multiplexer adapter.
local M = { name = 'tmux' }

M.capabilities = {
  title = false,
  panes = true,
  send = true,
  captures_ctrl_left_press = false,
}

local BUFFER = 'nvim-agent'

function M.available()
  return vim.env.TMUX ~= nil and vim.env.TMUX ~= '' and vim.fn.executable 'tmux' == 1
end

function M.set_title() end

function M.current_pane_id()
  return vim.env.TMUX_PANE
end

---@return { id: string, tab_id: any, cmd: string|nil, is_plugin: boolean }[]
function M.panes()
  local fmt = '#{pane_id}\t#{window_id}\t#{pane_current_command}'
  local out = vim.fn.system { 'tmux', 'list-panes', '-a', '-F', fmt }
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local panes = {}
  for line in vim.gsplit(out, '\n', { plain = true }) do
    if line ~= '' then
      local id, tab_id, cmd = line:match '^(.-)\t(.-)\t(.*)$'
      if id then
        panes[#panes + 1] = { id = id, tab_id = tab_id, cmd = cmd, is_plugin = false }
      end
    end
  end
  return panes
end

---@param pane_id string
---@param text string
function M.send(pane_id, text)
  if not pane_id or not text or text == '' then
    return
  end
  vim.fn.system { 'tmux', 'set-buffer', '-b', BUFFER, text }
  vim.fn.system { 'tmux', 'paste-buffer', '-b', BUFFER, '-t', pane_id, '-d' }
end

---@param pane_id string
function M.focus(pane_id)
  if not pane_id then
    return
  end
  vim.fn.system { 'tmux', 'select-pane', '-t', pane_id }
end

return M
