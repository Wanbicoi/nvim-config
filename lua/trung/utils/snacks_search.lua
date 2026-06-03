local M = {}

local root_patterns = { '.git', '.gitignore', 'Cargo.toml', 'package.json', 'go.mod', '.sln', '.csproj', 'AGENTS.md' }

local function get_cwd()
  return vim.fn.getcwd()
end

local function normalize_text(text)
  return vim.trim((text or ''):gsub('[\n\r]', ' '))
end

function M.get_project_root(bufnr)
  bufnr = bufnr or 0
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' then
    return get_cwd()
  end

  return vim.fs.root(path, root_patterns) or get_cwd()
end

function M.get_visual_selection()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_row, start_col = start_pos[2], start_pos[3]
  local end_row, end_col = end_pos[2], end_pos[3]

  if start_row == 0 or end_row == 0 then
    return ''
  end

  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})
  return normalize_text(table.concat(lines, '\n'))
end

function M.with_cwd(picker, opts, cwd)
  opts = vim.tbl_extend('force', {}, opts or {})
  opts.cwd = cwd
  return Snacks.picker[picker](opts)
end

function M.project(picker, opts, bufnr)
  return M.with_cwd(picker, opts, M.get_project_root(bufnr))
end

function M.pwd(picker, opts)
  return M.with_cwd(picker, opts, get_cwd())
end

function M.grep_cword_project()
  M.project('grep', { search = vim.fn.expand '<cword>' })
end

function M.grep_cword_pwd()
  M.pwd('grep', { search = vim.fn.expand '<cword>' })
end

function M.grep_visual_project()
  local text = M.get_visual_selection()
  if text ~= '' then
    M.project('grep', { search = text })
  end
end

function M.grep_visual_pwd()
  local text = M.get_visual_selection()
  if text ~= '' then
    M.pwd('grep', { search = text })
  end
end

return M
