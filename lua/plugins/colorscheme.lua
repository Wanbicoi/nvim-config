return {
  {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    opts = {},
    config = function()
      require('vscode').setup {
        underline_links = false,
        group_overrides = {
          markdownUrl = { underline = false },
          Underlined = { underline = false },
          ['@markup.link.url'] = { underline = false },
          ['@markup.link.label'] = { underline = false },
        },
      }
      vim.cmd 'colorscheme vscode'
    end,
  },
}
