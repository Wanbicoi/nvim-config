-- Toggleterm configuration with lazygit and 9 floating terminals
return {
  'akinsho/toggleterm.nvim',
  event = 'VeryLazy',
  version = '*',
  config = function()
    require('toggleterm').setup {
      open_mapping = [[<c-\>]],
      hide_numbers = false,
      on_open = function()
        vim.opt_local.number = true
        vim.opt_local.relativenumber = false -- Set to true if you prefer relative
      end,
      direction = 'float',
    }
    local Terminal = require('toggleterm.terminal').Terminal

    -- Lazygit
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
    local function lazygit_toggle()
      lazygit:toggle()
    end
    vim.keymap.set({ 'n', 't' }, '<a-l>', lazygit_toggle, { noremap = true, silent = true })

    -- Create 9 floating terminals
    local terms = {}
    for i = 1, 9 do
      terms[i] = Terminal:new {
        direction = 'float',
        count = i,
      }
    end

    -- Helper to toggle terminal by index
    local function toggle_term(i)
      return function()
        terms[i]:toggle()
      end
    end

    -- Map <A-1> .. <A-9> in NORMAL + TERMINAL mode
    for i = 1, 9 do
      local key = '<A-' .. i .. '>'
      vim.keymap.set({ 'n', 't' }, key, toggle_term(i), {
        desc = 'Toggle floating terminal ' .. i,
      })
    end

    -- OpenCode Terminal
    local opencode = Terminal:new {
      cmd = 'opencode',
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

    local function opencode_toggle()
      opencode:toggle()
    end

    -- Helper function to send text to OpenCode terminal
    local function send_to_opencode(text)
      if not opencode:is_open() then
        opencode:open()
      end
      -- Send text directly to the terminal's job
      vim.defer_fn(function()
        if opencode.job_id then
          vim.api.nvim_chan_send(opencode.job_id, text)
        end
      end, 100)
    end

    -- Send current file with cursor position to OpenCode
    local function opencode_send_file()
      local file = vim.fn.expand '%'
      local line = vim.fn.line '.'
      local col = vim.fn.col '.'
      local position = string.format('@%s:L%d:C%d', file, line, col)
      send_to_opencode(position .. '\n')
    end

    -- Send visual selection with position to OpenCode
    local function opencode_send_selection()
      -- Get visual selection positions
      local start_pos = vim.fn.getpos "'<"
      local end_pos = vim.fn.getpos "'>"
      local file = vim.fn.expand '%'

      -- Format: @file:L<start_line>:C<start_col>-L<end_line>:C<end_col>
      local position = string.format('@%s:L%d:C%d-L%d:C%d', file, start_pos[2], start_pos[3], end_pos[2], end_pos[3])
      send_to_opencode(position .. '\n')
    end

    -- Send current line with position to OpenCode
    local function opencode_send_line()
      local file = vim.fn.expand '%'
      local line = vim.fn.line '.'
      local position = string.format('@%s:L%d', file, line)
      send_to_opencode(position .. '\n')
    end

    -- Keybindings for OpenCode
    vim.keymap.set({ 'n', 't' }, '<a-a>', opencode_toggle, { noremap = true, silent = true, desc = 'Toggle OpenCode terminal' })
    vim.keymap.set('n', '<leader>af', opencode_send_file, { noremap = true, silent = true, desc = '[O]penCode send [F]ile' })
    vim.keymap.set('v', '<leader>at', opencode_send_selection, { noremap = true, silent = true, desc = '[O]penCode send [T]his' })
    vim.keymap.set('n', '<leader>at', opencode_send_line, { noremap = true, silent = true, desc = '[O]penCode send [T]his' })
  end,
}
