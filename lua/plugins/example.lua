return {

  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slant",
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
    "nvim-tree/nvim-tree.lua",
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
    },
    event = "VeryLazy",
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({})
      vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "[T]oggle [f]loat term" })

      -- vim.keymap.set("n", "<leader>th", function ()
      --   local Terminal  = require('toggleterm.terminal').Terminal
      --   local lazygit = Terminal:new({ cmd = "lazygit", count = 5 })
      -- end, { desc = "[T]oggle [h]orizontal term" })
      --stylua: ignore
      vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<cr>", { desc = "[T]oggle [h]orizontal term" })
      vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<cr>", { desc = "[T]oggle [v]ertical term" })
      vim.keymap.set("n", "<leader>ts", "<cmd>TermSelect<cr>", { desc = "[T]erm [s]elect" })
      vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTermToggleAll <cr>", { desc = "[T]oggle term [t]oggle all" })

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<C-\\>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
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
    dependencies = {
      "pmizio/typescript-tools.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "<cmd>TSToolsOrganizeImports<cr>", { buffer = buffer, desc = "Organize Imports" })
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>ci", "<cmd>TSToolsAddMissingImports<cr>", { buffer = buffer, desc = "Add Missing Imports" })
          -- stylua: ignore
          vim.keymap.set("n", "<leader>cR", "<cmd>TSToolsRenameFile<cr>", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- stylua: ignore
      keys[#keys + 1] = { "gi", "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Goto Incoming Calls" }
    end,
    opts = {
      setup = {
        tsserver = function(_, opts)
          require("typescript-tools").setup({ server = opts })
          return true
        end,
      },
    },
  },
  -- add gruvbox
  { "sainnhe/gruvbox-material" },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
    },
  },

  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },
  {
    "stevearc/oil.nvim",
    keys = {
      -- stylua: ignore
      { "-", function() require("oil").toggle_float(vim.fn.expand("%:h:p")) end, desc = "[O]il float current file directory", },
    },
    opts = {
      float = {
        border = "single",
        padding = 4,
        max_width = 75,
      },
    },
    event = "VeryLazy",
  },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  { import = "lazyvim.plugins.extras.lang.json" },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = false,
        },
        char = {
          enabled = false,
        },
      },
    },

    -- stylua: ignore
    keys = {
      { "<Enter>", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash", },
      { "s", false},
      { "S", false},
    },
  },
  {
    "wakatime/vim-wakatime",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp-signature-help" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "nvim_lsp_signature_help" } }))
    end,
  },
}
