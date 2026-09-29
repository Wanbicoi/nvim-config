--- Shared buffer helpers used by pickers, the agent bridge, and autocmds.
local M = {}

--- True when the buffer is a terminal or an overseer task/output buffer.
---@param bufnr integer|nil
---@return boolean
function M.is_term_or_overseer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local bt = vim.bo[bufnr].buftype
  local ft = (vim.bo[bufnr].filetype or ''):lower()
  local name = vim.api.nvim_buf_get_name(bufnr):lower()

  if bt == 'terminal' or ft == 'terminal' or name:match '^term://' then
    return true
  end
  if ft:find 'overseer' or vim.b[bufnr].overseer_task ~= nil or name:match '^overseer://' then
    return true
  end
  if vim.b[bufnr].snacks_terminal ~= nil then
    return true
  end
  return false
end

--- Last `count` lines of a buffer, ignoring trailing blank lines.
---@param bufnr integer|nil
---@param count integer|nil
---@return string
function M.last_lines(bufnr, count)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  count = count or 50
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  while #lines > 0 and vim.trim(lines[#lines]) == '' do
    table.remove(lines)
  end
  if #lines == 0 then
    return ''
  end
  local start_idx = math.max(1, #lines - count + 1)
  local out = {}
  for i = start_idx, #lines do
    out[#out + 1] = lines[i]
  end
  return table.concat(out, '\n')
end

--- Current visual selection as text, leaving visual mode.
---@return string
function M.visual_selection_text()
  local mode = vim.fn.mode()
  if mode:match '[vV\22]' then
    vim.cmd 'normal! \27'
  end
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  if start_pos[2] == 0 or end_pos[2] == 0 then
    return ''
  end
  local vmode = vim.fn.visualmode()
  local lines = vim.fn.getregion(start_pos, end_pos, { type = vmode ~= '' and vmode or 'v' })
  return table.concat(lines, '\n')
end

--- Normalized (single-line) visual selection, for search queries.
---@return string
function M.visual_selection_search()
  return vim.trim((M.visual_selection_text()):gsub('[\n\r]', ' '))
end

return M
