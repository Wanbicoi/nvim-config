return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        -- separator_style = "slant",
        indicator = {
          style = "underline",
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = {
      window = {
        completion = require("cmp").config.window.bordered({ scrollbar = false }),
        documentation = require("cmp").config.window.bordered(),
      },
    },
  },
  -- LSP keymaps
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- stylua: ignore
      keys[#keys + 1] = { "gi", "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Goto Incoming Calls" }
    end,
    opts = {
      inlay_hints = { enabled = false },
    },
  },
  {
    "stevearc/oil.nvim",
    enabled = false,
    keys = {
      -- stylua: ignore
      { "-", function() require("oil").open(vim.fn.expand("%:h:p")) end, desc = "[O]il float current file directory", },
    },
    opts = {
      float = {
        border = "single",
        padding = 4,
        max_width = 75,
      },
      keymaps = {
        ["q"] = "actions.close",
      },
    },
    event = "VeryLazy",
  },
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "-",
        function()
          require("yazi").yazi(nil, vim.fn.expand("%:h:p"))
        end,
        desc = "Open the file manager",
      },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.incremental_selection.keymaps.init_selection = "<enter>"
      opts.incremental_selection.keymaps.node_incremental = "<enter>"
    end,
  },
  { "wakatime/vim-wakatime" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp-signature-help" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "nvim_lsp_signature_help" } }))
    end,
  },
  { "j-hui/fidget.nvim", tag = "legacy", event = "LspAttach", opts = {} },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
    vscode = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "center",
        layout_config = {
          width = 0.7,
        },
      },
    },
  },
}
