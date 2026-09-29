--- Shared floating-window geometry for Snacks terminals/lazygit.
local M = {}

---@return table
function M.float_win()
  local width = vim.o.columns > 180 and 160 or math.floor(vim.o.columns * 0.9)
  return {
    position = 'float',
    backdrop = false,
    border = 'rounded',
    width = width,
    height = math.floor(vim.o.lines * 0.9),
  }
end

---@param opts table|nil
---@return table
function M.shell_float_opts(opts)
  return vim.tbl_deep_extend('force', { win = M.float_win() }, opts or {})
end

return M
