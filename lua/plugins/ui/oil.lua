return {
  {
    'stevearc/oil.nvim',
    opts = {
      keymaps = {
        ['q'] = { 'actions.close', mode = 'n' },
        ['gc'] = { 'actions.yank_entry', mode = 'n' },
        ['gC'] = {
          desc = 'Copy Windows path to clipboard',
          mode = 'n',
          callback = function()
            local oil = require 'oil'
            local entry = oil.get_cursor_entry()
            local dir = oil.get_current_dir()
            if not entry or not dir then
              return
            end
            local path = dir .. entry.name .. (entry.type == 'directory' and '/' or '')
            if vim.fn.has 'wsl' == 1 or vim.fn.executable 'wslpath' == 1 then
              local win_path = vim.fn.system { 'wslpath', '-w', path }
              if vim.v.shell_error == 0 then
                path = vim.trim(win_path)
              end
            end
            vim.fn.setreg('+', path)
            vim.fn.setreg('"', path)
            vim.notify('Copied Windows path: ' .. path, vim.log.levels.INFO, { title = 'Oil' })
          end,
        },
        ['c-o'] = { 'actions.open_external', mode = 'n' },
        ['<2-LeftMouse>'] = function()
          local mouse = vim.fn.getmousepos()
          vim.api.nvim_win_set_cursor(mouse.winid, { mouse.line, mouse.column - 1 })
          require('oil').select()
        end,
        ['<RightMouse>'] = { 'actions.parent', mode = 'n' },
      },
      float = {
        padding = 4,
        max_width = 80,
        border = 'single',
      },
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '-', '<CMD>Oil --float<CR>', desc = 'Open parent directory' },
    },
  },
}
