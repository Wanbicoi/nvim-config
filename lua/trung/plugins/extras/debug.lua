return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  ft = { 'python' },
  dependencies = {
    {
      'igorlfs/nvim-dap-view',
      opts = {
        virtual_text = {
          enabled = true,
          position = "eol",
        },
        winbar = {
          controls = {
            enabled = true,
          },
        },
      },
    },
    'nvim-neotest/nvim-nio',
    { 'mason-org/mason.nvim', opts = {} },
    'jay-babu/mason-nvim-dap.nvim',
  },

  config = function()
    local dap = require 'dap'
    local dapview = require 'dap-view'

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

    dap.listeners.after.event_initialized['dapview_config'] = dapview.open
    dap.listeners.before.event_terminated['dapview_config'] = dapview.close
    dap.listeners.before.event_exited['dapview_config'] = dapview.close
  end,
}
