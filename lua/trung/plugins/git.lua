return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {},
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
  require 'trung.plugins.gitsigns',
}
