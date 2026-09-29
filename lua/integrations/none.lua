--- No-op adapter used when running outside any supported environment.
local M = { name = 'none' }

M.capabilities = {
  title = false,
  captures_ctrl_left_press = false,
}

function M.available()
  return false
end

function M.set_title(_) end

return M
