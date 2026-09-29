-- Alternative colorschemes, kept opt-in. Require one of these from
-- lua/plugins/init.lua to switch themes (and disable the default in
-- lua/plugins/colorscheme.lua).
return {
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,
    priority = 1000,
    config = function()
      require('github-theme').setup {
        options = {
          styles = {
            comments = 'italic',
          },
        },
      }
      vim.cmd.colorscheme 'github_light'
    end,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    opts = {
      variant = 'dawn',
    },
  },
}
