return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    -- { 'StevanFreeborn/neotest-playwright', branch = 'fork' },
    'nvim-neotest/neotest-jest',
  },
  config = function()
    local snacks_search = require 'trung.utils.snacks_search'

    require('neotest').setup {
      adapters = {
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
      },
    }
  end,
  keys = {
    {
      '<leader>Tr',
      function()
        require('neotest').run.run()
      end,
      desc = '[T]est [R]un',
    },
    {
      '<leader>Tf',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = '[T]est [F]ile',
    },
    {
      '<leader>Ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = '[T]est [S]ummary',
    },
    {
      '<leader>To',
      function()
        require('neotest').output.open { enter = true }
      end,
      desc = '[T]est [O]utput',
    },
  },
}
