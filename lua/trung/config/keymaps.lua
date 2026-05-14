vim.keymap.set('t', '<c-q>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<c-s>', '<cmd>:w<cr>', { desc = 'Save all files' })
vim.keymap.set('v', '<leader>r', '"0y:%s/\\V<C-r>0//g<Left><Left>')

vim.keymap.set('n', ']e', function()
  vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, count = 1 }
end)
vim.keymap.set('n', '[e', function()
  vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, count = -1 }
end)

vim.keymap.set('n', '<C-Up>', '<C-w>5+')
vim.keymap.set('n', '<C-Down>', '<C-w>5-')
vim.keymap.set('n', '<C-Left>', '<C-w>20<')
vim.keymap.set('n', '<C-Right>', '<C-w>20>')

vim.keymap.set('n', '<leader>cP', function()
  vim.cmd 'let @+ = expand("%:p")'
  vim.notify('Full path copied to clipboard', vim.log.levels.INFO, { title = 'Path Copied' })
end, { desc = '[C]opy full current file path' })

vim.keymap.set('n', '<leader>cp', function()
  vim.cmd 'let @+ = expand("%")'
  vim.notify('Relative path copied to clipboard', vim.log.levels.INFO, { title = 'Path Copied' })
end, { desc = '[C]opy relative current file path' })

vim.keymap.set('n', 'q', '<cmd>q<CR>', { noremap = true })
vim.keymap.set('n', '<esc>', '<cmd>noh<CR>', { noremap = true })
