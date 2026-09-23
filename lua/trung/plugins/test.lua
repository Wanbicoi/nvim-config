return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    {
      'fredrikaverpil/neotest-golang',
      version = '*', -- Optional, but recommended; track releases
      build = function()
        vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait() -- Optional, but recommended
      end,
    },
    -- { 'StevanFreeborn/neotest-playwright', branch = 'fork' },
    'nvim-neotest/neotest-jest',
    'marilari88/neotest-vitest',
  },
  config = function()
    local snacks_search = require 'trung.utils.snacks_search'

    require('neotest').setup {
      adapters = {
        require 'neotest-golang' {
          -- runner = 'gotestsum', -- optional, defaults to 'go'
          -- go_test_args = { '-v', '-race', '-count=1', '-timeout=60s' },
        },
        -- require('neotest-playwright').adapter {
        --   options = {
        --     persist_project_selection = true,
        --     enable_dynamic_test_discovery = true,
        --   },
        -- },
        require 'neotest-jest' {
          jestCommand = 'npm test --',
          jestArguments = function(defaultArguments, context)
            return defaultArguments
          end,
          jestConfigFile = 'custom.jest.config.ts',
          env = { CI = true },
          cwd = function(path)
            return snacks_search.get_project_root(path)
          end,
          isTestFile = require('neotest-jest.jest-util').defaultIsTestFile,
        },
        require 'neotest-vitest' {
          cwd = function(path)
            return snacks_search.get_project_root(path)
          end,
        },
      },
    }
  end,
  keys = {
    {
      '<leader>t',
      function()
        require('neotest').summary.toggle()
      end,
      desc = '[T]est Summary',
    },
    -- {
    --   '<leader>Tr',
    --   function()
    --     require('neotest').run.run()
    --   end,
    --   desc = '[T]est [R]un Nearest',
    -- },
    -- {
    --   '<leader>Tf',
    --   function()
    --     require('neotest').run.run(vim.fn.expand '%')
    --   end,
    --   desc = '[T]est Current [F]ile',
    -- },
    -- {
    --   '<leader>To',
    --   function()
    --     require('neotest').output.open { enter = true, auto_close = true }
    --   end,
    --   desc = '[T]est [O]utput',
    -- },
    -- {
    --   '<leader>Tp',
    --   function()
    --     require('neotest').output_panel.toggle()
    --   end,
    --   desc = '[T]est [P]anel Toggle',
    -- },
    -- {
    --   '<leader>Td',
    --   function()
    --     require('neotest').run.run { strategy = 'dap' }
    --   end,
    --   desc = '[T]est [D]ebug Nearest',
    -- },
  },
}
