-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- TODO move this file to ../lua/plugins.lua
return {
  -- Detect tabstop and shiftwidth automatically
  -- 'tpope/vim-sleuth',
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',

        opts = {
          text = {
            spinner = "dots_snake", -- animation shown when tasks are ongoing
          },
          window = {
            blend = 0, -- &winblend for the window
          },
        }
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      { 'folke/neodev.nvim',       opts = {} },
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      "onsails/lspkind.nvim",
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = 'nvim-lua/plenary.nvim',
    event = "BufEnter",
    config = function()
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.formatting.stylua,    -- shell script formatting
          require("null-ls").builtins.formatting.prettierd, -- markdown formatting
        },
      })
    end
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',        opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = "<author>",
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', ']h', require('gitsigns').next_hunk,
          { buffer = bufnr, desc = 'Next Hunk' })
        vim.keymap.set('n', '[h', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = 'Prev Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
          { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup {
        transparent = true,
      }
      vim.cmd.colorscheme 'onedark'
    end
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        theme = 'onedark',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', "nvim-telescope/telescope-file-browser.nvim",
      {
        "ahmedkhalf/project.nvim",
        config = function()
          require("project_nvim").setup {}
        end
      }
    },
    lazy = false,
    config = function()
      require('telescope').setup {
        extensions = {
          file_browser = {
            theme = "ivy",
            display_stat = { date = false, size = false, mode = false },
            files = false,
          },
        },
        pickers = {
          lsp_references = {
            theme = "ivy",
          },
          find_files = {
            theme = "ivy",
            hidden = true,
          },
          live_grep = {
            theme = "ivy",
          },
          oldfiles = {
            theme = "ivy",
          },
          buffers = {
            ignore_current_buffer = true,
          },
        },
      }

      require('telescope').load_extension "file_browser"
      require('telescope').load_extension "projects"

      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
        { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,
        { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', "<cmd>Telescope file_browser files=<cr>",
        { desc = '[/] Find file browser' })
      vim.keymap.set('n', '<leader>sp', "<cmd>Telescope projects<cr>",
        { desc = '[/] Find recent projects' })
      vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files,
        { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string,
        { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep,
        { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics,
        { desc = '[S]earch [D]iagnostics' })
    end
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      "joosepalviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
    },
    build = ':TSUpdate',
    lazy = false,
    config = function()
      require('nvim-treesitter.configs').setup {
        autotag = {
          enable = true,
          enable_close_on_slash = false,
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },

        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = { query = "@function.outer", desc = "inner function" },
              ["if"] = { query = "@function.inner", desc = " outer function" },
              ["ac"] = { query = "@class.outer", desc = "outer class" },
              ["ic"] = { query = "@class.inner", desc = "inner class" },
              ["io"] = { query = "@block.inner", desc = "inner block" },
              ["ao"] = { query = "@block.outer", desc = "outer block" },
              ["ia"] = { query = "@assignment.inner", desc = "inner assignment" },
              ["aa"] = { query = "@assignment.outer", desc = "outer assignment" },
            },
          },
        },
        ensure_installed = {
          "comment",
          "vim",
          "lua",
          "html",
          "css",
          "javascript",
          "typescript",
          "tsx",
          "c",
          "markdown",
          "markdown_inline",
        },
        indent = {
          enable = true,
        },
      }
    end
  },

  {
    "numToStr/Comment.nvim",
    dependencies = "joosepalviste/nvim-ts-context-commentstring",
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true
      }
    },
    event = "VeryLazy"
  },
  { "norcalli/nvim-colorizer.lua", event = "BufEnter" },

  { "mg979/vim-visual-multi",      event = "BufEnter" },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
    event = "VeryLazy",
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  { "wakatime/vim-wakatime", event = "VeryLazy", },
  {
    "kylechui/nvim-surround",
    version = "*", -- use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  },
  {
    "kdheepak/lazygit.nvim",
    keys = {
      {
        "<leader>gl",
        "<cmd>LazyGit<cr>",
        desc = "LazyGit",
      },
    },
    -- optional for floating window border decoration
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "tamton-aquib/duck.nvim",
    keys = {
      {
        "<leader>dd",
        function()
          require("duck").hatch()
        end,
        desc = "Duck Duck!",
      },
      {
        "<leader>ds",
        function()
          require("duck").hatch("🐏", 10)
        end,
        desc = "Duck Sheep!",
      },
      {
        "<leader>dc",
        function()
          require("duck").cook()
        end,
        desc = "Duck Cook",
      },
    },
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = "nvim-lua/plenary.nvim",
    keys = { { "<leader>S", function() require("spectre").toggle() end, { desc = "Spectre", }, } },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "rhysd/conflict-marker.vim",
    event = "VeryLazy",
  },
  {
    "rmagatti/goto-preview",
    event = "VeryLazy",
    opts = {
      default_mappings = true,
    }
  },

  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',
}
