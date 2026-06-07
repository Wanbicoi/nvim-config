local marks_to_qf_enabled = false
vim.api.nvim_create_user_command('MarksToQuickFix', function()
  marks_to_qf_enabled = not marks_to_qf_enabled
end, { desc = 'Marks To QuickFix' })

vim.api.nvim_create_autocmd('MarkSet', {
  pattern = '[A-Z]',
  callback = function()
    if marks_to_qf_enabled then
      return
    end

    local qf = {}
    local marks = vim.fn.getmarklist()

    for _, m in ipairs(marks) do
      if m.mark:match '[A-Z]' then
        local filename = m.file

        -- Force absolute path
        if filename and filename ~= '' then
          filename = vim.fn.fnamemodify(filename, ':p')
        end

        table.insert(qf, {
          filename = filename,
          lnum = m.pos[2],
          col = m.pos[3],
          text = 'mark ' .. m.mark,
        })
      end
    end

    vim.fn.setqflist(qf, 'r')
    vim.cmd 'copen'
  end,
})
