return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    enabled = false,
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
      label = {
        uppercase = false,
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      -- vim.env.NVIM_MKDP_LOG_FILE = vim.fn.stdpath 'state' .. '/mkdp-nvim.log'
      _G.mkdp_browserfunc = function(url)
        if vim.fn.has 'wsl' == 1 then
          vim.ui.open(url, { cmd = { 'cmd.exe', '/c', 'start', '' } })
        else
          vim.ui.open(url)
        end
      end
      vim.cmd [[
        function! OpenMarkdownPreview(url) abort
          call v:lua.mkdp_browserfunc(a:url)
        endfunction
      ]]
      vim.g.mkdp_browserfunc = 'OpenMarkdownPreview'
    end,
    ft = { 'markdown' },
    keys = {
      { '<F4>', '<cmd>MarkdownPreview<cr>', ft = 'markdown', desc = 'Markdown Preview' },
    },
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    -- Completion for `blink.cmp`
    dependencies = { 'saghen/blink.cmp' },
    opts = {
      markdown = {
        headings = {
          shift_width = 0,
        },
        list_items = {
          shift_width = 0,
        },
      },
    },
  },
}
