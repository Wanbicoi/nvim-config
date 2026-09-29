return {
  {
    'glacambre/firenvim',
    build = ':call firenvim#install(0)',
    config = function()
      vim.g.firenvim_config = {
        globalSettings = {
          ['<C-w>'] = 'noop',
          ['<C-n>'] = 'default',
        },
        localSettings = {
          ['.*'] = {
            cmdline = 'neovim',
            content = 'text',
            priority = 0,
            selector = 'textarea',
            takeover = 'never',
          },
          ['.*designgurus\\.io.*'] = {
            takeover = 'always',
            priority = 1, -- Higher priority so it overrides the catch-all rule
            cmdline = 'neovim',
            content = 'text',
            selector = 'textarea.inputarea.monaco-mouse-cursor-text',
            filename = '/home/troy/Downloads/coding/main.py',
          },
        },
      }

      -- Neovide owns `guifont`; don't override it here.
    end,
  },
}
