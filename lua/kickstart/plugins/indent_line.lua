return {
  -- { -- Add indentation guides even on blank lines
  --   'lukas-reineke/indent-blankline.nvim',
  --   -- Enable `lukas-reineke/indent-blankline.nvim`
  --   -- See `:help ibl`
  --   main = 'ibl',
  --   opts = {
  --     viewport_buffer = {
  --       min = 500
  --     },
  --     indent = {
  --       char = '│'
  --     },
  --     scope = { enabled = false },
  --   },
  -- },
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
}
