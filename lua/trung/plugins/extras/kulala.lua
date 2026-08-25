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

    local winbar = require('kulala.ui.winbar')
    local orig_toggle = winbar.toggle_winbar_tab

    winbar.show_previous = function()
      require('kulala.ui').show_previous()
    end

    winbar.show_next = function()
      require('kulala.ui').show_next()
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    winbar.toggle_winbar_tab = function(buf, win_id, view)
      orig_toggle(buf, win_id, view)
      if win_id and vim.api.nvim_win_is_valid(win_id) then
        local ok, winbar_val = pcall(vim.api.nvim_get_option_value, 'winbar', { win = win_id })
        if ok and type(winbar_val) == 'string' and winbar_val ~= '' then
          local config = require('kulala.config').get()
          local keymaps = type(config.kulala_keymaps) == 'table' and config.kulala_keymaps
            or require('kulala.config.keymaps').setup_kulala_keymaps(buf)
          if keymaps['Previous response'] and keymaps['Previous response'][1] and keymaps['Next response'] and keymaps['Next response'][1] then
            local prev_key = keymaps['Previous response'][1]
            local next_key = keymaps['Next response'][1]
            local target_str = '%#KulalaTab# <- ' .. prev_key .. ' %* %#KulalaTab# ' .. next_key .. ' -> %*'
            local start_idx, end_idx = string.find(winbar_val, target_str, 1, true)
            if start_idx then
              local replacement = "%#KulalaTab#%@v:lua.require'kulala.ui.winbar'.show_previous@ <- "
                .. prev_key
                .. " %X%* %#KulalaTab#%@v:lua.require'kulala.ui.winbar'.show_next@ "
                .. next_key
                .. ' -> %X%*'
              local new_winbar_val = string.sub(winbar_val, 1, start_idx - 1)
                .. replacement
                .. string.sub(winbar_val, end_idx + 1)
              pcall(vim.api.nvim_set_option_value, 'winbar', new_winbar_val, { win = win_id })
            end
          end
        end
      end
    end

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
