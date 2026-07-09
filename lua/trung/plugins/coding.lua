return {
  {
    'nmac427/guess-indent.nvim',
    event = 'VeryLazy',
    config = function()
      require('guess-indent').setup {}
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'BufEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
  {
    'romus204/tree-sitter-manager.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'TSManager' },
    config = function()
      require('tree-sitter-manager').setup {
        ensure_installed = {
          'bash',
          'zsh',
          'c',
          -- 'c_sharp',
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
          'mermaid',
          'cds',
          'json5',
          'python',
        },
        auto_install = true,
        highlight = true,
        languages = {
          cds = {
            install_info = {
              url = 'https://github.com/cap-js-community/tree-sitter-cds.git',
              branch = 'main',
              use_repo_queries = true,
            },
          },
        },
      }
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
    'catgoose/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {},
  },
  {
    'danymat/neogen',
    cmd = { 'Neogen' },
    config = function()
      require('neogen').setup {
        enabled = true,
        languages = {
          cs = {
            template = {
              annotation_convention = 'xmldoc',
            },
          },
        },
      }
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      }
    end,
  },
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'lewis6991/async.nvim',
    },
    init = function()
      local keymap = vim.keymap
      keymap.set({ 'n', 'x' }, '<leader>cr', function()
        require('refactoring').select_refactor()
      end, { desc = 'Select refactor' })
    end,
    lazy = false,
  },
  {
    'echasnovski/mini.nvim',
    event = 'BufEnter',
    config = function()
      require('mini.surround').setup {
        mappings = {
          add = 'gsa',
          delete = 'gsd',
          find = 'gsf',
          find_left = 'gsF',
          highlight = 'gsh',
          replace = 'gsr',
          update_n_lines = 'gsn',
        },
        n_lines = 1000,
      }
      require('mini.bufremove').setup()
      vim.keymap.set('n', '<leader>x', MiniBufremove.delete, { desc = '[X] Delete current buffer' })
      vim.keymap.set('n', '<leader>X', MiniBufremove.wipeout, { desc = '[X] Wipeout current buffer' })
      vim.g.minisessions_disable = true
    end,
  },
  {
    'monaqa/dial.nvim',
    config = function()
      local augend = require 'dial.augend'
      require('dial.config').augends:register_group {
        default = {
          augend.constant.alias.bool,
          augend.constant.alias.Bool,
          augend.integer.alias.decimal_int,
        },
      }
    end,
    keys = {
      {
        '<C-a>',
        function()
          require('dial.map').manipulate('increment', 'normal')
        end,
        mode = 'n',
      },
      {
        '<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'normal')
        end,
        mode = 'n',
      },
      {
        'g<C-a>',
        function()
          require('dial.map').manipulate('increment', 'gnormal')
        end,
        mode = 'n',
      },
      {
        'g<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'gnormal')
        end,
        mode = 'n',
      },
      {
        '<C-a>',
        function()
          require('dial.map').manipulate('increment', 'visual')
        end,
        mode = 'x',
      },
      {
        '<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'visual')
        end,
        mode = 'x',
      },
      {
        'g<C-a>',
        function()
          require('dial.map').manipulate('increment', 'gvisual')
        end,
        mode = 'x',
      },
      {
        'g<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'gvisual')
        end,
        mode = 'x',
      },
    },
  },
  {
    'andrewferrier/debugprint.nvim',
    opts = {},
    dependencies = {
      'nvim-mini/mini.nvim', -- Optional: Needed for line highlighting (full mini.nvim plugin)
      'folke/snacks.nvim', -- Optional: If you want to use the `:Debugprint search` command with snacks.nvim
    },
    init = function()
      vim.cmd.nmenu [[100.300 PopUp.-Debugprint- :]]
      vim.cmd.nmenu [[100.301 PopUp.Debugprint\ Variable\ Below g?v]]
      vim.cmd.nmenu [[100.302 PopUp.Debugprint\ Variable\ Surround g?sv]]
    end,
    lazy = false, -- Required to make line highlighting work before debugprint is first used
    version = '*', -- Remove if you DON'T want to use the stable version
  },
  {
    'stevearc/overseer.nvim',
    config = function()
      --- overseer.SetupOpts
      require('overseer').setup {
        component_aliases = {
          default = {
            { 'open_output', focus = true },
            -- 'on_complete_notify',
          },
        },
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
      { '<F1>', '<cmd>OverseerRun<cr>', desc = '[O]verseer [R]un' },
      { '<leader>oa', '<cmd>OverseerTaskAction<cr>', desc = '[O]verseer [A]ction' },
      { '<leader>os', '<cmd>OverseerShell<cr>', desc = '[O]verseer [S]hell' },
    },
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '=',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = { 'v' },
        desc = 'Format buffer',
      },
      {
        '==',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = { 'n' },
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = true,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format' },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        sql = { 'sleek' },
        bash = { 'beautysh' },
        zsh = { 'beautysh' },
        markdown = { 'prettierd', 'prettier' },
        make = { 'cmakelang' },
        xml = { 'xmlformatter' },
      },
    },
  },
}
