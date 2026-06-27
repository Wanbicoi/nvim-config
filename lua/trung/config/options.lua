vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- split help to right
vim.cmd [[
  cabbrev h vert h
  cabbrev term vsplit term://zsh
  cabbrev help vert help
]]
vim.o.termguicolors = true
vim.o.autowriteall = true
vim.o.exrc = true
vim.opt.tabstop = 2
vim.o.sessionoptions = 'blank,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
vim.o.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'popup_setpos'
vim.opt.mousemoveevent = true
vim.cmd 'autocmd! nvim.popupmenu'
vim.cmd.aunmenu 'PopUp' -- Remove all default menu items for PopUp
vim.opt.showmode = false
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = false
vim.o.winborder = 'single'

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.scrolloff = 1
vim.opt.autoread = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true
-- vim.o.incsearch = false
vim.o.wrap = false
vim.o.linebreak = true -- only applied when wrap is on
vim.o.cursorlineopt = 'both'
vim.o.swapfile = false
vim.wo.foldmethod = 'indent'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldenable = false -- avoid auto close all on load
vim.o.winwidth = 40
vim.o.winminwidth = 20

if vim.fn.has 'win32' == 1 then
  vim.opt.shell = 'pwsh'
  vim.opt.shellcmdflag = '-NoLogo -NoProfile -Command'
  vim.opt.shellredir = '2>&1 | Out-File -Encoding utf8 %s'
  vim.opt.shellpipe = '2>&1 | Out-File -Encoding utf8 %s'
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
end

if vim.g.neovide then
  vim.o.guifont = 'JetBrainsMono Nerd Font:h10.5' -- text below applies for VimScript
  vim.g.neovide_cursor_vfx_mode = 'pixiedust'
  -- vim.g.neovide_cursor_vfx_mode = 'sonicboom'
  vim.g.neovide_floating_shadow = false
  -- vim.g.neovide_floating_z_height = 10
  vim.g.neovide_floating_blur_amount_x = 2
  vim.g.neovide_floating_blur_amount_y = 2

  vim.g.neovide_remember_window_size = true

  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_text_contrast = 0.6
  vim.g.neovide_text_gamma = 1
  vim.g.neovide_cursor_animation_length = 0.02

  vim.g.neovide_title_background_color = '#faf4ed'
  vim.g.neovide_title_text_color = 'black'

  vim.g.neovide_progress_bar_enabled = true
  vim.g.neovide_progress_bar_height = 5.0
  vim.g.neovide_progress_bar_animation_speed = 200.0
  vim.g.neovide_progress_bar_hide_delay = 0.2

  vim.keymap.set('n', '<c-s-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<c-s-v>', '"+P')
  vim.keymap.set('c', '<c-s-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<c-s-v>', '<ESC>"+pa') -- Paste insert mode
  vim.keymap.set('t', '<c-s-v>', function()
    local text = vim.fn.getreg '+'
    vim.api.nvim_chan_send(vim.b.terminal_job_id, text)
  end, { desc = 'Paste clipboard into terminal' })

  vim.keymap.set('n', '<s-insert>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<s-insert>', '"+P')
  vim.keymap.set('c', '<s-insert>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<s-insert>', '<ESC>"+pa') -- Paste insert mode
  vim.keymap.set('t', '<s-insert>', function()
    local text = vim.fn.getreg '+'
    vim.api.nvim_chan_send(vim.b.terminal_job_id, text)
  end, { desc = 'Paste clipboard into terminal' })
end

-- disable builtin colorscheme
vim.opt.wildignore:append {
  'blue.vim',
  'darkblue.vim',
  'delek.vim',
  'desert.vim',
  'elflord.vim',
  'evening.vim',
  'industry.vim',
  'habamax.vim',
  'koehler.vim',
  'lunaperche.vim',
  'morning.vim',
  'murphy.vim',
  'pablo.vim',
  'peachpuff.vim',
  'quiet.vim',
  'ron.vim',
  'shine.vim',
  'slate.vim',
  'sorbet.vim',
  'retrobox.vim',
  'torte.vim',
  'wildcharm.vim',
  'zaibatsu.vim',
  'vim.lua',
  'unokai.vim',
  'randomhue.lua',
  'minischeme.lua',
  'miniautumn.lua',
  'minispring.lua',
  'miniwinter.lua',
  'minisummer.lua',
  'default.vim',
  'minicyan.lua',
  'zellner.vim',
}

vim.cmd [[packadd nvim.undotree]]
