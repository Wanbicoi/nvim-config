require "nvchad.options"

-- add yours here!

vim.o.cursorlineopt = "both"
vim.o.shell = "powershell"
vim.o.swapfile = false

vim.g.gutentags_file_list_command = "rg --files"

vim.o.relativenumber = true
vim.o.wrap = false

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
