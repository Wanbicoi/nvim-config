local tab_title = require 'utils.tab_title'

return {
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      -- auto_restore_last_session = true,
      auto_create = false,
      post_restore_cmds = { tab_title.set },
      post_save_cmds = { tab_title.set },
      legacy_cmds = false,
      cwd_change_handling = true,
      session_lens = {
        picker = 'snacks',
      },
      close_filetypes_on_save = {
        'checkhealth',
        'snacks_terminal',
        'snacks_layout_box',
        'snacks_picker_list',
        'snacks_picker_input',
        'OverseerList',
        'OverseerOutput',
        'aerial',
        'neotest-output-panel',
        'neotest-summary',
        'qf',
        'help',
      },
      bypass_save_filetypes = {
        'BookmarksTree',
        'kulala_ui',
        'snacks_picker_list',
        'snacks_terminal',
        'snacks_layout_box',
        'OverseerList',
        'OverseerOutput',
      },
    },
    keys = {
      { '<leader>fs', '<cmd>AutoSession search<CR>', desc = 'Session search' },
    },
  },
}
