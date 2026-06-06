vim.filetype.add {
  extension = {
    cds = 'cds',
    ascx = 'html',
    json = 'jsonc',
  },
}

vim.treesitter.language.register('html', 'ascx')
