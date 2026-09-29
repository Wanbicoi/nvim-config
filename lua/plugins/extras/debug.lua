local spec = {
  'mfussenegger/nvim-dap',
  cmd = { 'DapNew' },
  dependencies = {
    {
      'igorlfs/nvim-dap-view',
      opts = {
        virtual_text = {
          enabled = true,
          position = 'eol',
        },
        winbar = {
          controls = {
            enabled = true,
          },
        },
      },
    },
    'nvim-neotest/nvim-nio',
    -- { 'mason-org/mason.nvim', opts = {} },
    'jay-babu/mason-nvim-dap.nvim',
  },

  config = function()
    local dap = require 'dap'
    local dapview = require 'dap-view'

    require('mason-nvim-dap').setup {
      ensure_installed = { 'js-debug-adapter' },
      automatic_installation = false,
      handlers = {},
    }

    -- 1. Configure the js-debug-adapter
    local dap_debug_server = vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js'

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = '127.0.0.1',
      port = '${port}',
      executable = {
        command = 'node',
        args = { dap_debug_server, '${port}', '127.0.0.1' },
      },
    }

    -- Helper to find the nearest package.json directory for monorepo setups
    local get_cwd = function()
      local package_json = vim.fs.find({ 'package.json' }, { path = vim.fn.expand '%:p:h', upward = true })[1]
      if package_json then
        return vim.fs.dirname(package_json)
      end
      return vim.fn.getcwd()
    end

    -- 2. Define debug configurations for Javascript/Typescript
    local js_config = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Current File',
        program = '${file}',
        cwd = get_cwd,
        sourceMaps = true,
        protocol = 'inspector',
      },
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach to Running Node Process (Port 9229)',
        port = 9229,
        cwd = get_cwd,
        sourceMaps = true,
        protocol = 'inspector',
      },
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach (Pick Process)',
        processId = require('dap.utils').pick_process,
        cwd = get_cwd,
        sourceMaps = true,
        protocol = 'inspector',
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Debug CAP Service (cds run)',
        runtimeExecutable = 'cds',
        runtimeArgs = { 'run' },
        cwd = get_cwd,
        sourceMaps = true,
        protocol = 'inspector',
        autoAttachChildProcesses = true,
      },
    }

    for _, lang in ipairs { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' } do
      dap.configurations[lang] = js_config
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'python', 'javascript', 'typescript' },
      group = vim.api.nvim_create_augroup('cfg-python-dap-popup', { clear = true }),
      callback = function()
        vim.cmd.amenu [[100.300 PopUp.-DapSep- :]]
        vim.cmd.nmenu [[100.310 PopUp.\ DAP\ Start <cmd>lua require('dap').continue()<CR>]]
        vim.cmd.nmenu [[100.330 PopUp.\ DAP\ Toggle\ Breakpoint <cmd>lua require('dap').toggle_breakpoint()<CR>]]
        vim.cmd.nmenu [[100.340 PopUp.\ DAP\ Conditional\ Breakpoint <cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]]
        vim.cmd.nmenu [[100.390 PopUp.\ DAP\ Terminate <cmd>lua require('dap').terminate()<CR>]]
      end,
    })

    dap.listeners.after.event_initialized['dapview_config'] = dapview.open
    dap.listeners.before.event_terminated['dapview_config'] = dapview.close
    dap.listeners.before.event_exited['dapview_config'] = dapview.close
  end,
}

return { spec }
