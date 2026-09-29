-- Underline LSP references on every colorscheme change
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Underline LSP reference highlights',
  group = vim.api.nvim_create_augroup('cfg-lsp-reference-hl', { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, 'LspReferenceText', { underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceTarget', { underline = true })
  end,
})

-- Autosave modified buffers on text change
vim.api.nvim_create_autocmd('TextChanged', {
  desc = 'Autosave modified buffers on text change',
  group = vim.api.nvim_create_augroup('cfg-autosave', { clear = true }),
  callback = function()
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype
    local bufname = vim.api.nvim_buf_get_name(0)
    local ignore_filetypes = { 'oil', 'help', 'diffview', 'gitcommit', 'gitrebase', 'snacks_picker_input' }

    if vim.bo.modified and bufname ~= '' and buftype == '' and not vim.tbl_contains(ignore_filetypes, filetype) then
      vim.cmd 'silent! wall'
    end
  end,
})

-- Auto-reload files when they change on disk
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  desc = 'Reload file when focus is gained or buffer is entered',
  group = vim.api.nvim_create_augroup('cfg-autoreload', { clear = true }),
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
  group = vim.api.nvim_create_augroup('cfg-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Add only custom popup actions
-- Always use 100 for PopUp menu
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Setup custom popup menu',
  group = vim.api.nvim_create_augroup('cfg-popup-search-menu', { clear = true }),
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
    vim.cmd.nmenu [[100.201 PopUp.󰒊\ Send\ This\ To\ Agent <cmd>lua require('agent').send_line()<CR>]]
    vim.cmd.vmenu [[100.202 PopUp.󰒊\ Send\ This\ To\ Agent <cmd>lua require('agent').send_selection()<CR>]]
    vim.cmd.nmenu [[100.205 PopUp.󰈞\ Open\ File\ Under\ Cursor <cmd>lua _G.OpenFileUnderCursor()<CR>]]
    vim.cmd.nmenu [[100.206 PopUp.󰆏\ Copy\ All <cmd>%y+<CR>]]
    vim.cmd.nmenu [[100.211 PopUp.󰘲\ Copy\ Word\ Under\ Cursor yiw]]
    vim.cmd.nmenu [[100.212 PopUp.󰛄\ Replace\ Word\ Under\ Cursor viwP]]
    vim.cmd.nmenu [[100.213 PopUp.󰈔\ Copy\ File\ Name <cmd>let @+=expand('%:t')<CR>]]
    vim.cmd.nmenu [[100.214 PopUp.󰈙\ Copy\ Code\ Position <cmd>let @+=expand('%') . ':' . line('.')<CR>]]
    vim.cmd.nmenu [[100.215 PopUp.󰝰\ New\ Empty\ File <cmd>vnew<CR>]]
    vim.cmd.nmenu [[100.218 PopUp.-AgentSep- :]]

    vim.cmd.nmenu [[100.107 PopUp.󰈗\ Grep\ Word\ (Project\ Root) <cmd>lua require('utils.snacks_search').grep_cword_project()<CR>]]
    vim.cmd.nmenu [[100.108 PopUp.󰈻\ Grep\ Word\ (CWD) <cmd>lua require('utils.snacks_search').grep_cword_pwd()<CR>]]
    vim.cmd.vmenu [[100.107 PopUp.󰈗\ Grep\ Selection\ (Project\ Root) :<C-U>lua require('utils.snacks_search').grep_visual_project()<CR>]]
    vim.cmd.vmenu [[100.108 PopUp.󰈻\ Grep\ Selection\ (CWD) :<C-U>lua require('utils.snacks_search').grep_visual_pwd()<CR>]]
    vim.cmd.amenu [[100.109 PopUp.-SearchSep- :]]
  end,
})

-- Keep LSP renamed/moved files in sync
vim.api.nvim_create_autocmd('User', {
  desc = 'Notify LSP on oil rename/move actions',
  group = vim.api.nvim_create_augroup('cfg-oil-rename', { clear = true }),
  pattern = 'OilActionsPost',
  callback = function(event)
    local action = event.data and event.data.actions and event.data.actions[1]
    if action and action.type == 'move' then
      Snacks.rename.on_rename_file(action.src_url, action.dest_url)
    end
  end,
})

-- Wrap prose filetypes
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Wrap help and markdown buffers',
  group = vim.api.nvim_create_augroup('cfg-wrap-text', { clear = true }),
  pattern = { 'help', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})

-- Focus terminal buffers when they open
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
  desc = 'Enter insert mode in terminal buffers',
  group = vim.api.nvim_create_augroup('cfg-terminal-insert', { clear = true }),
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
      if require('integrations.agents').is_agent_text(name) then
        vim.cmd 'startinsert'
      end
    end
  end)
end, { silent = true })

-- Sort JSON with jq
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Add :JsonSort for json buffers',
  group = vim.api.nvim_create_augroup('cfg-json-sort', { clear = true }),
  pattern = 'json',
  callback = function()
    vim.api.nvim_buf_create_user_command(0, 'JsonSort', '%!jq -S .', {})
  end,
})

-- Fold http request files on `### ` separators
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Fold http buffers on request separators',
  group = vim.api.nvim_create_augroup('cfg-http-folds', { clear = true }),
  pattern = 'http',
  callback = function()
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = [[getline(v:lnum) =~ '^### ' ? '>1' : '1']]
  end,
})
