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
    lazy = false,
  },
  -- Lua
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
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
          -- scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },
  {
    "ludovicchabant/vim-gutentags",
  },
  {
    "Darazaki/indent-o-matic",
    config = true,
    init = function()
      vim.cmd "autocmd! indent_o_matic"
    end,
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
      on_attach = function()
        local bm = require "bookmarks"
        local map = vim.keymap.set
        map("n", "mm", bm.bookmark_toggle) -- add or remove bookmark at current line
        map("n", "mi", bm.bookmark_ann) -- add or edit mark annotation at current line
        -- map("n", "mc", bm.bookmark_clean) -- clean all marks in local buffer
        -- map("n", "mn", bm.bookmark_next) -- jump to next mark in local buffer
        -- map("n", "mp", bm.bookmark_prev) -- jump to previous mark in local buffer
        map("n", "ml", bm.bookmark_list) -- show marked file list in quickfix window
        -- map("n", "mx", bm.bookmark_clear_all) -- removes all bookmarks
      end,
    },
  },
  {
    "gsuuon/model.nvim",
    config = function()
      require("model").setup {
        prompts = {},
      }
    end,
  },
}
