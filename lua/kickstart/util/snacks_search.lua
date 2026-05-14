local M = {}

local root_patterns = { '.git', '.gitignore', 'Cargo.toml', 'package.json', 'go.mod', '.sln', '.csproj' }

local function get_cwd()
  return vim.fn.getcwd()
end

function M.get_project_root(bufnr)
  bufnr = bufnr or 0
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' then
    return get_cwd()
  end

  return vim.fs.root(path, root_patterns) or get_cwd()
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

return M
