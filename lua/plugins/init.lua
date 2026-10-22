-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  require 'plugins.coding',
  require 'plugins.ui',
  require 'plugins.colorscheme',
  require 'plugins.git',
  require 'plugins.lsp',
  require 'plugins.test',
  require 'plugins.terminal',

  -- Optional extras
  -- require 'plugins.extras.debug',
  -- require 'plugins.extras.lint',
  -- require 'plugins.extras.ctags',
  -- require 'plugins.extras.avante',
  -- require 'plugins.extras.bookmarks',
  require 'plugins.extras.dotnet',
  require 'plugins.extras.kulala',
  require 'plugins.extras.herdr',
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
