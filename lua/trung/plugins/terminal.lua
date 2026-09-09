local snacks_search = require 'trung.utils.snacks_search'

local current_agent = 'agy'

local agent_cmds = {
  agy = 'agy --dangerously-skip-permissions',
  claude = 'claude --dangerously-skip-permissions',
}

local agent_state = {
  float = { count = 101 },
  right = { count = 102 },
}

vim.api.nvim_create_autocmd({ 'TermClose', 'BufWipeout' }, {
  group = vim.api.nvim_create_augroup('agy_terminal_monitor', { clear = true }),
  callback = function(ev)
    local ok, snacks_term = pcall(function()
      return vim.b[ev.buf].snacks_terminal
    end)
    if ok and snacks_term then
      for _, cmd in pairs(agent_cmds) do
        if snacks_term.cmd == cmd then
          if snacks_term.id == 101 then
            agent_state.float.cwd = nil
          elseif snacks_term.id == 102 then
            agent_state.right.cwd = nil
          end
          break
        end
      end
    end
  end,
})

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
      width = math.floor(vim.o.columns * 0.4),
    } or float_win(),
  }
end

local function pick_agent_and_cwd(callback)
  vim.ui.select({ 'agy', 'claude' }, {
    prompt = 'Select Coding Agent:',
  }, function(agent_choice)
    if not agent_choice then
      return
    end
    current_agent = agent_choice

    vim.ui.select({ 'Project root', 'Current folder' }, {
      prompt = string.format('Open %s terminal in:', current_agent),
    }, function(cwd_choice)
      if not cwd_choice then
        return
      end

      callback(cwd_choice == 'Current folder' and vim.uv.cwd() or snacks_search.get_project_root())
    end)
  end)
end

local function hide_agent_coding(kind)
  for _, cmd in pairs(agent_cmds) do
    local term = Snacks.terminal.get(cmd, vim.tbl_extend('force', agent_opts(kind), { create = false }))
    if term and term:win_valid() then
      term:hide()
    end
  end
end

local function hide_other_floating_terminals(current)
  for _, term in ipairs(Snacks.terminal.list()) do
    if term ~= current and term:win_valid() and term.opts.position == 'float' then
      term:hide()
    end
  end
end

local function open_agent_coding(kind)
  local state = agent_state[kind]
  local other_kind = kind == 'right' and 'float' or 'right'

  hide_agent_coding(other_kind)

  local function open()
    local cmd = agent_cmds[current_agent] or current_agent
    if kind == 'float' then
      hide_other_floating_terminals(nil)
      Snacks.terminal.focus(cmd, agent_opts(kind))
    else
      Snacks.terminal(cmd, agent_opts(kind))
    end
  end

  if state.cwd then
    open()
    return
  end

  pick_agent_and_cwd(function(cwd)
    state.cwd = cwd
    open()
  end)
end

local function get_active_agent_kind()
  for _, cmd in pairs(agent_cmds) do
    local right = Snacks.terminal.get(cmd, vim.tbl_extend('force', agent_opts 'right', { create = false }))
    if right and right:win_valid() then
      return 'right'
    end
  end
  return 'right'
end

local function send_to_agent_coding(text)
  local kind = get_active_agent_kind()
  local state = agent_state[kind]

  local function send()
    local cmd = agent_cmds[current_agent] or current_agent
    local term = Snacks.terminal.get(cmd, agent_opts(kind))
    if term then
      if kind == 'float' then
        hide_other_floating_terminals(term)
      end
      if not term:win_valid() then
        term:show()
      end
      term:focus()
    end

    vim.defer_fn(function()
      if not (term and term:buf_valid()) then
        return
      end
      local chan = vim.bo[term.buf].channel
      if chan and chan > 0 then
        vim.api.nvim_chan_send(chan, text)
      end
      if term and term:win_valid() then
        term:focus()
        vim.cmd 'startinsert'
      end
    end, 100)
  end

  if state.cwd then
    send()
    return
  end

  pick_agent_and_cwd(function(cwd)
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
    '<a-A>',
    function()
      open_agent_coding 'float'
    end,
    mode = { 'n' },
    desc = 'Open floating coding agent terminal',
  },
  {
    '<a-a>',
    function()
      open_agent_coding 'right'
    end,
    mode = { 'n' },
    desc = 'Open split right coding agent terminal',
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

_G.agent_coding = {
  send_line = agent_coding_send_line,
  send_selection = agent_coding_send_selection,
}

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
          -- number = true,
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
