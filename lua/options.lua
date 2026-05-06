vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.o.exrc = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'popup_setpos'
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
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.autoread = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true
-- vim.o.incsearch = false
vim.o.wrap = false
vim.o.cursorlineopt = 'both'
vim.o.swapfile = false
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldenable = false
vim.cmd [[set sessionoptions-=blank,help,terminal]]
vim.o.winwidth = 40
vim.o.winminwidth = 20

if vim.fn.has("win32") == 1 then
  vim.opt.shell = "pwsh"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -Command"
  vim.opt.shellredir = "2>&1 | Out-File -Encoding utf8 %s"
  vim.opt.shellpipe  = "2>&1 | Out-File -Encoding utf8 %s"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end

if vim.g.neovide then
  vim.o.guifont = 'CodeNewRoman Nerd Font Propo:h11' -- text below applies for VimScript
  vim.g.neovide_cursor_vfx_mode = 'pixiedust'
  -- vim.g.neovide_cursor_vfx_mode = 'sonicboom'
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_floating_blur_amount_x = 0
  vim.g.neovide_floating_blur_amount_y = 0

  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_text_contrast = 0.6
  vim.g.neovide_text_gamma = 1
  vim.g.neovide_cursor_animation_length = 0.02

  vim.g.neovide_title_background_color = 'white'
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

-- 🆙 Support ascx filetype
vim.filetype.add { extension = { ascx = 'html', json = 'jsonc' } }
vim.treesitter.language.register('html', 'ascx')

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
