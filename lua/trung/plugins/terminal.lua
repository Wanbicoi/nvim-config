local snacks_search = require 'trung.utils.snacks_search'

local agent_state = {
  float = { count = 101 },
  right = { count = 102 },
}

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

local function agent_opts(kind)
  local state = agent_state[kind]
  return {
    count = state.count,
    cwd = state.cwd,
    win = kind == 'right' and {
      position = 'right',
      width = math.floor(vim.o.columns * 0.3),
    } or float_win(),
  }
end

local function pick_agent_cwd(callback)
  vim.ui.select({ 'Project root', 'Current folder' }, {
    prompt = 'Open agent_coding terminal in:',
  }, function(choice)
    if not choice then
      return
    end

    callback(choice == 'Current folder' and vim.uv.cwd() or snacks_search.get_project_root())
  end)
end

local function open_agent_coding(kind)
  local state = agent_state[kind]
  if state.cwd then
    Snacks.terminal('pi', agent_opts(kind))
    return
  end

  pick_agent_cwd(function(cwd)
    state.cwd = cwd
    Snacks.terminal('pi', agent_opts(kind))
  end)
end

local function get_active_agent_kind()
  local right = Snacks.terminal.get('pi', vim.tbl_extend('force', agent_opts 'right', { create = false }))
  if right and right:win_valid() then
    return 'right'
  end
  return 'float'
end

local function send_to_agent_coding(text)
  local kind = get_active_agent_kind()
  local state = agent_state[kind]

  local function send()
    local term = Snacks.terminal.get('pi', agent_opts(kind))
    if term and not term:win_valid() then
      term:show()
    end

    vim.defer_fn(function()
      if not (term and term:buf_valid()) then
        return
      end
      local chan = vim.bo[term.buf].channel
      if chan and chan > 0 then
        vim.fn.chansend(chan, text)
      end
    end, 100)
  end

  if state.cwd then
    send()
    return
  end

  pick_agent_cwd(function(cwd)
    state.cwd = cwd
    send()
  end)
end

local function agent_coding_send_file()
  local file = vim.fn.expand '%'
  local line = vim.fn.line '.'
  send_to_agent_coding(string.format('@%s:L%d\n', file, line))
end

local function agent_coding_send_selection()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local file = vim.fn.expand '%'
  send_to_agent_coding(string.format('@%s:L%d-L%d\n', file, start_pos[2], end_pos[2]))
end

local function agent_coding_send_line()
  local file = vim.fn.expand '%'
  local line = vim.fn.line '.'
  send_to_agent_coding(string.format('@%s:L%d\n', file, line))
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
          number = true,
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
    keys = {
      {
        '<c-\\>',
        function()
          Snacks.terminal(nil, shell_float_opts { count = vim.v.count1 })
        end,
        mode = { 'n', 't' },
        desc = 'Toggle terminal',
      },
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
        mode = { 'n', 't' },
        desc = 'Toggle lazygit',
      },
      {
        '<a-a>',
        function()
          open_agent_coding 'float'
        end,
        mode = { 'n', 't' },
        desc = 'Toggle floating coding agent terminal',
      },
      {
        '<a-A>',
        function()
          open_agent_coding 'right'
        end,
        mode = { 'n', 't' },
        desc = 'Toggle split right coding agent terminal',
      },
      {
        '<leader>af',
        agent_coding_send_file,
        mode = 'n',
        desc = '[A]gentCoding send [F]ile',
      },
      {
        '<leader>at',
        agent_coding_send_line,
        mode = 'n',
        desc = '[A]gentCoding send [T]his',
      },
      {
        '<leader>at',
        agent_coding_send_selection,
        mode = 'v',
        desc = '[A]gentCoding send [T]his',
      },
      {
        '<a-1>',
        function()
          Snacks.terminal(nil, shell_float_opts { count = 1, cwd = snacks_search.get_project_root() })
        end,
        mode = { 'n', 't' },
        desc = 'Toggle floating terminal 1',
      },
      {
        '<a-2>',
        function()
          Snacks.terminal(nil, shell_float_opts { count = 2, cwd = snacks_search.get_project_root() })
        end,
        mode = { 'n', 't' },
        desc = 'Toggle floating terminal 2',
      },
      {
        '<a-3>',
        function()
          Snacks.terminal(nil, shell_float_opts { count = 3, cwd = snacks_search.get_project_root() })
        end,
        mode = { 'n', 't' },
        desc = 'Toggle floating terminal 3',
      },
      {
        '<a-4>',
        function()
          Snacks.terminal(nil, shell_float_opts { count = 4, cwd = snacks_search.get_project_root() })
        end,
        mode = { 'n', 't' },
        desc = 'Toggle floating terminal 4',
      },
      {
        '<a-5>',
        function()
          Snacks.terminal(nil, shell_float_opts { count = 5, cwd = snacks_search.get_project_root() })
        end,
        mode = { 'n', 't' },
        desc = 'Toggle floating terminal 5',
      },
      {
        '<a-6>',
        function()
          Snacks.terminal(nil, shell_float_opts { count = 6, cwd = snacks_search.get_project_root() })
        end,
        mode = { 'n', 't' },
        desc = 'Toggle floating terminal 6',
      },
      {
        '<a-7>',
        function()
          Snacks.terminal(nil, shell_float_opts { count = 7, cwd = snacks_search.get_project_root() })
        end,
        mode = { 'n', 't' },
        desc = 'Toggle floating terminal 7',
      },
      {
        '<a-8>',
        function()
          Snacks.terminal(nil, shell_float_opts { count = 8, cwd = snacks_search.get_project_root() })
        end,
        mode = { 'n', 't' },
        desc = 'Toggle floating terminal 8',
      },
      {
        '<a-9>',
        function()
          Snacks.terminal(nil, shell_float_opts { count = 9, cwd = snacks_search.get_project_root() })
        end,
        mode = { 'n', 't' },
        desc = 'Toggle floating terminal 9',
      },
    },
  },
}
