-- set underline for CursorHoldI reference
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    -- Link all reference types to a clean underline style
    vim.api.nvim_set_hl(0, 'LspReferenceText', { underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceTarget', { underline = true })
  end,
})

-- Autosave on focus lost
vim.api.nvim_create_autocmd('TextChanged', {
  desc = 'Autosave when focus is lost or buffer is left',
  group = vim.api.nvim_create_augroup('trung-autosave', { clear = true }),
  callback = function()
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype
    local bufname = vim.api.nvim_buf_get_name(0)
    local ignore_filetypes = { 'oil', 'help', 'diffview', 'gitcommit', 'gitrebase', 'TelescopePrompt', 'snacks_picker_input' }

    if vim.bo.modified and bufname ~= '' and buftype == '' and not vim.tbl_contains(ignore_filetypes, filetype) then
      vim.cmd 'silent! wall'
    end
  end,
})

-- Auto-reload files when they change on disk
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  desc = 'Reload file when focus is gained or buffer is entered',
  group = vim.api.nvim_create_augroup('trung-autoreload', { clear = true }),
  callback = function()
    local buftype = vim.bo.buftype
    if vim.api.nvim_buf_get_name(0) ~= '' and buftype == '' then
      vim.cmd 'checktime'
    end
  end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('trung-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Add only custom popup actions
-- Always use 100 for PopUp menu
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Setup custom popup menu',
  group = vim.api.nvim_create_augroup('trung-popup-search-menu', { clear = true }),
  callback = function()
    vim.cmd.nmenu [[100.280 PopUp.-DiffSep- :]]
    if vim.wo.diff then
      vim.cmd.nmenu [[100.281 PopUp.󰦫\ Diff\ Off <cmd>diffoff<CR>]]
      vim.cmd [[silent! aunmenu PopUp.\ Diff\ This]]

      vim.cmd.nmenu [[100.284 PopUp.󰏑\ Diff\ Get <cmd>diffget<CR>]]
      vim.cmd.nmenu [[100.285 PopUp.󰏒\ Diff\ Put <cmd>diffput<CR>]]
      vim.opt.mouse = 'a'
      vim.cmd.vmenu [[100.284 PopUp.󰏑\ Diff\ Get <cmd>'<,'>diffget<CR>]]
      vim.cmd.vmenu [[100.285 PopUp.󰏒\ Diff\ Put <cmd>'<,'>diffput<CR>]]
    else
      vim.cmd.nmenu [[100.281 PopUp.\ Diff\ This <cmd>diffthis<CR>]]
      vim.cmd [[silent! aunmenu PopUp.󰦫\ Diff\ Off]]

      vim.cmd [[silent! aunmenu PopUp.󰏑\ Diff\ Get]]
      vim.cmd [[silent! aunmenu PopUp.󰏒\ Diff\ Put]]
    end

    vim.cmd.nmenu [[100.200 PopUp.-File- :]]
    vim.cmd.nmenu [[100.201 PopUp.󰒊\ Send\ This\ To\ Agent <cmd>lua require('trung.plugins.extras.zellij_agent').send_line()<CR>]]
    vim.cmd.vmenu [[100.202 PopUp.󰒊\ Send\ This\ To\ Agent <cmd>lua require('trung.plugins.extras.zellij_agent').send_selection()<CR>]]
    vim.cmd.nmenu [[100.205 PopUp.󰈞\ Open\ File\ Under\ Cursor <cmd>lua _G.OpenFileUnderCursor()<CR>]]
    vim.cmd.nmenu [[100.206 PopUp.󰆏\ Copy\ All <cmd>%y+<CR>]]
    vim.cmd.nmenu [[100.211 PopUp.󰘲\ Copy\ Word\ Under\ Cursor yiw]]
    vim.cmd.nmenu [[100.212 PopUp.󰛄\ Replace\ Word\ Under\ Cursor viwP]]
    vim.cmd.nmenu [[100.213 PopUp.󰈔\ Copy\ File\ Name <cmd>let @+=expand('%:t')<CR>]]
    vim.cmd.nmenu [[100.214 PopUp.󰈙\ Copy\ Code\ Position <cmd>let @+=expand('%') . ':' . line('.')<CR>]]
    vim.cmd.nmenu [[100.215 PopUp.󰝰\ New\ Empty\ File <cmd>vnew<CR>]]
    vim.cmd.nmenu [[100.218 PopUp.-AgentSep- :]]

    vim.cmd.nmenu [[100.107 PopUp.󰈗\ Grep\ Word\ (Project\ Root) <cmd>lua require('trung.utils.snacks_search').grep_cword_project()<CR>]]
    vim.cmd.nmenu [[100.108 PopUp.󰈻\ Grep\ Word\ (CWD) <cmd>lua require('trung.utils.snacks_search').grep_cword_pwd()<CR>]]
    vim.cmd.vmenu [[100.107 PopUp.󰈗\ Grep\ Selection\ (Project\ Root) :<C-U>lua require('trung.utils.snacks_search').grep_visual_project()<CR>]]
    vim.cmd.vmenu [[100.108 PopUp.󰈻\ Grep\ Selection\ (CWD) :<C-U>lua require('trung.utils.snacks_search').grep_visual_pwd()<CR>]]
    vim.cmd.amenu [[100.109 PopUp.-SearchSep- :]]
  end,
})

-- Auto load script
-- vim.api.nvim_create_autocmd('DirChanged', {
--   callback = function()
--     local file = vim.fn.getcwd() .. '/.nvim.lua'
--     if vim.fn.filereadable(file) == 1 and vim.secure.trust { action = 'allow', path = file } then
--       dofile(file)
--       print('Loaded local config: ' .. file)
--     end
--   end,
-- })

-- lsp rename file
vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPost',
  callback = function(event)
    if event.data.actions[1].type == 'move' then
      Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})

vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('TerminalInsertFocus', { clear = true }),
  pattern = 'term://*', -- Target only terminal buffers
  callback = function()
    vim.cmd 'startinsert'
  end,
})

vim.keymap.set('n', '<LeftMouse>', function()
  local mouse_keys = vim.api.nvim_replace_termcodes('<LeftMouse>', true, false, true)
  vim.api.nvim_feedkeys(mouse_keys, 'n', false)
  vim.schedule(function()
    if vim.bo.buftype == 'terminal' then
      local name = vim.api.nvim_buf_get_name(0):lower()
      if name:match 'claude' or name:match 'pi' or name:match 'agy' then
        vim.cmd 'startinsert'
      end
    end
  end)
end, { silent = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'json',
  callback = function()
    vim.api.nvim_buf_create_user_command(0, 'JsonSort', '%!jq -S .', {})
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'http',
  callback = function()
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = [[getline(v:lnum) =~ '^### ' ? '>1' : '1']]
  end,
})

-- Clean up tool windows (edgy, overseer, terminals, pickers) before restart
-- vim.api.nvim_create_user_command('Restart', function(opts)
--   pcall(function()
--     require('edgy').close()
--   end)
--   pcall(function()
--     require('overseer').close()
--   end)
--   pcall(function()
--     for _, term in ipairs(Snacks.terminal.list()) do
--       if term:win_valid() then
--         term:hide()
--       end
--     end
--   end)
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     local buf = vim.api.nvim_win_get_buf(win)
--     local ft = vim.bo[buf].filetype
--     local bt = vim.bo[buf].buftype
--     if
--       bt == 'terminal'
--       or bt == 'nofile'
--       or vim.tbl_contains({
--         'snacks_terminal',
--         'snacks_layout_box',
--         'snacks_picker_list',
--         'snacks_picker_input',
--         'OverseerList',
--         'OverseerOutput',
--         'aerial',
--       }, ft)
--     then
--       pcall(vim.api.nvim_win_close, win, true)
--     end
--   end
--   vim.cmd('restart ' .. (opts.bang and '!' or '') .. ' ' .. opts.args)
-- end, { bang = true, nargs = '*' })
