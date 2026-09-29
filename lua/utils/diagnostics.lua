--- Shared diagnostic helpers (severity names, formatting, cursor lookup).
local M = {}

local SEVERITY = {
  [vim.diagnostic.severity.ERROR] = 'ERROR',
  [vim.diagnostic.severity.WARN] = 'WARN',
  [vim.diagnostic.severity.INFO] = 'INFO',
  [vim.diagnostic.severity.HINT] = 'HINT',
}

---@param severity integer|nil
---@return string
function M.severity_name(severity)
  return SEVERITY[severity] or 'INFO'
end

--- Format a diagnostic as `@file:Lline:Ccol [SEV] message (code)`.
---@param diag table
---@param file string
---@return string
function M.format(diag, file)
  local sev = M.severity_name(diag.severity)
  local code = diag.code and string.format(' (%s)', diag.code) or (diag.source and string.format(' (%s)', diag.source) or '')
  local line = (diag.lnum or 0) + 1
  local col = (diag.col or 0) + 1
  return string.format('@%s:L%d:C%d [%s] %s%s', file, line, col, sev, vim.trim(diag.message or ''), code)
end

--- Diagnostic under the cursor, falling back to the first on the line.
---@param bufnr integer|nil
---@return table|nil
function M.under_cursor(bufnr)
  bufnr = bufnr or 0
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum = cursor[1] - 1
  local col = cursor[2]
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })

  for _, d in ipairs(diagnostics) do
    local end_col = d.end_col or d.col
    if col >= d.col and col <= end_col then
      return d
    end
  end

  return diagnostics[1]
end

return M
