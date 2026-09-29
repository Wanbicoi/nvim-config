--- Zellij multiplexer adapter.
local M = { name = 'zellij' }

M.capabilities = {
  title = true,
  panes = true,
  send = true,
  -- Zellij swallows Ctrl+LeftPress but forwards Ctrl+LeftRelease.
  captures_ctrl_left_press = true,
}

function M.available()
  return vim.env.ZELLIJ ~= nil and vim.env.ZELLIJ ~= '' and vim.fn.executable 'zellij' == 1
end

function M.set_title(title)
  if not title or title == '' then
    return
  end
  vim.fn.system { 'zellij', 'action', 'rename-pane', title }
end

function M.current_pane_id()
  return vim.env.ZELLIJ_PANE_ID
end

---@return { id: string, tab_id: any, cmd: string|nil, is_plugin: boolean }[]
function M.panes()
  local out = vim.fn.system { 'zellij', 'action', 'list-panes', '-a', '-j' }
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local ok, decoded = pcall(vim.json.decode, out)
  if not ok or type(decoded) ~= 'table' then
    return {}
  end

  local panes = {}
  for _, p in ipairs(decoded) do
    -- zellij 0.45+ reports the running command as `pane_command`; the legacy
    -- `terminal_command` field is still present but always null.
    local cmd = p.pane_command or p.terminal_command
    if type(cmd) ~= 'string' then
      cmd = nil
    end
    panes[#panes + 1] = {
      id = tostring(p.id),
      tab_id = p.tab_id,
      cmd = cmd,
      is_plugin = p.is_plugin and true or false,
    }
  end
  return panes
end

---@param pane_id string
---@param text string
function M.send(pane_id, text)
  if not pane_id or not text or text == '' then
    return
  end
  if text:sub(-1) ~= '\n' then
    text = text .. '\n'
  end
  -- Bracketed paste so TUI agents receive the text as a single payload.
  vim.fn.system { 'zellij', 'action', 'paste', '-p', 'terminal_' .. pane_id, text }
end

---@param pane_id string
function M.focus(pane_id)
  if not pane_id then
    return
  end
  vim.fn.system { 'zellij', 'action', 'focus-pane-id', 'terminal_' .. pane_id }
end

return M
