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

require('integrations.neovide').setup()

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
