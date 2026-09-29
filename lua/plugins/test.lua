local snacks_search = require 'utils.snacks_search'

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    {
      'fredrikaverpil/neotest-golang',
      version = '*', -- Optional, but recommended; track releases
      build = function()
        vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait()
      end,
    },
    'nvim-neotest/neotest-jest',
    'marilari88/neotest-vitest',
  },
  config = function()
    local function with_project_root(adapter)
      adapter.root = function(path)
        return snacks_search.get_project_root(path)
      end
      return adapter
    end

    require('neotest').setup {
      adapters = {
        require 'neotest-golang' {},
        with_project_root(require 'neotest-jest' {
          jestCommand = 'npm test --',
          jestConfigFile = 'custom.jest.config.ts',
          env = { CI = true },
          cwd = function(path)
            return snacks_search.get_project_root(path)
          end,
          isTestFile = require('neotest-jest.jest-util').defaultIsTestFile,
        }),
        with_project_root(require 'neotest-vitest' {
          cwd = function(path)
            return snacks_search.get_project_root(path)
          end,
        }),
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
  },
}
