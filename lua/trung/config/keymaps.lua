vim.keymap.set('t', '<c-q>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<c-s>', '<cmd>:w<cr>', { desc = 'Save all files' })
vim.keymap.set('v', '<leader>r', '"0y:%s/\\V<C-r>0//g<Left><Left>')

vim.keymap.set('n', ']e', function()
  vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, count = 1 }
end)
vim.keymap.set('n', '[e', function()
  vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, count = -1 }
end)

vim.keymap.set('n', '<leader>cd', function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum = cursor[1] - 1
  local col = cursor[2]
  local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

  local diagnostic = nil
  for _, d in ipairs(diagnostics) do
    local end_col = d.end_col or d.col
    if col >= d.col and col <= end_col then
      diagnostic = d
      break
    end
  end

  diagnostic = diagnostic or diagnostics[1]
  if not diagnostic then
    vim.notify('No diagnostic under cursor', vim.log.levels.INFO, { title = 'Diagnostic Copied' })
    return
  end

  local severity_names = {
    [vim.diagnostic.severity.ERROR] = 'ERROR',
    [vim.diagnostic.severity.WARN] = 'WARN',
    [vim.diagnostic.severity.INFO] = 'INFO',
    [vim.diagnostic.severity.HINT] = 'HINT',
  }
  local severity = severity_names[diagnostic.severity] or 'INFO'
  local text = string.format('[%s] %s', severity, diagnostic.message)
  vim.fn.setreg('+', text)
  vim.notify('Diagnostic copied to clipboard', vim.log.levels.INFO, { title = 'Diagnostic Copied' })
end, { desc = '[C]opy [D]iagnostic under cursor' })

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
