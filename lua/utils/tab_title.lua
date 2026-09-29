--- Set the multiplexer pane/tab title from a session name (or the cwd).
local M = {}

---@param session_name string|nil
function M.set(session_name)
  local title = session_name
  if type(title) ~= 'string' or title == '' then
    title = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  else
    title = vim.fn.fnamemodify(title:gsub('/+$', ''), ':t')
  end

  if title and title ~= '' then
    require('integrations').set_title(title)
  end
end

return M
