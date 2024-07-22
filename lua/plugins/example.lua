return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
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
      open_for_directories = true,
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
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      win = {
        border = "single", -- none, single, double, shadow
      },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        {
          name = "til",
          path = "~/source/repos/til",
        },
      },
      ui = {
        enable = false,
      },
      mappings = {},
      notes_subdir = "notes",
      disable_frontmatter = true,
    },
    init = function()
      require("lint").linters["markdownlint-cli2"].args = {
        "--config",
        '{ "config": { "MD013": false } }',
      }
    end,
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    name = "render-markdown",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
    config = function()
      require("render-markdown").setup({})
    end,
  },
}
