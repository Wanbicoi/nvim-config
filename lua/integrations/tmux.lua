--- tmux adapter.
local M = { name = 'tmux' }

M.capabilities = {
  -- tmux's automatic window renaming fights a programmatic title, so we don't
  -- set one.
  title = false,
  captures_ctrl_left_press = false,
}

function M.available()
  return vim.env.TMUX ~= nil and vim.env.TMUX ~= '' and vim.fn.executable 'tmux' == 1
end

function M.set_title() end

return M
