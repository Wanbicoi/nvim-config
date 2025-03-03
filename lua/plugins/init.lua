return {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, conf)
      conf.defaults.path_display = { "truncate" }
      return conf
    end,
    init = function()
      require("telescope").load_extension("ui-select")
    end,
    dependencies = { "nvim-telescope/telescope-ui-select.nvim" }
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
    dependencies = "nvim-treesitter/nvim-treesitter-refactor",
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
      refactor = {
        highlight_definitions = {
          enable = true,
          clear_on_cursor_move = true,
        },
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = "gnd",
            list_definitions = "gnD",
            list_definitions_toc = false,
            goto_next_usage = "<a-*>",
            goto_previous_usage = "<a-#>",
          },
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
    },
    init = function()
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = "*.*",
        command = "IndentOMatic"
      })
    end,
  },
  {
    "LintaoAmons/bookmarks.nvim",
    -- tag = "v2.3.0",
    dependencies = {
      { "kkharji/sqlite.lua" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      local opts = {
        signs = {
          mark = {
            line_bg = "NONE"
          }
        }
      }                                -- check the "./lua/bookmarks/default-config.lua" file for all the options
      require("bookmarks").setup(opts) -- you must call setup to init sqlite db
    end,
    init = function()
      -- I have to point this thing to the SQLite3 DLL manually on Windows.
      -- Downloads here: https://www.sqlite.org/download.html
      -- Choose the "Precompiled Binaries for Windows" option.
      if (vim.loop.os_uname().sysname == "Windows_NT") then
        vim.g.sqlite_clib_path = [[C:\Program Files\DB Browser for SQLite\sqlite3.dll]]
      end
    end,
    event = "VeryLazy"
  },
  {
    'stevearc/aerial.nvim',
    opts = {
      backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
      layout = {
        default_direction = "left",
        max_width         = { 35, 0.25 },
        min_width         = 20,
      },
      close_automatic_events = { "unfocus", "switch_buffer" },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    cmd = "AerialToggle"
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufEnter",
    opts = {
      line_numbers = false,
      max_lines = 3,
      separator = ''
    }
  },
  {
    'echasnovski/mini.surround',
    version = '*',
    event = "VeryLazy",
    opts = {
      mappings = {
        add = 'gsa',            -- Add surrounding in Normal and Visual modes
        delete = 'gsd',         -- Delete surrounding
        find = 'gsf',           -- Find surrounding (to the right)
        find_left = 'gsF',      -- Find surrounding (to the left)
        highlight = 'gsh',      -- Highlight surrounding
        replace = 'gsr',        -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`

        suffix_last = 'l',      -- Suffix to search with "prev" method
        suffix_next = 'n',      -- Suffix to search with "next" method
      },
    }
  },
  {
    "olimorris/codecompanion.nvim",
    opts = {
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "gemini-2.0-flash",
              },
            },
          })
        end,
      },
      strategies = {
        chat = { adapter = "gemini" },
        inline = { adapter = "gemini" },
      },
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionActions",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app; yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown", "codecompanion" }
    end,
    ft = { "markdown", "codecompanion" },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {},
    ft = { "markdown", "codecompanion" },
  },
  {
    "AckslD/swenv.nvim",
    dependencies = { "ahmedkhalf/project.nvim" }
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      auto_restore_last_session = true,
    }
  }
}
