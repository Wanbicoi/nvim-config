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
    if vim.wo.diff then
      vim.cmd.amenu [[100.210 PopUp.-DiffSep- :]]
      vim.cmd.nmenu [[100.220 PopUp.Diff\ Get <cmd>diffget<CR>]]
      vim.cmd.nmenu [[100.230 PopUp.Diff\ Put <cmd>diffput<CR>]]

      vim.cmd.vmenu [[100.220 PopUp.Diff\ Get <cmd>'<,'>diffget<CR>]]
      vim.cmd.vmenu [[100.230 PopUp.Diff\ Put <cmd>'<,'>diffput<CR>]]
    else
      vim.cmd [[silent! aunmenu PopUp.-DiffSep-]]
      vim.cmd [[silent! aunmenu PopUp.Diff\ Get]]
      vim.cmd [[silent! aunmenu PopUp.Diff\ Put]]
    end

    vim.cmd.nmenu [[100.200 PopUp.-File- :]]
    vim.cmd.nmenu [[100.205 PopUp.Open\ File\ Under\ Cursor <cmd>lua _G.OpenFileUnderCursor()<CR>]]
    vim.cmd.nmenu [[100.210 PopUp.Copy\ All <cmd>%y+<CR>]]
    vim.cmd.nmenu [[100.212 PopUp.Copy\ File\ Name <cmd>let @+=expand('%:t')<CR>]]
    vim.cmd.nmenu [[100.213 PopUp.Copy\ File\ Position <cmd>let @+=expand('%') . ':' . line('.')<CR>]]
    vim.cmd.nmenu [[100.215 PopUp.New\ Empty\ File <cmd>vnew<CR>]]
    vim.cmd.nmenu [[100.219 PopUp.-SearchSep- :]]
    vim.cmd.nmenu [[100.220 PopUp.Grep\ Word\ (Project\ Root) <cmd>lua require('trung.utils.snacks_search').grep_cword_project()<CR>]]
    vim.cmd.nmenu [[100.230 PopUp.Grep\ Word\ (CWD) <cmd>lua require('trung.utils.snacks_search').grep_cword_pwd()<CR>]]
    vim.cmd.vmenu [[100.240 PopUp.Grep\ Selection\ (Project\ Root) :<C-U>lua require('trung.utils.snacks_search').grep_visual_project()<CR>]]
    vim.cmd.vmenu [[100.250 PopUp.Grep\ Selection\ (CWD) :<C-U>lua require('trung.utils.snacks_search').grep_visual_pwd()<CR>]]
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

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})
