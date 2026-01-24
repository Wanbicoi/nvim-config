-- lua/autocmds.lua

-- Autosave on focus lost
vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  desc = 'Autosave when focus is lost or buffer is left',
  group = vim.api.nvim_create_augroup('kickstart-autosave', { clear = true }),
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
  group = vim.api.nvim_create_augroup('kickstart-autoreload', { clear = true }),
  callback = function()
    local buftype = vim.bo.buftype
    if vim.api.nvim_buf_get_name(0) ~= '' and buftype == '' then
      vim.cmd 'checktime'
    end
  end,
})
