--- Minimal in-Neovim coding-agent terminal.
---
--- Runs the agent in a Snacks terminal (one per project root) and routes editor
--- context (file, line, selection, diagnostics) into it, so no external
--- multiplexer pane is needed.
local M = {}

--- Change this to the agent you use (eg. 'claude', 'codex', 'agy').
local AGENT_CMD = 'opencode'

local snacks_search = require 'utils.snacks_search'
local buf = require 'utils.buffers'
local diagnostics = require 'utils.diagnostics'

local function term_opts()
  return {
    count = 1,
    cwd = snacks_search.get_project_root(),
    auto_close = false,
    win = {
      position = 'right',
      width = 0.4,
      wo = { winbar = "%{get(b:, 'term_title', 'agent')}" },
    },
  }
end

--- Get or create the agent terminal for the current project root.
---@return snacks.terminal|nil
function M.get()
  return Snacks.terminal.get(AGENT_CMD, term_opts())
end

--- Toggle (show/focus or hide) the agent terminal.
function M.toggle()
  Snacks.terminal.toggle(AGENT_CMD, term_opts())
end

--- Send text to the agent terminal, opening it if needed.
---@param text string
function M.send(text)
  if not text or text == '' then
    return
  end

  local term = M.get()
  if not term or not term:buf_valid() then
    return
  end

  if text:sub(-1) ~= '\n' then
    text = text .. '\n'
  end
  vim.api.nvim_chan_send(vim.b[term.buf].terminal_job_id, text)
  term:focus()
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
      M.send(text)
    end
    return
  end
  M.send('@' .. vim.fn.expand '%')
end

--- Send the current file:line, or the tail of a terminal/overseer buffer.
function M.send_line()
  local bufnr = vim.api.nvim_get_current_buf()
  if buf.is_term_or_overseer(bufnr) then
    local text = buf.last_lines(bufnr, 50)
    if vim.trim(text) ~= '' then
      M.send(text)
    end
    return
  end
  M.send(string.format('@%s:L%d', vim.fn.expand '%', vim.fn.line '.'))
end

--- Send the current selection, or selected text from a terminal buffer.
function M.send_selection()
  local bufnr = vim.api.nvim_get_current_buf()
  if buf.is_term_or_overseer(bufnr) then
    local text = buf.visual_selection_text()
    if vim.trim(text) ~= '' then
      M.send(text)
    end
    return
  end

  if is_visual(vim.fn.mode()) then
    vim.cmd 'normal! \27'
  end
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  M.send(string.format('@%s:L%d-L%d', vim.fn.expand '%', start_pos[2], end_pos[2]))
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
    lines[#lines + 1] = diagnostics.format(diag, file)
  end

  M.send(string.format('Fix the following diagnostic%s:\n%s', #diags > 1 and 's' or '', table.concat(lines, '\n')))
end

return M
