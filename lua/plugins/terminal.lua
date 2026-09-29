local float = require 'utils.float'
local snacks_search = require 'utils.snacks_search'

local keys = {
  -- lazygit lives in Neovim (not zellij). Bound to <a-g>: Alt+h/j/k/l are
  -- captured by zellij for focus movement even in locked mode, but Alt+g is
  -- free.
  {
    '<a-g>',
    function()
      Snacks.lazygit.open {
        cwd = snacks_search.get_project_root(),
        win = vim.tbl_deep_extend('force', float.float_win(), {
          border = 'rounded',
        }),
      }
    end,
    mode = { 'n' },
    desc = 'Open lazygit',
  },
}

for i = 1, 9 do
  keys[#keys + 1] = {
    string.format('<a-%d>', i),
    function()
      Snacks.terminal(nil, float.shell_float_opts { count = i, cwd = snacks_search.get_project_root() })
    end,
    mode = { 'n' },
    desc = string.format('Open floating terminal %d', i),
  }
end

return {
  {
    'folke/snacks.nvim',
    ---@param opts snacks.Config
    opts = function(_, opts)
      opts.terminal = opts.terminal or {}
      opts.terminal.win = vim.tbl_deep_extend('force', opts.terminal.win or {}, {
        style = 'terminal',
        backdrop = false,
        border = 'single',
        wo = {
          relativenumber = false,
        },
        keys = {
          -- Disable snacks' "double <esc> to normal mode" mapping
          term_normal = false,
        },
      })

      opts.lazygit = {
        enabled = true,
        win = {
          wo = {
            number = false,
          },
        },
      }
    end,
    keys = keys,
  },
}
