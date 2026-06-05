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
      words = { enabled = true },
      gitbrowse = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = {
        enabled = true,
        folds = {
          open = true,
        },
      },
      picker = {
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'package.json', 'Makefile', 'AGENTS.md' },
        layout = 'ivy_split',
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
          },
        },
      },
    },
    init = function()
      _G.get_project_root = snacks_search.get_project_root
    end,
    keys = {
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
          snacks_search.project('git_files', { show_untracked = true })
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
        '<F3>',
        function()
          snacks_search.pwd 'grep'
        end,
        desc = '[G]rep (cwd)',
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
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'latte', -- latte, frappe, macchiato, mocha
        auto_integrations = true,
        transparent_background = true,
        float = {
          transparent = true,
          solid = true,
        },
      }
      -- vim.cmd.colorscheme 'catppuccin-nvim'
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require('gruvbox').setup {
        transparent_mode = true,
        inverse = false,
        contrast = 'hard',
      }
      vim.o.background = 'light'
      vim.cmd.colorscheme 'gruvbox'
    end,
  },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,
    priority = 1000,
    config = function()
      require('github-theme').setup {
        options = {
          styles = {
            comments = 'italic',
          },
        },
      }
      -- vim.cmd.colorscheme 'github_light'
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        globalstatus = true,
      },
      sections = {
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
          'mode',
        },
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
    event = 'VeryLazy',
    opts = {},
    keys = {
      { '<leader>wr', '<cmd>AutoSession search<CR>', desc = 'Session search' },
      { '<leader>ws', '<cmd>AutoSession save<CR>', desc = 'Save session' },
      { '<leader>wa', '<cmd>AutoSession toggle<CR>', desc = 'Toggle autosave' },
    },
  },
  {
    'stevearc/aerial.nvim',
    opts = {
      backends = { 'lsp', 'treesitter', 'markdown', 'asciidoc', 'man' },
      layout = {
        max_width = { 0.3 },
        min_width = { 48, 0.2 },
        default_direction = 'prefer_left',
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = { 'AerialToggle' },
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
    config = function()
      require('overseer').setup {
        task_list = {
          keymaps = {
            ['J'] = 'keymap.next_task',
            ['K'] = 'keymap.prev_task',
          },
        },
      }
    end,
    keys = {
      { '<leader>oo', '<cmd>OverseerToggle<cr>', desc = '[O]verseer [T]oggle' },
      { '<leader>or', '<cmd>OverseerRun<cr>', desc = '[O]verseer [R]un' },
      { '<leader>oa', '<cmd>OverseerTaskAction<cr>', desc = '[O]verseer [A]ction' },
      { '<leader>ob', '<cmd>OverseerBuild<cr>', desc = '[O]verseer [B]uild' },
      { '<leader>os', '<cmd>OverseerShell<cr>', desc = '[O]verseer [S]hell' },
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
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
        '<cr>',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        '<S-CR>',
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
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
}
