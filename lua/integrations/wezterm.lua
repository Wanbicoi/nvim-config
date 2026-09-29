--- WezTerm adapter. WezTerm cannot report the foreground command of a pane, so
--- only tab-title support is exposed; pane discovery/send is left to the
--- multiplexer running inside WezTerm (zellij/tmux).
local M = { name = 'wezterm' }

M.capabilities = {
  title = true,
  panes = false,
  send = false,
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

function M.current_pane_id()
  return vim.env.WEZTERM_PANE
end

function M.panes()
  return {}
end

function M.send() end

function M.focus() end

return M
