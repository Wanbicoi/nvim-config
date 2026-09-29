--- Zellij adapter.
local M = { name = 'zellij' }

M.capabilities = {
  title = true,
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

return M
