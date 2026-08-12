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
          vim.cmd.nmenu [[100.102 PopUp.-Kulala- :]]
        else
          vim.cmd [[silent! aunmenu PopUp.Run\ Request]]
          vim.cmd [[silent! aunmenu PopUp.Run\ All\ Requests]]
          vim.cmd [[silent! aunmenu PopUp.-Kulala-]]
        end
      end,
    })
  end,
}
