-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.o.pumblend = 0
vim.o.winblend = 0
vim.opt.spell = false
vim.opt.swapfile = false
vim.g.lazygit_config = false
vim.g.root_spec = { ".git", "lsp", "lua", "cwd" }
vim.o.cursorlineopt = "number"

if vim.g.nvui then
  vim.o.guifont = "CaskaydiaCove NF:h12"
  vim.cmd([[NvuiAnimationsEnabled 1]])
  vim.cmd([[NvuiCmdline 1]])
  vim.cmd([[NvuiCmdCenterXPos 0.5]])
  vim.cmd([[NvuiCmdCenterYPos 0.5]])
  vim.cmd([[NvuiCursorAnimationDuration 0.2]])
  vim.cmd([[NvuiCmdPadding 10]])
  vim.cmd([[NvuiCmdPadding 10]])
  vim.cmd([[NvuiCmdFontFamily CaskaydiaCove NF]])
  vim.cmd([[NvuiCmdBigFontScaleFactor 1]])
  vim.cmd([[NvuiSnapshotLimit 10]])
end

if vim.g.neovide then
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
end
