local snacks_search = require 'trung.utils.snacks_search'
local agent = require 'trung.plugins.terminal.agent'

-- Initialize agent module (autocmds, commands, global dispatchers)
agent.setup()

local function float_win()
  local width = vim.o.columns > 180 and 160 or math.floor(vim.o.columns * 0.9)
  return {
    position = 'float',
    backdrop = false,
    border = 'rounded',
    width = width,
    height = math.floor(vim.o.lines * 0.9),
  }
end

local function shell_float_opts(opts)
  return vim.tbl_deep_extend('force', {
    win = float_win(),
  }, opts or {})
end

local keys = {
  {
    '<a-l>',
    function()
      Snacks.lazygit.open {
        cwd = snacks_search.get_project_root(),
        win = vim.tbl_deep_extend('force', float_win(), {
          border = 'rounded',
        }),
      }
    end,
    mode = { 'n' },
    desc = 'Open lazygit',
  },
  {
    '<a-a>',
    function()
      agent.open_or_toggle()
    end,
    mode = { 'n', 't' },
    desc = 'Toggle coding agent terminal',
  },
  {
    '<leader>an',
    function()
      agent.open_new()
    end,
    mode = { 'n' },
    desc = '[A]gent open [N]ew session',
  },
  {
    '<leader>as',
    function()
      agent.select_session()
    end,
    mode = { 'n' },
    desc = '[A]gent [S]elect session',
  },
  {
    ']a',
    function()
      agent.next_session()
    end,
    mode = { 'n' },
    desc = 'Next coding agent terminal',
  },
  {
    '[a',
    function()
      agent.prev_session()
    end,
    mode = { 'n' },
    desc = 'Previous coding agent terminal',
  },
  {
    '<leader>af',
    agent.send_file,
    mode = 'n',
    desc = '[A]gentCoding send [F]ile',
  },
  {
    '<leader>at',
    agent.send_line,
    mode = 'n',
    desc = '[A]gentCoding send [T]his',
  },
  {
    '<leader>at',
    agent.send_selection,
    mode = 'v',
    desc = '[A]gentCoding send [T]his',
  },
  {
    '<leader>ad',
    agent.send_diagnostic,
    mode = { 'n', 'v' },
    desc = '[A]gentCoding send [D]iagnostic',
  },
}

for i = 1, 9 do
  keys[#keys + 1] = {
    string.format('<a-%d>', i),
    function()
      Snacks.terminal(nil, shell_float_opts { count = i, cwd = snacks_search.get_project_root() })
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
