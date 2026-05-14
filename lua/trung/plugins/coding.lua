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
          'mermaid',
          'cds',
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
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufEnter',
    config = function()
      require('treesitter-context').setup {
        max_lines = 5,
        multiline_threshold = 2,
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
  require 'trung.plugins.autopairs',
  require 'trung.plugins.indent_line',
}
