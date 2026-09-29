local M = {}

local root_patterns = { '.git', 'go.mod', '.sln', '.csproj', 'AGENTS.md' }

local function get_cwd()
  return vim.fn.getcwd()
end

function M.get_project_root(target)
  local path
  if type(target) == 'string' and target ~= '' then
    path = target
  else
    local bufnr = (type(target) == 'number' and target) or 0
    path = vim.api.nvim_buf_get_name(bufnr)
  end

  if not path or path == '' then
    return get_cwd()
  end

  return vim.fs.root(path, root_patterns) or get_cwd()
end

function M.get_visual_selection()
  return require('utils.buffers').visual_selection_search()
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
  M.project('grep', { search = vim.fn.expand '<cword>', supports_live = true })
end

function M.grep_cword_pwd()
  M.pwd('grep', { search = vim.fn.expand '<cword>', supports_live = true })
end

function M.grep_visual_project()
  local text = M.get_visual_selection()
  if text ~= '' then
    M.project('grep', { search = text, supports_live = true })
  end
end

function M.grep_visual_pwd()
  local text = M.get_visual_selection()
  if text ~= '' then
    M.pwd('grep', { search = text, supports_live = true })
  end
end

return M
