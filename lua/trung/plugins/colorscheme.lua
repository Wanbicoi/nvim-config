return {
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
      -- vim.cmd.colorscheme 'gruvbox'
    end,
  },
  -- {
  --   'projekt0n/github-nvim-theme',
  --   name = 'github-theme',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('github-theme').setup {
  --       options = {
  --         styles = {
  --           comments = 'italic',
  --         },
  --       },
  --     }
  --     -- vim.cmd.colorscheme 'github_light'
  --   end,
  -- },
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_enable_italic = true
      vim.g.everforest_background = 'hard'
      vim.g.everforest_transparent_background = true

      vim.cmd.colorscheme 'everforest'
    end,
  },
}
