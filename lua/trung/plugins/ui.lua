local snacks_search = require 'trung.utils.snacks_search'

return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 500,
      icons = {
        keys = {
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
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]iff' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]est / [T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>o', group = '[O]verseer' },
      },
    },
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      explorer = { enabled = true },
      words = { enabled = true },
      gitbrowse = { enabled = true },
      quickfile = { enabled = true },
      notifier = { enabled = true, top_down = false },
      indent = {
        enabled = true,
        chunk = {
          enabled = true,
        },
      },
      statuscolumn = {
        enabled = true,
        folds = {
          open = true,
        },
      },
      picker = {
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'package.json', 'Makefile', 'AGENTS.md' },
        layout = 'dropdown',
        win = {
          list = {
            keys = {
              ['<c-j>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['<c-k>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
            },
          },
          input = {
            keys = {
              ['<c-j>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['<c-k>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
            },
          },
        },
        ui_select = true,
        sources = {
          projects = {
            dev = { '~/Repos' },
            patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'package.json', 'Makefile', 'be-group' },
          },
        },
      },
    },
    keys = {
      {
        '<leader>e',
        function()
          Snacks.explorer { hidden = true }
        end,
        desc = '[E]xplorer',
        mode = { 'n' },
      },
      {
        '<leader>gB',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Git Browse',
        mode = { 'n', 'v' },
      },
      {
        '<leader><leader>',
        function()
          snacks_search.project('git_files', { untracked = true })
        end,
        desc = '[F]ind [G]it Files',
      },
      {
        '<leader>fa',
        function()
          snacks_search.project('files', { hidden = true, ignored = true })
        end,
        desc = '[F]ind [A]ll',
      },
      {
        '<F2>',
        function()
          snacks_search.pwd('files', { hidden = true, ignored = true })
        end,
        desc = '[F]ind [A]ll (cwd)',
      },
      {
        '<F3>',
        function()
          snacks_search.pwd 'grep'
        end,
        desc = '[G]rep (cwd)',
      },
      {
        '<leader>ff',
        function()
          snacks_search.project('files', {
            hidden = true,
            ignore = true,
            exclude = {
              'node_modules',
              'vendor',
              'target',
              'dist',
              'build',
              'out',
              'obj',
              'bin',
              '.venv',
              'venv',
              '.mypy_cache',
              '.pytest_cache',
              '.next',
              '.nuxt',
              '.svelte-kit',
              '.angular',
              '.expo',
              '.git',
              '.terraform',
              '.terragrunt-cache',
              '.DS_Store',
              'Thumbs.db',
            },
          })
        end,
        desc = '[F]ind [F]iles',
      },
      {
        '<leader>Ff',
        function()
          snacks_search.pwd('files', {
            hidden = true,
            ignore = true,
            exclude = {
              'node_modules',
              'vendor',
              'target',
              'dist',
              'build',
              'out',
              'obj',
              'bin',
              '.venv',
              'venv',
              '.mypy_cache',
              '.pytest_cache',
              '.next',
              '.nuxt',
              '.svelte-kit',
              '.angular',
              '.expo',
              '.git',
              '.terraform',
              '.terragrunt-cache',
              '.DS_Store',
              'Thumbs.db',
            },
          })
        end,
        desc = '[F]ind [F]iles (cwd)',
      },
      {
        '<leader>ft',
        function()
          Snacks.picker.pickers()
        end,
        desc = '[F]ind Picker [T]ypes',
      },
      {
        '<leader>fW',
        function()
          local word = vim.fn.expand '<cword>'
          snacks_search.project('files', { pattern = word })
        end,
        desc = '[F]ind file of the current [W]ord',
      },
      {
        '<leader>FW',
        function()
          local word = vim.fn.expand '<cword>'
          snacks_search.pwd('files', { pattern = word })
        end,
        desc = '[F]ind file of the current [W]ord (cwd)',
      },
      {
        '<leader>fw',
        function()
          snacks_search.project 'grep_word'
        end,
        desc = '[F]ind current [W]ord',
      },
      {
        '<leader>Fw',
        function()
          snacks_search.pwd 'grep_word'
        end,
        desc = '[F]ind current [W]ord (cwd)',
      },
      {
        '<leader>/',
        function()
          snacks_search.project 'grep'
        end,
        desc = '[G]rep',
      },
      {
        '<leader>?',
        function()
          local text = vim.fn.getreg '+'
          text = vim.trim(text:gsub('[\n\r]', ' '))
          snacks_search.project('grep', { search = text })
        end,
        desc = '[G]rep with copied text',
      },
      {
        '<leader>F?',
        function()
          local text = vim.fn.getreg '+'
          text = vim.trim(text:gsub('[\n\r]', ' '))
          snacks_search.pwd('grep', { search = text })
        end,
        desc = '[G]rep with copied text (cwd)',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.resume()
        end,
        desc = '[F]ind [R]esume',
      },
      {
        '<leader>fo',
        function()
          Snacks.picker.recent()
        end,
        desc = '[F]ind Recent Files',
      },
      {
        '_',
        function()
          Snacks.picker.buffers()
        end,
        desc = '[_] Find existing buffers',
      },
      {
        '<leader>gb',
        function()
          snacks_search.project 'git_branches'
        end,
        desc = 'Git Branches',
      },
      {
        '<leader>gl',
        function()
          snacks_search.project 'git_log'
        end,
        desc = 'Git Log',
      },
      {
        '<leader>gL',
        function()
          snacks_search.project 'git_log_line'
        end,
        desc = 'Git Log Line',
      },
      {
        '<leader>gs',
        function()
          snacks_search.project 'git_status'
        end,
        desc = 'Git Status',
      },
      {
        '<leader>gS',
        function()
          snacks_search.project 'git_stash'
        end,
        desc = 'Git Stash',
      },
      {
        '<leader>gd',
        function()
          snacks_search.project 'git_diff'
        end,
        desc = 'Git Diff (Hunks)',
      },
      {
        '<leader>gf',
        function()
          snacks_search.project 'git_log_file'
        end,
        desc = 'Git Log File',
      },
      {
        '<leader>fc',
        function()
          Snacks.picker.commands()
        end,
        desc = '[F]ind [C]ommands',
      },
      {
        '<leader>fn',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[F]ind [N]eovim files',
      },
      {
        '<leader>fh',
        function()
          Snacks.picker.help()
        end,
        desc = '[F]ind [H]elp',
      },
      {
        '<leader>fk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = '[F]ind [K]eymaps',
      },
      {
        '<leader>fd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = '[F]ind [D]iagnostics',
      },
      {
        '<leader>fp',
        function()
          Snacks.picker.projects {
            dev = {
              '~/Repos',
            },
            matcher = {
              cwd_bonus = true,
            },
          }
        end,
        desc = '[F]ind [P]rojects',
      },
      {
        '<leader>fm',
        function()
          Snacks.picker.marks()
        end,
        desc = '[F]ind [M]arks',
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      {
        'linrongbin16/lsp-progress.nvim',
        config = function()
          require('lsp-progress').setup {}
        end,
      },
      {
        'SmiteshP/nvim-navic',
        opts = {
          lsp = {
            auto_attach = true,
          },
        },
      },
    },
    opts = {
      options = {
        globalstatus = true,
        disabled_filetypes = {
          winbar = { 'OverseerList', 'OverseerOutput', 'BookmarksTree', 'qf' },
        },
      },
      sections = {
        lualine_c = {
          function()
            return require('lsp-progress').progress()
          end,
          {
            'navic',
            color_correction = nil,
            -- Can be nil, "static" or "dynamic". This option is useful only when you have highlights enabled.
            -- Many colorschemes don't define same backgroud for nvim-navic as their lualine statusline backgroud.
            -- Setting it to "static" will perform a adjustment once when the component is being setup. This should
            --	 be enough when the lualine section isn't changing colors based on the mode.
            -- Setting it to "dynamic" will keep updating the highlights according to the current modes colors for
            --	 the current section.
            navic_opts = nil, -- lua table with same format as setup's option. All options except "lsp" options take effect when set here.
            on_click = function()
              local navic = require 'nvim-navic'
              if navic.is_available() then
                local data = navic.get_data()
                if data and #data >= 2 then
                  local parent = data[#data - 1]
                  if parent and parent.scope and parent.scope.start then
                    vim.api.nvim_win_set_cursor(0, { parent.scope.start.line, parent.scope.start.character })
                  end
                end
              end
            end,
          },
        },
      },
      winbar = {
        lualine_a = {
          {
            function()
              return ''
            end,
            separator = '',
            on_click = function()
              vim.api.nvim_feedkeys(vim.keycode '<C-o>', 'n', false)
            end,
          },
          {
            function()
              return ''
            end,
            separator = '',
            on_click = function()
              vim.api.nvim_feedkeys(vim.keycode '<C-i>', 'n', false)
            end,
          },
          {
            function()
              return ''
            end,
            separator = '',
            on_click = function()
              require('mini.bufremove').setup()
              MiniBufremove.wipeout()
            end,
          },
          {
            function()
              return '󰏖 '
            end,
            separator = '',
            on_click = function()
              require('oil').open_float()
            end,
          },
        },
        lualine_c = {
          {
            'filename',
            path = 3,
          },
        },
      },
      extensions = {
        'oil',
        'aerial',
        'overseer',
        'quickfix',
        'mason',
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
        ['<LeftMouse>'] = function()
          local mouse = vim.fn.getmousepos()
          vim.api.nvim_win_set_cursor(mouse.winid, { mouse.line, mouse.column - 1 })
          require('oil').select()
        end,
        ['<RightMouse>'] = { 'actions.parent', mode = 'n' },
      },
      float = {
        padding = 4,
        max_width = 80,
        border = 'single',
      },
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '-', '<CMD>Oil --float<CR>', desc = 'Open parent directory' },
    },
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    config = {
      -- auto_restore_last_session = true,
      auto_create = false,
      legacy_cmds = false,
      cwd_change_handling = true,
      session_lens = {
        picker = 'snacks',
      },
      bypass_save_filetypes = {
        'BookmarksTree',
      },
    },
    -- init = function()
    --   vim.api.nvim_create_autocmd('VimEnter', {
    --     desc = 'Auto call auto-session',
    --     group = vim.api.nvim_create_augroup('trung-autosave', { clear = true }),
    --     callback = function()
    --       vim.cmd [[AutoSession search]]
    --     end,
    --   })
    -- end,
    keys = {
      { '<leader>fs', '<cmd>AutoSession search<CR>', desc = 'Session search' },
    },
  },
  {
    'stevearc/aerial.nvim',
    opts = {
      backends = { 'lsp', 'treesitter', 'markdown', 'asciidoc', 'man' },
      layout = {
        max_width = { 0.3 },
        min_width = { 48, 0.2 },
        width = 48,
        default_direction = 'prefer_left',
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = { 'AerialToggle' },
    keys = {
      {
        '<leader>A',
        function()
          require('aerial').toggle {}
        end,
        mode = 'n',
        desc = '[A]erial toggle',
      },
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    enabled = false,
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
      label = {
        uppercase = false,
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
  ---@module "neominimap.config.meta"
  -- {
  --   'Isrothy/neominimap.nvim',
  --   version = 'v3.x.x',
  --   lazy = false, -- NOTE: NO NEED to Lazy load
  --   -- Optional. You can also set your own keybindings
  --   init = function()
  --     -- -- The following options are recommended when layout == "float"
  --     -- vim.opt.wrap = false
  --     -- vim.o.sidescrolloff = 20 -- Set a large value
  --
  --     --- Put your configuration here
  --     ---@type Neominimap.UserConfig
  --     vim.g.neominimap = {
  --       auto_enable = true,
  --       layout = 'split',
  --       float = {
  --         window_border = 'none',
  --       },
  --     }
  --   end,
  -- },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { 'markdown', 'practice-description' },
    },
  },
  {
    'soulis-1256/eagle.nvim',
    opts = {},
    event = 'VeryLazy',
  },
  {
    'lewis6991/satellite.nvim',
    opts = {},
    event = 'VeryLazy',
  },
  {
    'glacambre/firenvim',
    build = ':call firenvim#install(0)',
    config = function()
      vim.g.firenvim_config = {
        globalSettings = {
          ['<C-w>'] = 'noop',
          ['<C-n>'] = 'default',
        },
        localSettings = {
          ['.*'] = {
            cmdline = 'neovim',
            content = 'text',
            priority = 0,
            selector = 'textarea',
            takeover = 'never',
          },
          ['.*designgurus\\.io.*'] = {
            takeover = 'always',
            priority = 1, -- Higher priority so it overrides the catch-all rule
            cmdline = 'neovim',
            content = 'text',
            selector = 'textarea.inputarea.monaco-mouse-cursor-text',
            filename = '/home/troy/Downloads/coding/main.py',
          },
        },
      }

      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = '*designgurus*.txt',
        callback = function()
          vim.cmd 'set filetype=python'
          vim.cmd 'GuessIndent'
        end,
      })
      vim.o.guifont = 'JetBrainsMono Nerd Font Propo:h9.5'
    end,
  },
}
