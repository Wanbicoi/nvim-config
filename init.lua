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
vim.opt.mousemodel = 'popup'
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

if vim.fn.has 'win32' == 1 then
  vim.opt.shell = 'pwsh'
  vim.opt.shellcmdflag =
    '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  vim.opt.shellredir = '2>&1 | Out-File -Encoding UTF8 %s'
  vim.opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s'
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
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

  vim.keymap.set('n', '<c-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<C-v>', '"+P')
  vim.keymap.set('c', '<c-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<c-v>', '<ESC>"+pa') -- Paste insert mode
  vim.keymap.set('t', '<C-v>', function()
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

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<c-q>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<c-s>', '<cmd>:w<cr>', { desc = 'Save all files' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have coliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

vim.keymap.set('n', ']e', function()
  vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, count = 1 }
end)
vim.keymap.set('n', '[e', function()
  vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, count = -1 }
end)

vim.keymap.set('n', '<C-Up>', '<C-w>5+')
vim.keymap.set('n', '<C-Down>', '<C-w>5-')
vim.keymap.set('n', '<C-Left>', '<C-w>20<')
vim.keymap.set('n', '<C-Right>', '<C-w>20>')

vim.keymap.set('n', '<leader>cP', function()
  vim.cmd 'let @+ = expand("%:p")'
  vim.notify('Full path copied to clipboard', vim.log.levels.INFO, { title = 'Path Copied' })
end, { desc = '[C]opy full current file path' })

vim.keymap.set('n', '<leader>cp', function()
  vim.cmd 'let @+ = expand("%")'
  vim.notify('Relative path copied to clipboard', vim.log.levels.INFO, { title = 'Path Copied' })
end, { desc = '[C]opy relative current file path' })

vim.keymap.set('n', 'q', '<cmd>q<CR>', { noremap = true })

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

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Add diffget to right-click menu when in diff mode
vim.api.nvim_create_autocmd({ 'OptionSet' }, {
  desc = 'Add diffget to right-click menu in diff mode',
  group = vim.api.nvim_create_augroup('diff-mode-popup', { clear = true }),
  pattern = 'diff',
  callback = function()
    if vim.wo.diff then
      -- Add diffget menu item when entering diff mode
      vim.cmd.amenu '20.10 PopUp.-DiffSep- :'
      vim.cmd.amenu '20.20 PopUp.Diff\\ Get <cmd>diffget<CR>'
      vim.cmd.amenu '20.30 PopUp.Diff\\ Put <cmd>diffput<CR>'
    else
      -- Remove diff menu items when leaving diff mode
      pcall(vim.cmd.aunmenu, 'PopUp.-DiffSep-')
      pcall(vim.cmd.aunmenu, 'PopUp.Diff\\ Get')
      pcall(vim.cmd.aunmenu, 'PopUp.Diff\\ Put')
    end
  end,
})

-- Also add the menu items when first opening a diff buffer
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  desc = 'Setup diff menu on buffer enter if in diff mode',
  group = vim.api.nvim_create_augroup('diff-mode-bufenter', { clear = true }),
  callback = function()
    if vim.wo.diff then
      pcall(vim.cmd.aunmenu, 'PopUp.-DiffSep-')
      pcall(vim.cmd.aunmenu, 'PopUp.Diff\\ Get')
      pcall(vim.cmd.aunmenu, 'PopUp.Diff\\ Put')
      vim.cmd.amenu '20.10 PopUp.-DiffSep- :'
      vim.cmd.amenu '20.20 PopUp.Diff\\ Get <cmd>diffget<CR>'
      vim.cmd.amenu '20.30 PopUp.Diff\\ Put <cmd>diffput<CR>'
    end
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'nmac427/guess-indent.nvim',
    event = 'VeryLazy',
    config = function()
      require('guess-indent').setup {}
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {},
  },
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 500,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]iff' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]est / [T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>o', group = '[O]verseer' },
        { '<leader>s', group = '[S]wap Textobjects' },
      },
    },
  },
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-frecency.nvim' },
      { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    keys = {
      {
        '<leader><leader>',
        function()
          require('telescope.builtin').git_files { show_untracked = true }
        end,
        desc = '[F]ind [G]it Files',
      },
      {
        '<leader>fa',
        function()
          require('telescope.builtin').find_files { no_ignore = true, hidden = true }
        end,
        desc = '[F]ind [A]ll',
      },
      {
        '<leader>ff',
        function()
          require('telescope.builtin').find_files()
        end,
        desc = '[F]ind [F]iles',
      },
      {
        '<leader>ft',
        function()
          require('telescope.builtin').builtin()
        end,
        desc = '[F]ind [T]elescope',
      },
      {
        '<leader>fW',
        function()
          local word = vim.fn.expand '<cword>'
          require('telescope.builtin').find_files { search_file = word, prompt_title = 'Files: ' .. word }
        end,
        desc = '[F]ind file of the current [W]ord',
      },
      {
        '<leader>fw',
        function()
          require('telescope.builtin').grep_string()
        end,
        desc = '[F]ind current [W]ord',
      },
      {
        '<leader>/',
        function()
          require('telescope.builtin').live_grep()
        end,
        desc = '[G]rep',
      },
      {
        '<leader>?',
        function()
          local text = vim.fn.getreg '+'
          text = vim.trim(text:gsub('[\n\r]', ' '))
          require('telescope.builtin').live_grep {
            default_text = text,
          }
        end,
        desc = '[G]rep with copied text',
      },
      {
        '<leader>fr',
        function()
          require('telescope.builtin').resume()
        end,
        desc = '[F]ind [R]esume',
      },
      {
        '<leader>fo',
        function()
          require('telescope.builtin').oldfiles()
        end,
        desc = '[F]ind Recent Files ("." for repeat)',
      },
      {
        '_',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = '[_] Find existing buffers',
      },
      {
        '<leader>v',
        function()
          require('telescope.builtin').registers()
        end,
        desc = '[v] Find Registers',
      },
      {
        '<leader>gs',
        function()
          require('telescope.builtin').git_status()
        end,
        desc = 'Find [G]it [S]tatus',
      },
      {
        '<leader>gB',
        function()
          require('telescope.builtin').git_bcommits()
        end,
        desc = 'Find [G]it [B]uffer commits',
      },
      {
        '<leader>gb',
        function()
          require('telescope.builtin').git_branches()
        end,
        desc = 'Find [G]it [B]ranches',
      },
      {
        '<leader>fc',
        function()
          require('telescope.builtin').commands()
        end,
        desc = '[F]ind [C]ommands',
      },
      {
        '<leader>fn',
        function()
          require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[F]ind [N]eovim files',
      },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_strategy = 'vertical',
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
            height = 0.9,
          },
          mappings = {
            i = {
              ['<c-v>'] = false,
              ['<esc>'] = require('telescope.actions').close,
            },
          },
        },
        -- defaults = require('telescope.themes').get_ivy {
        --   path_display = { 'truncate' },
        --   -- layout_config = {
        --   --   width = 0.8,
        --   -- },
        -- },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'frecency')
    end,
  },
  {
    'folke/lazydev.nvim',
    lazy = false,
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  -- LSP Plugins
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      {
        'mason-org/mason.nvim',
        opts = {
          registries = {
            'github:mason-org/mason-registry',
            'github:Crashdummyy/mason-registry',
          },
        },
      },
      'mason-org/mason-lspconfig.nvim',
      'folke/lazydev.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      -- Allows extra capabilities provided by blink.cmp
      {
        'seblyng/roslyn.nvim',
        ---@module 'roslyn.config'
        ---@type RoslynNvimConfig
        opts = {
          -- your configuration comes here; leave empty for default settings
        },
        ft = { '.cs', '.sln', '.csproj' },
        config = function()
          vim.lsp.config('roslyn', {
            on_attach = function()
              print 'This will run when the server attaches!'
            end,
            settings = {
              ['csharp|inlay_hints'] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
              },
              ['csharp|code_lens'] = {
                dotnet_enable_references_code_lens = true,
              },
            },
          })
        end,
      },
      'saghen/blink.cmp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- Add LSP functions to the right-click PopUp menu
          vim.cmd.amenu '10.10 PopUp.LSP\\ Definitions <cmd>lua require("telescope.builtin").lsp_definitions()<CR>'
          vim.cmd.amenu '10.20 PopUp.LSP\\ References <cmd>lua require("telescope.builtin").lsp_references()<CR>'
          vim.cmd.amenu '10.30 PopUp.LSP\\ Implementations <cmd>lua require("telescope.builtin").lsp_implementations()<CR>'
          vim.cmd.amenu '10.40 PopUp.LSP\\ Type\\ Definition <cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>'
          vim.cmd.amenu '10.50 PopUp.LSP\\ Declaration <cmd>lua vim.lsp.buf.declaration()<CR>'
          vim.cmd.amenu '10.60 PopUp.LSP\\ Rename <cmd>lua vim.lsp.buf.rename()<CR>'
          vim.cmd.amenu '10.70 PopUp.LSP\\ Code\\ Action <cmd>lua vim.lsp.buf.code_action()<CR>'
          vim.cmd.amenu '10.80 PopUp.LSP\\ Document\\ Symbols <cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>'
          vim.cmd.amenu '10.90 PopUp.LSP\\ Workspace\\ Symbols <cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>'

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          if vim.fn.has 'nvim-0.12' == 1 then
            if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlineCompletion, event.buf) then
              vim.lsp.inline_completion.enable(true, { bufnr = event.buf })
              vim.keymap.set('i', '<c-f>', vim.lsp.inline_completion.get, { desc = 'LSP: accept inline completion', buffer = event.buf })
              vim.keymap.set('i', '<c-g>', vim.lsp.inline_completion.select, { desc = 'LSP: switch inline completion', buffer = event.buf })
            end
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local servers = {
        -- copilot = {},
        cssls = {},
        pyright = {},
        jsonls = {},
        yamlls = {},
        -- tailwindcss = {},
        gopls = {},
        -- biome = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        -- csharp_ls = {},
      }
      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = false,
        automatic_enable = {
          exclude = { 'rust_analyzer', 'ts_ls', 'csharp_ls' },
        },
        -- handlers = {
        --   function(server_name)
        --     local server = servers[server_name] or {}
        --     server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        --     -- vim.lsp.config(server_name, server)
        --     -- vim.lsp.enable(server_name)
        --   end,
        -- },
      }
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      settings = {
        expose_as_code_action = 'all',
      },
    },
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json' },
  },
  -- {
  --   'rmagatti/goto-preview',
  --   dependencies = { 'rmagatti/logger.nvim' },
  --   event = 'BufEnter',
  --   config = true,
  --   init = function()
  --     vim.keymap.set('n', 'gp', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true, desc = '[G]oto [P]review Definitions' })
  --   end,
  -- },
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>fm',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]or[m]at buffer',
      },
    },
    opts = {
      notify_on_error = false,
      -- format_on_save = function(bufnr)
      --   -- Disable "format_on_save lsp_fallback" for languages that don't
      --   -- have a well standardized coding style. You can add additional
      --   -- languages here or re-enable it for the disabled ones.
      --   local disable_filetypes = { c = true, cpp = true }
      --   if disable_filetypes[vim.bo[bufnr].filetype] then
      --     return nil
      --   else
      --     return {
      --       timeout_ms = 500,
      --       lsp_format = 'fallback',
      --     }
      --   end
      -- end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        python = { 'ruff_format' },
        json = { 'prettierd' },
        yaml = { 'prettierd' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        sql = { 'sleek' },
        bash = { 'beautysh' },
        zsh = { 'beautysh' },
        markdown = { 'prettierd' },
      },
    },
  },
  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets', 'xzbdmw/colorful-menu.nvim', 'folke/lazydev.nvim' },
    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<c-c>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<c-l>'] = { 'snippet_forward', 'fallback' },
        ['<c-h>'] = { 'snippet_backward', 'fallback' },
        ['<Tab>'] = {
          'select_and_accept',
          'snippet_forward',
          'fallback',
        },
        ['<c-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<c-d>'] = { 'scroll_documentation_down', 'fallback' },
      },
      cmdline = {
        enabled = true,
        keymap = {
          ['<Tab>'] = { 'show', 'accept', 'fallback' },
          ['<S-Tab>'] = { 'show', 'select_prev', 'fallback' },
          ['<C-n>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback' },
        },
        completion = {
          menu = { auto_show = true },
        },
      },
      completion = {
        documentation = { window = { border = 'single' }, auto_show = true },
        ghost_text = { enabled = true },
        menu = {
          border = 'single',
          draw = {
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            columns = { { 'kind_icon' }, { 'label', gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },
      signature = { window = { border = 'single' }, enabled = true },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lsp = { fallbacks = {} },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
  -- {
  --   'folke/sidekick.nvim',
  --   event = 'VeryLazy',
  --   dependencies = { 'nvim-telescope/telescope.nvim' },
  --   opts = {
  --     picker = 'telescope',
  --     cli = {
  --       win = {
  --         layout = 'float',
  --         float = {
  --           width = 0.9,
  --           height = 0.8,
  --           border = 'single',
  --         },
  --         keys = {
  --           hide_alt_a = { '<a-a>', 'hide', mode = 'nt', desc = 'hide the terminal window' },
  --           prompt = false,
  --         },
  --       },
  --     },
  --   },
  --   keys = {
  --     {
  --       '<a-a>',
  --       function()
  --         require('sidekick.cli').toggle()
  --       end,
  --       desc = 'Sidekick Toggle CLI',
  --     },
  --     {
  --       '<leader>aa',
  --       function()
  --         require('sidekick.cli').toggle()
  --       end,
  --       desc = 'Sidekick Toggle CLI',
  --     },
  --     {
  --       '<leader>as',
  --       function()
  --         require('sidekick.cli').select()
  --       end,
  --       desc = 'Select CLI',
  --     },
  --     {
  --       '<leader>ad',
  --       function()
  --         require('sidekick.cli').close()
  --       end,
  --       desc = 'Detach a CLI Session',
  --     },
  --     {
  --       '<leader>at',
  --       function()
  --         require('sidekick.cli').send { msg = '{this}' }
  --       end,
  --       mode = { 'x', 'n' },
  --       desc = 'Send This',
  --     },
  --     {
  --       '<leader>af',
  --       function()
  --         require('sidekick.cli').send { msg = '{file}' }
  --       end,
  --       desc = 'Send File',
  --     },
  --     {
  --       '<leader>av',
  --       function()
  --         require('sidekick.cli').send { msg = '{selection}' }
  --       end,
  --       mode = { 'x' },
  --       desc = 'Send Visual Selection',
  --     },
  --     {
  --       '<leader>ap',
  --       function()
  --         require('sidekick.cli').prompt()
  --       end,
  --       mode = { 'n', 'x' },
  --       desc = 'Sidekick Select Prompt',
  --     },
  --     {
  --       '<c-n>',
  --       function()
  --         require('sidekick').nes_jump_or_apply()
  --       end,
  --       mode = 'n',
  --       desc = 'Goto/Apply Next Edit Suggestion',
  --     },
  --   },
  -- },
  {
    'copilotlsp-nvim/copilot-lsp',
    event = 'VeryLazy',
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable 'copilot_ls'
      vim.keymap.set('n', '<esc>', function()
        if not require('copilot-lsp.nes').clear() then
          vim.cmd 'nohlsearch'
        end
      end, { desc = 'Clear Copilot suggestion or fallback' })
      vim.keymap.set('n', '<tab>', function()
        local bufnr = vim.api.nvim_get_current_buf()
        local state = vim.b[bufnr].nes_state
        if state then
          -- Try to jump to the start of the suggestion edit.
          -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
          local _ = require('copilot-lsp.nes').walk_cursor_start_edit()
            or (require('copilot-lsp.nes').apply_pending_nes() and require('copilot-lsp.nes').walk_cursor_end_edit())
          return nil
        else
          -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
          return '<C-i>'
        end
      end, { desc = 'Accept Copilot NES suggestion', expr = true })
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        transparent_background = true,
        float = {
          transparent = true, -- enable transparent floating windows
          solid = false, -- use solid styling for floating windows, see |winborder|
        },
      }
      -- vim.cmd.colorscheme 'catppuccin-latte'
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require('gruvbox').setup {
        transparent_mode = false,
      }
      vim.o.background = 'light'
      -- vim.cmd 'colorscheme gruvbox'
    end,
  },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup {
        options = {
          styles = {
            comments = 'italic',
          },
        },
      }
      vim.cmd 'colorscheme github_light'
    end,
  },
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.surround').setup {
        mappings = {
          add = 'gsa',
          delete = 'gsd',
          find = 'gsf',
          find_left = 'gsF',
          highlight = 'gsh', -- Highlight surrounding
          replace = 'gsr', -- Replace surrounding
          update_n_lines = 'gsn', -- Update `n_lines`
        },
        n_lines = 1000,
      }
      require('mini.bufremove').setup()
      vim.keymap.set('n', '<leader>x', MiniBufremove.delete, { desc = '[X] Delete current buffer' })
      vim.keymap.set('n', '<leader>X', MiniBufremove.wipeout, { desc = '[X] Wipeout current buffer' })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      sections = {
        lualine_c = {
          {
            'filename',
            path = 1,
          },
        },
      },
    },
  },
  {
    'stevearc/oil.nvim',
    opts = {
      keymaps = {
        ['q'] = { 'actions.close', mode = 'n' },
        ['gc'] = { 'actions.copy_to_system_clipboard', mode = 'n' },
        ['c-o'] = { 'actions.open_external', mode = 'n' },
      },
      float = {
        padding = 4,
        max_width = 80,
        border = 'single',
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '-', '<CMD>Oil --float<CR>', desc = 'Open parent directory' },
    },
  },
  {
    'ahmedkhalf/project.nvim',
    event = 'VeryLazy',
    config = function()
      require('project_nvim').setup {
        detection_methods = { 'pattern', 'lsp' },
        patterns = { '.git' },
      }
      require('telescope').load_extension 'projects'
    end,
    keys = {
      { '<leader>fp', '<cmd>Telescope projects<cr>', desc = '[F]ind [P]rojects' },
    },
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    config = function()
      -- Setup treesitter with all options
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash',
          'c',
          'c_sharp',
          'diff',
          'html',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'query',
          'vim',
          'vimdoc',
          'javascript',
          'typescript',
          'tsx',
        },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<enter>',
            node_incremental = '<enter>',
            scope_incremental = false,
            node_decremental = '<bs>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
              ['ai'] = '@conditional.outer',
              ['ii'] = '@conditional.inner',
              ['a/'] = '@comment.outer',
              ['i/'] = '@comment.inner',
            },
            -- You can choose the select mode (default is charwise 'v')
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = 'V', -- linewise
            },
          },
          lsp_interop = {
            enable = true,
            border = 'single',
            peek_definition_code = {
              ['grp'] = '@function.outer',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']f'] = '@function.outer',
              [']a'] = '@parameter.outer',
              [']l'] = '@loop.outer',
              [']i'] = '@conditional.outer',
              [']/'] = '@comment.outer',
            },
            goto_next_end = {
              [']F'] = '@function.outer',
              [']A'] = '@parameter.outer',
              [']L'] = '@loop.outer',
              [']I'] = '@conditional.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[a'] = '@parameter.outer',
              ['[l'] = '@loop.outer',
              ['[i'] = '@conditional.outer',
              ['[/'] = '@comment.outer',
            },
            goto_previous_end = {
              ['[F'] = '@function.outer',
              ['[A'] = '@parameter.outer',
              ['[L'] = '@loop.outer',
              ['[I'] = '@conditional.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>sa'] = '@parameter.inner', -- swap parameters/argument with next
              ['<leader>sf'] = '@function.outer', -- swap function with next
            },
            swap_previous = {
              ['<leader>sA'] = '@parameter.inner', -- swap parameters/argument with prev
              ['<leader>sF'] = '@function.outer', -- swap function with previous
            },
          },
        },
      }

      -- Setup repeatable move after treesitter config
      local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

      -- vim way: ; goes to the direction you were moving.
      -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring() or get_option(filetype, option)
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = 'BufEnter',
    config = function()
      require('treesitter-context').setup {
        -- line_numbers = false,
        max_lines = 5,
        multiline_threshold = 2,
      }
      vim.keymap.set('n', '[n', function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end, { silent = true, desc = 'Go to co[n]text' })
    end,
  },
  -- {
  --   'olimorris/codecompanion.nvim',
  --   opts = {
  --     display = {
  --       chat = {
  --         show_settings = true,
  --       },
  --     },
  --     adapters = {
  --       gemini = function()
  --         return require('codecompanion.adapters').extend('gemini', {
  --           schema = {
  --             model = {
  --               default = 'gemini-2.0-flash-thinking-exp-01-21',
  --             },
  --           },
  --         })
  --       end,
  --     },
  --     strategies = {
  --       chat = { adapter = 'gemini' },
  --       inline = { adapter = 'gemini' },
  --     },
  --   },
  --   cmd = {
  --     'CodeCompanion',
  --     'CodeCompanionChat',
  --     'CodeCompanionCmd',
  --     'CodeCompanionActions',
  --   },
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-treesitter/nvim-treesitter',
  --   },
  -- },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  -- {
  --   'iamcco/markdown-preview.nvim',
  --   cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  --   build = 'cd app; yarn install',
  --   init = function()
  --     vim.g.mkdp_filetypes = { 'markdown', 'codecompanion' }
  --   end,
  --   ft = { 'markdown', 'codecompanion' },
  -- },
  -- {
  --   'OXY2DEV/markview.nvim',
  --   lazy = false,
  --   dependencies = {
  --     'saghen/blink.cmp',
  --   },
  --   ft = { 'markdown', 'codecompanion', 'Avante' },
  -- },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
    event = 'VeryLazy',
  },
  -- {
  --   'folke/zen-mode.nvim',
  --   opts = {},
  --   keys = {
  --     { '<leader>z', '<cmd>ZenMode<cr>', desc = '[Z]en Mode' },
  --   },
  --   cmd = {
  --     'ZenMode',
  --   },
  -- },
  -- {
  --   'AckslD/swenv.nvim',
  --   dependencies = { 'ahmedkhalf/project.nvim' },
  -- },
  {
    'rmagatti/auto-session',
    event = 'VeryLazy',
    opts = {
      -- auto_restore_last_session = true,
    },
    keys = {
      { '<leader>wr', '<cmd>AutoSession search<CR>', desc = 'Session search' },
      { '<leader>ws', '<cmd>AutoSession save<CR>', desc = 'Save session' },
      { '<leader>wa', '<cmd>AutoSession toggle<CR>', desc = 'Toggle autosave' },
    },
  },
  -- {
  --   'kristijanhusak/vim-dadbod-ui',
  --   dependencies = {
  --     { 'tpope/vim-dadbod' },
  --     -- { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
  --   },
  --   cmd = {
  --     'DBUI',
  --     'DBUIToggle',
  --     'DBUIAddConnection',
  --     'DBUIFindBuffer',
  --   },
  --   init = function()
  --     -- Your DBUI configuration
  --     vim.g.db_ui_use_nerd_fonts = 1
  --   end,
  -- },
  -- {
  --   'LintaoAmons/bookmarks.nvim',
  --   -- tag = "v2.3.0",
  --   dependencies = {
  --     { 'kkharji/sqlite.lua' },
  --     { 'nvim-telescope/telescope.nvim' },
  --   },
  --   config = function()
  --     vim.keymap.set({ 'n' }, '<leader>fB', '<cmd>BookmarksLists<cr>', { desc = '[F]ind [B]ookmarks' })
  --     vim.keymap.set({ 'n' }, '<leader>b', '<cmd>BookmarksTree<cr>', { desc = 'Bookmarks Tree' })
  --     vim.keymap.set({ 'n' }, '<leader>B', '<cmd>BookmarksMark<cr>', { desc = 'New Bookmarks' })
  --     vim.keymap.set({ 'n' }, ']b', '<cmd>BookmarksGotoNextInList<cr>', { desc = 'Next Bookmarks' })
  --     vim.keymap.set({ 'n' }, '[b', '<cmd>BookmarksGotoPrevInList<cr>', { desc = 'Previous Bookmarks' })
  --     local opts = {
  --       signs = {
  --         mark = {
  --           line_bg = 'NONE',
  --         },
  --       },
  --     } -- check the "./lua/bookmarks/default-config.lua" file for all the options
  --     require('bookmarks').setup(opts) -- you must call setup to init sqlite db
  --   end,
  --   init = function()
  --     -- I have to point this thing to the SQLite3 DLL manually on Windows.
  --     -- Downloads here: https://www.sqlite.org/download.html
  --     -- Choose the "Precompiled Binaries for Windows" option.
  --     if vim.loop.os_uname().sysname == 'Windows_NT' then
  --       vim.g.sqlite_clib_path = [[C:\Program Files\DB Browser for SQLite\sqlite3.dll]]
  --     end
  --   end,
  --   event = 'VeryLazy',
  -- },
  {
    'stevearc/aerial.nvim',
    opts = {
      backends = { 'lsp', 'treesitter', 'markdown', 'asciidoc', 'man' },
      layout = {
        max_width = { 0.5 },
        min_width = 0.5,
      },
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = {
      'AerialToggle',
    },
    keys = {
      {
        '<leader>A',
        function()
          require('aerial').toggle { direction = 'float' }
        end,
        mode = '',
        desc = '[A]erial toggle float',
      },
    },
  },
  {
    'stevearc/overseer.nvim',
    opts = {},
    keys = {
      { '<leader>oo', '<cmd>OverseerToggle<cr>', desc = '[O]verseer [T]oggle' },
      { '<leader>or', '<cmd>OverseerRun<cr>', desc = '[O]verseer [R]un' },
      { '<leader>oa', '<cmd>OverseerTaskAction<cr>', desc = '[O]verseer [A]ction' },
      { '<leader>ob', '<cmd>OverseerBuild<cr>', desc = '[O]verseer [B]uild' },
      { '<leader>os', '<cmd>OverseerShell<cr>', desc = '[O]verseer [S]hell' },
    },
  },
  {
    'LunarVim/bigfile.nvim',
    event = 'VeryLazy',
    opts = {
      filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
      pattern = { '*' }, -- autocmd pattern or function see <### Overriding the detection of big files>
      features = { -- features to disable
        'indent_blankline',
        'lsp',
        'treesitter',
        'syntax',
        'matchparen',
        -- 'vimopts',
        -- 'filetype',
      },
    },
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh' },
    keys = {
      { '<leader>do', '<cmd>DiffviewOpen<cr>', desc = 'Diffview Open' },
      { '<leader>dc', '<cmd>DiffviewClose<cr>', desc = 'Diffview Close' },
      { '<leader>dh', '<cmd>DiffviewFileHistory<cr>', desc = 'Diffview File History' },
      { '<leader>dt', '<cmd>DiffviewToggleFiles<cr>', desc = 'Diffview Toggle Files' },
      { '<leader>df', '<cmd>DiffviewFocusFiles<cr>', desc = 'Diffview Focus Files' },
      { '<leader>dr', '<cmd>DiffviewRefresh<cr>', desc = 'Diffview Refresh' },
    },
    config = function()
      local actions = require 'diffview.actions'
      require('diffview').setup {
        -- Turn on wrapping for diff buffers when they are read
        hooks = {
          diff_buf_read = function(bufnr)
            -- Set wrap for the diff buffer only
            vim.api.nvim_set_option_value('wrap', true, { buf = bufnr })
          end,
        },

        -- Map page scroll in preview/view/file panels to <C-j>/<C-k>
        keymaps = {
          view = {
            ['<C-j>'] = actions.scroll_view(0.25),
            ['<C-k>'] = actions.scroll_view(-0.25),
          },
          file_panel = {
            ['<C-j>'] = actions.scroll_view(0.25),
            ['<C-k>'] = actions.scroll_view(-0.25),
          },
          file_history_panel = {
            ['<C-j>'] = actions.scroll_view(0.25),
            ['<C-k>'] = actions.scroll_view(-0.25),
          },
        },
      }
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
  -- {
  --   'HakonHarnes/img-clip.nvim',
  --   event = 'VeryLazy',
  --   opts = {},
  --   keys = {
  --     {
  --       '<C-S-v>',
  --       function()
  --         require('img-clip').paste_image()
  --       end,
  --       mode = { 'n', 'i', 'v' },
  --       desc = 'Paste image from clipboard',
  --     },
  --     {
  --       '<C-S-v>',
  --       function()
  --         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, false, true), 'n', false)
  --         require('img-clip').paste_image()
  --         vim.api.nvim_feedkeys('i', 'n', false)
  --       end,
  --       mode = 't',
  --       desc = 'Paste image from clipboard (terminal mode)',
  --     },
  --   },
  -- },
  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.neotest',
  require 'kickstart.plugins.toggleterm',
  -- require 'kickstart.plugins.ctags',
  -- require 'kickstart.plugins.avante',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
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
        'man',
      },
    },
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
