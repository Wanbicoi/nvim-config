return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = "hrsh7th/cmp-cmdline",
    init = function()
      local cmp = require 'cmp'
      cmp.setup.cmdline({ '/', '?' }, {
        completion = { completeopt = "menu,menuone,noselect,preview" },
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        completion = { completeopt = "menu,menuone,noselect,preview" },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          {
            { name = 'path' }
          },
          {
            { name = 'cmdline' }
          }
        )
      })
    end
  },
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
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git" },
      }
    end,
    init = function()
      require('telescope').load_extension('projects')
    end,
    lazy = false
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
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
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "BufEnter",
    opts = {
      line_numbers = false,
      max_lines = 5,
      separator = '─',
    }
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
      -- close_automatic_events = { "unfocus", "switch_buffer" },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    cmd = "AerialToggle"
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
      n_lines = 1000,
    }
  },
  {
    "olimorris/codecompanion.nvim",
    opts = {
      display = {
        chat = {
          show_settings = true
        }
      },
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "gemini-2.0-flash-thinking-exp-01-21",
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
    opts = {
      -- auto_restore_last_session = true,
    },
    keys = {
      { "<leader>fs", "<cmd>SessionSearch<cr>", desc = "Oil current file" }
    },
    cmd = {
      "SessionSearch"
    }
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod' },
      -- { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = { enabled = true },
        char = { enabled = false }
      }
    },
    keys = {
      { "<leader>st",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,     desc = "Toggle Flash Search" },
    },
  }
}
