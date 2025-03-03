require "nvchad.options"

vim.o.relativenumber = true
vim.o.wrap = false
vim.o.cursorlineopt = "both"
vim.o.swapfile = false
vim.o.scrolloff = 7
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldenable = false
vim.cmd([[set sessionoptions-=blank,help,terminal]])
vim.o.winwidth = 40
vim.o.winminwidth = 20

vim.cmd [[
  let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
  let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
  let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  set shellquote= shellxquote=
]]

vim.g.gutentags_file_list_command = "rg --files"
vim.g.gutentags_cache_dir = vim.fn.stdpath("cache") .. "/vim-gutentags"
--vim.g.gutentags_trace = true
vim.g.gutentags_ctags_exclude = {
  ".git", ".hg", ".svn", ".pijul", "_darcs", "node_modules", "vendor",
  "venv", "__pypackages__", "packages", "Pods", "target", "build", "dist", "libs", "out", "bin", "obj",
  "*.o", "*.exe", "*.dll", "*.so", "*.dylib", "*.pyc", "__pycache__", "*.class", "*.jar", "*.war", "*.ear", ".next",
  "coverage", "*.log", "*.min.js", "*.min.css", "*.map", "*.lock", "*.json", "*.xml", "*.pdf", "*.doc", "*.docx", "*.svg",
  "*.png", "*.jpg", "*.jpeg", "*.gif", "*.ico",
  "*.swp", "*.swo", "*.bak", "*.tmp", "*.cache", ".DS_Store", "*.db", "*.yaml", "*.yml", "*.suo", "*.user", "*.sln",
}

-- 🆙 Support ascx filetype
vim.filetype.add({ extension = { ascx = "html" } })
vim.treesitter.language.register('html', 'ascx')

-- 🏧 autocmd
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("TermClose", {
  callback = function()
    vim.api.nvim_input("<CR>")
  end,
})
