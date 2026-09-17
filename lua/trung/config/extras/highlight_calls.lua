vim.treesitter.query.set(
  'typescript',
  'highlights',
  [[
; extends
(call_expression) @function.call
]]
)
local typescript_call_highlight_enabled = false

local function set_typescript_call_highlight(enabled)
  typescript_call_highlight_enabled = enabled

  if enabled then
    vim.api.nvim_set_hl(0, '@function.call', { link = 'Visual' })
  else
    vim.api.nvim_set_hl(0, '@function.call', {}) -- clear highlight
  end
  vim.notify(('TypeScript call highlight %s'):format(enabled and 'enabled' or 'disabled'), vim.log.levels.INFO, { title = 'Treesitter' })
end

vim.api.nvim_create_user_command('CallExpressionHighlight', function()
  set_typescript_call_highlight(not typescript_call_highlight_enabled)
end, { desc = 'Toggle custom TypeScript call highlight' })
