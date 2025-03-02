require "nvchad.options"

-- add yours here!

vim.o.cursorlineopt = "both" -- to enable cursorline!
vim.o.shell = "powershell"   -- to enable cursorline!
vim.g.gutentags_file_list_command = "rg --files"

vim.o.relativenumber = true
vim.o.wrap = false

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})
