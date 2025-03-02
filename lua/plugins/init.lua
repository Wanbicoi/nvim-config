return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Oil current file" }
    },
  },
  -- Lua
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
      }
    end,
    init = function()
      require('telescope').load_extension('projects')
    end,
    lazy = false
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = "all",
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<enter>",
          node_incremental = "<enter>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },
  {
    "ludovicchabant/vim-gutentags",
    event = "BufEnter"
  },
  {
    "Darazaki/indent-o-matic",
    config = true,
    -- init = function()
    --   vim.cmd "autocmd! indent_o_matic"
    -- end,
  },
  {
    "tomasky/bookmarks.nvim",
    opts = {
      -- sign_priority = 8,  --set bookmark sign priority to cover other sign
      save_file = vim.fn.expand "$HOME/.bookmarks.nvim", -- bookmarks save file path
      keywords = {
        ["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
        ["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
        ["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
        ["@n"] = "🗒️", -- mark annotation startswith @n ,signs this icon as `Note`
      },
    },
    keys = {
      { "mm", function() require("bookmarks").bookmark_toggle() end, desc = "Bookmarks toggle" },
      { "mi", function() require("bookmarks").bookmark_ann() end,    desc = "Bookmarks annotation" },
      { "ml", function() require("bookmarks").bookmark_list() end,   desc = "Bookmarks list" },
    },
    init = function()
      require('telescope').load_extension('bookmarks')
    end
  },
  {
    "gsuuon/model.nvim",
    config = function()
      require("model").setup {
        prompts = {},
      }
    end,
  }
}
