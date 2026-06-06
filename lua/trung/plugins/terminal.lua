local function setup_toggleterm()
  require('toggleterm').setup {
    autochdir = false,
    open_mapping = [[<c-\>]],
    hide_numbers = false,
    direction = 'float',
    on_open = function()
      vim.opt_local.number = true
      vim.opt_local.relativenumber = false -- Set to true if you prefer relative
    end,
  }
end

local snacks_search = require('trung.utils.snacks_search')

local function setup_lazygit(Terminal)
  local lazygit = Terminal:new {
    cmd = 'lazygit',
    hidden = true,
    direction = 'float',
    name = 'lazygit',
    on_open = function()
      vim.cmd 'startinsert!'
    end,
    on_close = function()
      vim.cmd 'startinsert!'
    end,
  }

  vim.keymap.set({ 'n', 't' }, '<a-l>', function()
    lazygit.dir = snacks_search.get_project_root()
    lazygit:toggle()
  end, { noremap = true, silent = true })
end

local function setup_numbered_terminals(Terminal)
  local terms = {}

  for i = 1, 9 do
    terms[i] = Terminal:new {
      direction = 'float',
      count = i,
    }
  end

  for i = 1, 9 do
    local key = '<A-' .. i .. '>'
    vim.keymap.set({ 'n', 't' }, key, function()
      terms[i].dir = snacks_search.get_project_root()
      terms[i]:toggle()
    end, {
      desc = 'Toggle floating terminal ' .. i,
    })
  end
end

local function setup_agent_coding(Terminal)
  local agent_coding_float = Terminal:new {
    cmd = 'pi',
    hidden = true,
    direction = 'float',
    name = 'agent_coding',
  }

  local agent_coding_right = Terminal:new {
    cmd = 'pi',
    hidden = true,
    direction = 'vertical',
    name = 'agent_coding_right',
  }

  local function get_active_agent_coding()
    if agent_coding_right:is_open() then
      return agent_coding_right
    end

    return agent_coding_float
  end

  local function send_to_agent_coding(text)
    local agent_coding = get_active_agent_coding()
    if not agent_coding:is_open() then
      if agent_coding == agent_coding_right then
        agent_coding:open(math.floor(vim.o.columns * 0.4), 'vertical')
      else
        agent_coding:open()
      end
    end

    vim.defer_fn(function()
      if agent_coding.job_id then
        vim.api.nvim_chan_send(agent_coding.job_id, text)
      end
    end, 100)
  end

  local function agent_coding_send_file()
    local file = vim.fn.expand '%'
    local line = vim.fn.line '.'
    local position = string.format('@%s:L%d', file, line)
    send_to_agent_coding(position .. '\n')
  end

  local function agent_coding_send_selection()
    local start_pos = vim.fn.getpos "'<"
    local end_pos = vim.fn.getpos "'>"
    local file = vim.fn.expand '%'
    local position = string.format('@%s:L%d-L%d', file, start_pos[2], end_pos[2])
    send_to_agent_coding(position .. '\n')
  end

  local function agent_coding_send_line()
    local file = vim.fn.expand '%'
    local line = vim.fn.line '.'
    local position = string.format('@%s:L%d', file, line)
    send_to_agent_coding(position .. '\n')
  end

  local function open_agent_coding(direction)
    local agent_coding = direction == 'vertical' and agent_coding_right or agent_coding_float

    if agent_coding.job_id then
      if direction == 'vertical' then
        agent_coding:toggle(math.floor(vim.o.columns * 0.3), 'vertical')
      else
        agent_coding:toggle()
      end
      return
    end

    vim.ui.select({ 'Project root', 'Current folder' }, {
      prompt = 'Open agent_coding terminal in:',
    }, function(choice)
      if not choice then
        return
      end

      if choice == 'Current folder' then
        agent_coding.dir = vim.loop.cwd()
      else
        agent_coding.dir = snacks_search.get_project_root()
      end

      if direction == 'vertical' then
        agent_coding:toggle(math.floor(vim.o.columns * 0.3), 'vertical')
      else
        agent_coding:toggle()
      end
    end)
  end

  vim.keymap.set({ 'n', 't' }, '<a-a>', function() open_agent_coding('float') end, { noremap = true, silent = true, desc = 'Toggle floating coding agent terminal' })
  vim.keymap.set({ 'n', 't' }, '<a-A>', function() open_agent_coding('vertical') end, { noremap = true, silent = true, desc = 'Toggle split right coding agent terminal' })
  vim.keymap.set('n', '<leader>af', agent_coding_send_file, { noremap = true, silent = true, desc = '[A]gentCoding send [F]ile' })
  vim.keymap.set('v', '<leader>at', agent_coding_send_selection, { noremap = true, silent = true, desc = '[A]gentCoding send [T]his' })
  vim.keymap.set('n', '<leader>at', agent_coding_send_line, { noremap = true, silent = true, desc = '[A]gentCoding send [T]his' })
end

return {
  'akinsho/toggleterm.nvim',
  event = 'VeryLazy',
  version = '*',
  config = function()
    local Terminal = require('toggleterm.terminal').Terminal

    setup_toggleterm()
    setup_lazygit(Terminal)
    setup_numbered_terminals(Terminal)
    setup_agent_coding(Terminal)
  end,
}
