return {
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
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- stylua: ignore
      keys[#keys + 1] = { "gi", "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Goto Incoming Calls" }
    end,
  },
  { "sainnhe/gruvbox-material" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
    },
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
      keymaps = {
        ["q"] = "actions.close",
      },
    },
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
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
  { "nvim-focus/focus.nvim", opts = {} },
  { "j-hui/fidget.nvim", tag = "legacy", event = "LspAttach", opts = {} },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
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
    "nvim-treesitter/nvim-treesitter",
    opts = {
      autotag = {
        enable = true,
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
}
