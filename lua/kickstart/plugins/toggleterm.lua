local function setup_toggleterm()
  require('toggleterm').setup {
    autochdir = true,
    open_mapping = [[<c-\>]],
    hide_numbers = false,
    direction = 'float',
    on_open = function()
      vim.opt_local.number = true
      vim.opt_local.relativenumber = false -- Set to true if you prefer relative
    end,
  }
end

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
      terms[i]:toggle()
    end, {
      desc = 'Toggle floating terminal ' .. i,
    })
  end
end

local function setup_opencode(Terminal)
  local opencode = Terminal:new {
    -- TODO: rename opencode to ai
    cmd = 'pi',
    hidden = true,
    direction = 'float',
    name = 'opencode',
    on_open = function()
      vim.cmd 'startinsert!'
    end,
    on_close = function()
      vim.cmd 'startinsert!'
    end,
  }

  local function send_to_opencode(text)
    if not opencode:is_open() then
      opencode:open()
    end

    vim.defer_fn(function()
      if opencode.job_id then
        vim.api.nvim_chan_send(opencode.job_id, text)
      end
    end, 100)
  end

  local function opencode_send_file()
    local file = vim.fn.expand '%'
    local line = vim.fn.line '.'
    local col = vim.fn.col '.'
    local position = string.format('@%s:L%d:C%d', file, line, col)
    send_to_opencode(position .. '\n')
  end

  local function opencode_send_selection()
    local start_pos = vim.fn.getpos "'<"
    local end_pos = vim.fn.getpos "'>"
    local file = vim.fn.expand '%'
    local position = string.format('@%s:L%d:C%d-L%d:C%d', file, start_pos[2], start_pos[3], end_pos[2], end_pos[3])
    send_to_opencode(position .. '\n')
  end

  local function opencode_send_line()
    local file = vim.fn.expand '%'
    local line = vim.fn.line '.'
    local position = string.format('@%s:L%d', file, line)
    send_to_opencode(position .. '\n')
  end

  vim.keymap.set({ 'n', 't' }, '<a-a>', function()
    opencode:toggle()
  end, { noremap = true, silent = true, desc = 'Toggle OpenCode terminal' })
  vim.keymap.set('n', '<leader>af', opencode_send_file, { noremap = true, silent = true, desc = '[O]penCode send [F]ile' })
  vim.keymap.set('v', '<leader>at', opencode_send_selection, { noremap = true, silent = true, desc = '[O]penCode send [T]his' })
  vim.keymap.set('n', '<leader>at', opencode_send_line, { noremap = true, silent = true, desc = '[O]penCode send [T]his' })
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
    setup_opencode(Terminal)
  end,
}
