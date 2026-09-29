return {
  {
    'stevearc/aerial.nvim',
    opts = {
      backends = { 'lsp', 'treesitter', 'markdown', 'asciidoc', 'man' },
      filter_kind = {
        'Class',
        'Constructor',
        'Enum',
        'Function',
        'Interface',
        'Module',
        'Method',
        'Struct',
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = { 'AerialToggle', 'AerialOpen' },
    keys = {
      {
        '<leader>A',
        function()
          require('aerial').toggle {}
        end,
        mode = 'n',
        desc = '[A]erial toggle',
      },
    },
  },
}
