return {
  {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = 'screen'
    end,
    opts = {
      options = {
        left = { size = 35 },
      },
      right = {
        {
          ft = 'snacks_terminal',
          title = '%{b:snacks_terminal.id}: %{b:term_title}',
          size = { width = 0.4 },
          filter = function(_, win)
            return vim.w[win].snacks_win
              and vim.w[win].snacks_win.position == 'right'
              and vim.w[win].snacks_win.relative == 'editor'
              and not vim.w[win].trouble_preview
          end,
        },
      },
      bottom = {
        {
          ft = 'OverseerOutput',
          title = 'Overseer Output',
          size = { height = 7 },
        },
        {
          ft = 'qf',
          title = 'QuickFix',
          size = { height = 10 },
        },
        {
          ft = 'help',
          size = { height = 15 },
          filter = function(buf)
            return vim.bo[buf].buftype == 'help'
          end,
        },
        {
          ft = 'neotest-summary',
          title = 'Neotest Summary',
        },
      },
      left = {
        {
          ft = 'snacks_layout_box',
          title = 'Explorer',
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ''
          end,
        },
        {
          ft = 'aerial',
          -- pinned = true,
          title = 'Symbols (Aerial)',
          open = 'AerialOpen',
        },
        {
          ft = 'OverseerList',
          title = 'Overseer',
          open = function()
            require('overseer').open()
          end,
          size = { height = 10 },
          pinned = false,
        },
      },
      animate = {
        enabled = false,
      },
      wo = {
        winbar = false,
      },
    },
  },
}
