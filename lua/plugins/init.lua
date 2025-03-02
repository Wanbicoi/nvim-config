return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, conf)
      conf.defaults.path_display = {"truncate"}
      return conf
    end,
  },
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
    opts = {
      keymaps = {
        ["q"] = { "actions.close", mode = "n" },
      }
    },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
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
    event = "VeryLazy"
  },
  {
    "Darazaki/indent-o-matic",
    config = true,
    cmd = {
      "IndentOMatic"
    }
    -- init = function()
    --   vim.cmd "autocmd! indent_o_matic"
    -- end,
  },
  {
    "gsuuon/model.nvim",
    config = function()
      require("model").setup {
        prompts = {},
      }
    end,
  },
  {
    'crusj/bookmarks.nvim',
    keys = {
      { "\\b", mode = { "n" } },
    },
    branch = 'main',
    dependencies = { 'nvim-web-devicons' },
    config = function()
      require("bookmarks").setup()
      require("telescope").load_extension("bookmarks")
    end,
    opts = {
      keymap = {
        toggle = "\\b"
      }
    }
  }
}
