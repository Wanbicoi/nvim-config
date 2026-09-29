--- WezTerm adapter (tab title only).
local M = { name = 'wezterm' }

M.capabilities = {
  title = true,
  captures_ctrl_left_press = false,
}

local function wezterm_bin()
  if vim.fn.executable 'wezterm.exe' == 1 then
    return 'wezterm.exe'
  end
  if vim.fn.executable 'wezterm' == 1 then
    return 'wezterm'
  end
  return nil
end

function M.available()
  return wezterm_bin() ~= nil
end

function M.set_title(title)
  local bin = wezterm_bin()
  if not bin or not title or title == '' then
    return
  end
  vim.fn.system { bin, 'cli', 'set-tab-title', title }
end

return M
