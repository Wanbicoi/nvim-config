---@diagnostic disable: missing-fields
--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/

  And then you can explore or search through `:help lua-guide`


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true
-- Enable mouse mode
vim.o.mouse = 'a'

vim.o.scrolloff = 5

-- Indenting
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2

vim.o.ignorecase = true
vim.o.smartcase = true

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.go.undofile = true
vim.go.swapfile = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'
vim.o.wrap = false

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.cmd "set shada=!,'100,s10,h,<10000"

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
vim.keymap.set('v', 'p', 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })

-- Remap for dealing with word wrap vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Buffers manager
-- vim.keymap.set('n', '<leader>n', '<cmd>bnext<cr>')
-- vim.keymap.set('n', '<leader>N', '<cmd>bprevious<cr>')
vim.keymap.set('n', '<leader>x', '<cmd>Bdelete<cr>', { desc = 'Close current buffer' })
-- vim.keymap.set('n', '<leader>X', '<cmd>:%bd|e#<cr>', { desc = 'Close other buffers' })

-- Window navigate

vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })

vim.keymap.set('n', '<C-c>', '<cmd> %y+ <CR>', { desc = 'Copy whole file' })
vim.keymap.set('n', '<esc>', '<cmd>noh<cr>', { desc = 'No highlight', silent = true })

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { desc = 'NvimTreeToggle' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev { float = { border = 'rounded' } }
end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next { float = { border = 'rounded' } }
end, { desc = 'Go to next diagnostic message' })

-- [[ Auto commands ]]
-- High light on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
-- Format on save
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   callback = function()
--     vim.lsp.buf.format()
--   end,
--   pattern = '*',
-- })
