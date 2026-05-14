-- Autosave on focus lost
vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
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

-- Add diffget to right-click menu when in diff mode
vim.api.nvim_create_autocmd({ 'OptionSet' }, {
  desc = 'Add diffget to right-click menu in diff mode',
  group = vim.api.nvim_create_augroup('diff-mode-popup', { clear = true }),
  pattern = 'diff',
  callback = function()
    if vim.wo.diff then
      -- Add diffget menu item when entering diff mode
      vim.cmd.amenu '20.10 PopUp.-DiffSep- :'
      vim.cmd.amenu '20.20 PopUp.Diff\\ Get <cmd>diffget<CR>'
      vim.cmd.amenu '20.30 PopUp.Diff\\ Put <cmd>diffput<CR>'
    else
      -- Remove diff menu items when leaving diff mode
      pcall(vim.cmd.aunmenu, 'PopUp.-DiffSep-')
      pcall(vim.cmd.aunmenu, 'PopUp.Diff\\ Get')
      pcall(vim.cmd.aunmenu, 'PopUp.Diff\\ Put')
    end
  end,
})

-- Also add the menu items when first opening a diff buffer
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  desc = 'Setup diff menu on buffer enter if in diff mode',
  group = vim.api.nvim_create_augroup('diff-mode-bufenter', { clear = true }),
  callback = function()
    if vim.wo.diff then
      pcall(vim.cmd.aunmenu, 'PopUp.-DiffSep-')
      pcall(vim.cmd.aunmenu, 'PopUp.Diff\\ Get')
      pcall(vim.cmd.aunmenu, 'PopUp.Diff\\ Put')
      vim.cmd.amenu '20.10 PopUp.-DiffSep- :'
      vim.cmd.amenu '20.20 PopUp.Diff\\ Get <cmd>diffget<CR>'
      vim.cmd.amenu '20.30 PopUp.Diff\\ Put <cmd>diffput<CR>'
    end
  end,
})

