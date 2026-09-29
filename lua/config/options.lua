vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.background = 'light'
vim.opt.shada = "!,'100000,<50,s10,h,r/tmp/,r/private"
vim.o.termguicolors = true
vim.o.autowriteall = true
-- exrc allows a project-local `.nvim.lua` to run. Keep it on only if you trust
-- every repo you open; see `:help 'exrc'`.
vim.o.exrc = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.o.sessionoptions = 'blank,curdir,folds,help,tabpages,winsize,winpos'
vim.o.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'popup_setpos'
vim.opt.mousetime = 240
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
vim.o.sidescrolloff = 5 -- Set a large value
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

-- Fold settings
vim.wo.foldenable = true
vim.wo.foldlevel = 99
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

if vim.fn.has 'win32' == 1 then
  vim.opt.shell = 'pwsh'
  vim.opt.shellcmdflag = '-NoLogo -NoProfile -Command'
  vim.opt.shellredir = '2>&1 | Out-File -Encoding utf8 %s'
  vim.opt.shellpipe = '2>&1 | Out-File -Encoding utf8 %s'
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
end

local function paste_into_terminal()
  vim.api.nvim_chan_send(vim.b.terminal_job_id, vim.fn.getreg '+')
end

local function set_paste_keys(key)
  vim.keymap.set('n', key, '"+P')
  vim.keymap.set('v', key, '"+P')
  vim.keymap.set('c', key, '<C-R>+')
  vim.keymap.set('i', key, '<ESC>"+pa')
  vim.keymap.set('t', key, paste_into_terminal, { desc = 'Paste clipboard into terminal' })
end

-- Neovide-specific setup, applied once the GUI attaches.
vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    if not vim.g.neovide then
      return
    end

    vim.o.guifont = 'JetBrainsMono Nerd Font:h10'
    vim.g.neovide_cursor_vfx_mode = 'pixiedust'
    vim.g.neovide_floating_shadow = false
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

    set_paste_keys '<c-s-v>'
    set_paste_keys '<s-insert>'
  end,
})

-- Hide builtin colorschemes from `:colorscheme` completion
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
  'minicyan.lua',
  'zellner.vim',
}

-- Builtin with Neovim; provides :Undotree
vim.cmd [[packadd nvim.undotree]]
