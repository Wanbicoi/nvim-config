-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

if not vim.g.vscode then
  function ToggleTheme()
    if vim.o.background == "light" then
      vim.cmd("set background=dark")
    else
      vim.cmd("set background=light")
    end
  end

  vim.api.nvim_set_keymap("n", "<F5>", ":lua ToggleTheme()<CR>", { noremap = true, silent = true })

  vim.api.nvim_set_keymap("n", "\\", "<leader>bd", {})
end

vim.api.nvim_set_keymap("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })

-- Add border to term
vim.keymap.del("n", "<C-_>")
vim.keymap.del("n", "<C-/>")
local lazyterm = function()
  LazyVim.terminal(nil, { cwd = LazyVim.root(), border = "rounded" })
end
vim.keymap.set("n", "<C-_>", lazyterm, { desc = "Term with border" })
vim.keymap.set("n", "<C-/>", lazyterm, { desc = "Term with border" })
