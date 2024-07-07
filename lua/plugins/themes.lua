return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  { "EdenEast/nightfox.nvim" },
  { "Mofiqul/vscode.nvim" },
  { "sainnhe/gruvbox-material", opts = { transparent = true } },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      -- styles = {
      --   transparency = true,
      -- },
    },
  },
  {
    "tokyonight.nvim",
    opts = {
      -- style = "moon",
      -- transparent = true,
    },
    lazy = false,
    priority = 1000,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      transparent_background = true,
    },
  },
}
