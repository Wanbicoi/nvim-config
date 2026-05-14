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

local snacks_search = require('kickstart.util.snacks_search')

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
  local agent_coding = Terminal:new {
    cmd = 'pi',
    hidden = true,
    direction = 'float',
    name = 'agent_coding',
  }

  local function send_to_agent_coding(text)
    if not agent_coding:is_open() then
      agent_coding:open()
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
    local col = vim.fn.col '.'
    local position = string.format('@%s:L%d:C%d', file, line, col)
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

  local function open_agent_coding()
    if agent_coding:is_open() then
      agent_coding:toggle()
      return
    end

    vim.ui.select({ 'Project root' , 'Current folder'}, {
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

      agent_coding:toggle()
    end)
  end

  vim.keymap.set({ 'n', 't' }, '<a-a>', open_agent_coding, { noremap = true, silent = true, desc = 'Toggle agent_coding terminal' })
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
