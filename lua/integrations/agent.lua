--- Bridge that sends editor context (file, line, selection, diagnostics) to a
--- coding-agent pane in the active multiplexer.
local M = {}

local mx = require 'integrations'
local buf = require 'utils.buffers'

local function send(text)
  mx.send_to_agent(text)
end

local function is_visual(mode)
  return mode == 'v' or mode == 'V' or mode == '\22'
end

--- Send the current file, or the tail of a terminal/overseer buffer.
function M.send_file()
  local bufnr = vim.api.nvim_get_current_buf()
  if buf.is_term_or_overseer(bufnr) then
    local text = buf.last_lines(bufnr, 50)
    if vim.trim(text) ~= '' then
      send(text)
    end
    return
  end
  send('@' .. vim.fn.expand '%')
end

--- Send the current file:line, or the tail of a terminal/overseer buffer.
function M.send_line()
  local bufnr = vim.api.nvim_get_current_buf()
  if buf.is_term_or_overseer(bufnr) then
    local text = buf.last_lines(bufnr, 50)
    if vim.trim(text) ~= '' then
      send(text)
    end
    return
  end
  send(string.format('@%s:L%d', vim.fn.expand '%', vim.fn.line '.'))
end

--- Send the current selection, or selected text from a terminal buffer.
function M.send_selection()
  local bufnr = vim.api.nvim_get_current_buf()
  if buf.is_term_or_overseer(bufnr) then
    local text = buf.visual_selection_text()
    if vim.trim(text) ~= '' then
      send(text)
    end
    return
  end

  if is_visual(vim.fn.mode()) then
    vim.cmd 'normal! \27'
  end
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  send(string.format('@%s:L%d-L%d', vim.fn.expand '%', start_pos[2], end_pos[2]))
end

local SEVERITY = {
  [vim.diagnostic.severity.ERROR] = 'ERROR',
  [vim.diagnostic.severity.WARN] = 'WARN',
  [vim.diagnostic.severity.INFO] = 'INFO',
  [vim.diagnostic.severity.HINT] = 'HINT',
}

local function format_diagnostic(diag, file)
  local sev = SEVERITY[diag.severity] or 'DIAGNOSTIC'
  local code = diag.code and string.format(' (%s)', diag.code) or (diag.source and string.format(' (%s)', diag.source) or '')
  local line = (diag.lnum or 0) + 1
  local col = (diag.col or 0) + 1
  return string.format('@%s:L%d:C%d [%s] %s%s', file, line, col, sev, vim.trim(diag.message or ''), code)
end

--- Send diagnostics for the cursor line, selection, or whole buffer.
function M.send_diagnostic()
  local bufnr = vim.api.nvim_get_current_buf()
  local file = vim.fn.expand '%'
  if file == '' then
    file = vim.api.nvim_buf_get_name(bufnr)
  end

  local diags = {}
  if is_visual(vim.fn.mode()) then
    vim.cmd 'normal! \27'
    local start_line = vim.fn.getpos("'<")[2] - 1
    local end_line = vim.fn.getpos("'>")[2] - 1
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    for _, d in ipairs(vim.diagnostic.get(bufnr)) do
      if d.lnum >= start_line and d.lnum <= end_line then
        diags[#diags + 1] = d
      end
    end
  else
    local cur_line = vim.fn.line '.' - 1
    local line_diags = vim.diagnostic.get(bufnr, { lnum = cur_line })
    diags = #line_diags > 0 and line_diags or vim.diagnostic.get(bufnr)
  end

  if #diags == 0 then
    vim.notify('No diagnostics found', vim.log.levels.INFO, { title = 'Agent' })
    return
  end

  local lines = {}
  for _, diag in ipairs(diags) do
    lines[#lines + 1] = format_diagnostic(diag, file)
  end

  send(string.format('Fix the following diagnostic%s:\n%s', #diags > 1 and 's' or '', table.concat(lines, '\n')))
end

return M
