-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.spell = false
vim.opt.swapfile = false
vim.g.lazygit_config = false

if vim.g.neovide then
  -- vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.o.guifont = "CaskaydiaCove Nerd Font:h13" -- text below applies for VimScript
end
