return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  ft = { 'python' },
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    { 'mason-org/mason.nvim', opts = {} },
    'jay-babu/mason-nvim-dap.nvim',
  },

  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    dapui.setup()

    require('mason-nvim-dap').setup {
      ensure_installed = { 'python' },
      automatic_installation = true,
      handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
      },
    }
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'python',
      group = vim.api.nvim_create_augroup('trung-python-dap-popup', { clear = true }),
      callback = function()
        vim.cmd.amenu [[100.300 PopUp.-DapSep- :]]
        vim.cmd.nmenu [[100.310 PopUp.DAP\ Start <cmd>lua require('dap').continue()<CR>]]
        vim.cmd.nmenu [[100.330 PopUp.DAP\ Toggle\ Breakpoint <cmd>lua require('dap').toggle_breakpoint()<CR>]]
        vim.cmd.nmenu [[100.340 PopUp.DAP\ Conditional\ Breakpoint <cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]]
        vim.cmd.nmenu [[100.390 PopUp.DAP\ Terminate <cmd>lua require('dap').terminate()<CR>]]
      end,
    })

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
