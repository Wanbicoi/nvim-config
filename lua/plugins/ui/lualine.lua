return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      {
        'SmiteshP/nvim-navic',
        opts = {
          lsp = {
            auto_attach = true,
          },
        },
      },
    },
    opts = {
      options = {
        globalstatus = true,
        disabled_filetypes = {
          winbar = {
            'OverseerList',
            'OverseerOutput',
            'BookmarksTree',
            'qf',
            'kulala_ui',
            'help',
            'neotest-output-panel',
            'neotest-summary',
            'snacks_layout_box',
            'snacks_picker_list',
            'snacks_picker_input',
            'snacks_terminal',
            'aerial',
            'edgy',
          },
        },
      },
      sections = {
        lualine_c = {
          'lsp_status',
          {
            'navic',
            color_correction = nil,
            -- Can be nil, "static" or "dynamic". This option is useful only when you have highlights enabled.
            -- Many colorschemes don't define same backgroud for nvim-navic as their lualine statusline backgroud.
            -- Setting it to "static" will perform a adjustment once when the component is being setup. This should
            --	 be enough when the lualine section isn't changing colors based on the mode.
            -- Setting it to "dynamic" will keep updating the highlights according to the current modes colors for
            --	 the current section.
            navic_opts = nil, -- lua table with same format as setup's option. All options except "lsp" options take effect when set here.
            on_click = function()
              local navic = require 'nvim-navic'
              if navic.is_available() then
                local data = navic.get_data()
                if data and #data >= 1 then
                  local target = #data >= 2 and data[#data - 1] or data[1]
                  if target and target.scope and target.scope.start then
                    vim.api.nvim_win_set_cursor(0, { target.scope.start.line, target.scope.start.character })
                  end
                end
              end
            end,
          },
        },
      },
      inactive_winbar = {
        lualine_c = {
          {
            'filename',
            path = 3,
          },
        },
      },
      winbar = {
        lualine_a = {
          {
            function()
              return ''
            end,
            separator = '',
            on_click = function()
              vim.api.nvim_feedkeys(vim.keycode '<C-o>', 'n', false)
            end,
          },
          {
            function()
              return ''
            end,
            separator = '',
            on_click = function()
              vim.api.nvim_feedkeys(vim.keycode '<C-i>', 'n', false)
            end,
          },
          {
            function()
              return ''
            end,
            separator = '',
            on_click = function()
              require('mini.bufremove').setup()
              MiniBufremove.wipeout()
            end,
          },
          {
            function()
              return '󰏖 '
            end,
            separator = '',
            on_click = function()
              require('oil').open_float()
            end,
          },
        },
        lualine_c = {
          {
            'filename',
            path = 3,
          },
        },
      },
      extensions = {
        'oil',
        'aerial',
        'overseer',
        'mason',
        {
          sections = {
            lualine_a = {
              {
                function()
                  return ''
                end,
                separator = '',
                on_click = function()
                  pcall(vim.cmd, 'colder')
                end,
              },
              {
                function()
                  return ''
                end,
                on_click = function()
                  pcall(vim.cmd, 'cnewer')
                end,
              },
            },
            lualine_b = {
              function()
                return 'Quickfix List'
              end,
            },
          },
          filetypes = { 'qf' },
        },
      },
    },
  },
}
