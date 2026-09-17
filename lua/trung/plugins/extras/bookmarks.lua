return {
  'LintaoAmons/bookmarks.nvim',
  -- pin the plugin at specific version for stability
  -- backup your bookmark sqlite db when there are breaking changes (major version change)
  tag = 'v4.0.0',
  dependencies = {
    { 'kkharji/sqlite.lua' },
    -- picker backend (choose one):
    { 'folke/snacks.nvim' }, -- default picker backend
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim' }, -- currently required by bookmarks.nvim internals
  },
  cmd = { 'BookmarksTree' },
  keys = {
    {
      'mm',
      mode = { 'n' },
      '<cmd>BookmarksMark<cr>',
    },
  },
  config = function()
    require('bookmarks').setup {
      picker = {
        picker_backend = 'snacks', -- "snacks" (default) or "telescope"
      },
    } -- you must call setup to init sqlite db
  end,
}
