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
          'python'
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
        return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring() or
            get_option(filetype, option)
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufEnter',
    config = function()
      require('treesitter-context').setup {
        max_lines = 5,
        multiline_threshold = 2,
        separator = '—'
      }
      vim.keymap.set('n', '[n', function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end, { silent = true, desc = 'Go to co[n]text' })
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
    'shellRaining/hlchunk.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('hlchunk').setup {
        chunk = {
          enable = true,
          duration = 100,
          delay = 150,
        },
        indent = {
          enable = true,
        },
        line_num = {
          enable = true,
        },
      }
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "lewis6991/async.nvim",
    },
    init = function()
      local keymap = vim.keymap
      keymap.set({ "n", "x" }, "<leader>cr", function()
        require("refactoring").select_refactor()
      end, { desc = "Select refactor" })
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
}
