return {
  'mistweaverco/kulala.nvim',
  ft = { 'http', 'rest' },
  -- Load before session save/restore hooks run
  event = { 'SessionLoadPost', 'VimLeavePre' },
  opts = {
    global_keymaps = true,
    global_keymaps_prefix = '<leader>r',
    kulala_keymaps_prefix = '<leader>r',
    ui = {
      max_response_size = 1048576,
      split_direction = 'below',
      pickers = {
        snacks = {
          layout = function()
            local has_snacks, snacks_picker = pcall(require, 'snacks.picker')
            return not has_snacks and {} or vim.tbl_deep_extend('force', snacks_picker.config.layout 'custom_dropdown', {})
          end,
        },
      },
    },
  },
  config = function(_, opts)
    require('kulala').setup(opts)
    vim.api.nvim_create_autocmd('BufEnter', {
      desc = 'Setup kulala popup menu',
      group = vim.api.nvim_create_augroup('trung-kulala-popup-menu', { clear = true }),
      callback = function()
        local ft = vim.bo.filetype
        if ft == 'http' or ft == 'rest' then
          vim.cmd.nmenu [[100.100 PopUp.Run\ Request <cmd>lua require('kulala').run()<CR>]]
          vim.cmd.nmenu [[100.101 PopUp.Run\ All\ Requests <cmd>lua require('kulala').run_all()<CR>]]
          vim.cmd.nmenu [[100.102 PopUp.Select\ Environment <cmd>lua require('kulala').set_selected_env()<CR>]]
          vim.cmd.nmenu [[100.103 PopUp.-Kulala- :]]
        else
          vim.cmd [[silent! aunmenu PopUp.Run\ Request]]
          vim.cmd [[silent! aunmenu PopUp.Run\ All\ Requests]]
          vim.cmd [[silent! aunmenu PopUp.Select\ Environment]]
          vim.cmd [[silent! aunmenu PopUp.-Kulala-]]
        end
      end,
    })
  end,
}
