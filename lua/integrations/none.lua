--- No-op adapter used when running outside any supported multiplexer.
local M = { name = 'none' }

M.capabilities = {
  title = false,
  panes = false,
  send = false,
  captures_ctrl_left_press = false,
}

function M.available()
  return false
end

function M.set_title(_) end

function M.current_pane_id()
  return nil
end

function M.panes()
  return {}
end

function M.send() end

function M.focus() end

return M
