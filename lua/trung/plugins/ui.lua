local snacks_search = require 'trung.utils.snacks_search'

local function set_tab_title(session_name)
  local title = session_name
  if type(title) ~= 'string' or title == '' then
    title = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  else
    title = vim.fn.fnamemodify(title:gsub('/+$', ''), ':t')
  end

  if title and title ~= '' then
    if vim.env.TMUX and vim.fn.executable 'tmux' == 1 then
      vim.fn.system { 'tmux', 'rename-window', title }
    end

    local wezterm_bin = vim.fn.executable 'wezterm.exe' == 1 and 'wezterm.exe' or (vim.fn.executable 'wezterm' == 1 and 'wezterm' or nil)
    if wezterm_bin then
      vim.fn.system { wezterm_bin, 'cli', 'set-tab-title', title }
    end
  end
end

local get_git_nodes = function(root_path)
  local Tree = require 'snacks.explorer.tree'
  local nodes = {}
  Tree:walk(Tree:find(root_path), function(node)
    if node.status then
      table.insert(nodes, node)
    end
  end)

  return nodes
end

local is_git_item = function(item, git_nodes)
  return vim.iter(git_nodes):any(function(node)
    if node.dir_status then
      return vim.fs.relpath(node.path, item.file) ~= nil
    end
    return vim.fs.relpath(item.file, node.path) ~= nil
  end)
end

return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 500,
      icons = {
        keys = {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]iff' },
        { '<leader>w', group = '[W]orkspace' },
        -- { '<leader>t', group = '[T]est / [T]oggle' },
        { '<leader>t', group = '[T]est' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>o', group = '[O]verseer' },
      },
    },
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = {
        size = 1.5 * 1024 * 1024, -- 1.5MB
        line_length = 50000, -- average line length (useful for minified files)
        enabled = true,
      },
      explorer = { enabled = true },
      words = { enabled = true },
      gitbrowse = {
        enabled = true,
        url_patterns = {
          ['gitlab.i*%.com'] = {
            branch = '/tree/{branch}',
            file = '/blob/{branch}/{file}#L{line_start}-L{line_end}',
            permalink = '/blob/{commit}/{file}#L{line_start}-L{line_end}',
            commit = '/commit/{commit}',
          },
        },
      },
      quickfile = { enabled = true },
      notifier = { enabled = true, top_down = false },
      indent = {
        enabled = true,
        chunk = {
          enabled = true,
        },
      },
      statuscolumn = {
        enabled = true,
        folds = {
          open = true,
        },
      },
      ---@type snacks.picker.Config
      picker = {
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'package.json', 'Makefile', 'AGENTS.md' },
        layouts = {
          custom_dropdown = {
            layout = {
              backdrop = false,
              row = 1,
              width = 0.7,
              min_width = 80,
              height = 0.9,
              border = 'none',
              box = 'vertical',
              { win = 'preview', title = '{preview}', height = 0.7, border = true },
              {
                box = 'vertical',
                border = true,
                title = '{title} {live} {flags}',
                title_pos = 'center',
                { win = 'input', height = 1, border = 'bottom' },
                { win = 'list', border = 'none' },
              },
            },
          },
        },
        layout = {
          preset = 'custom_dropdown',
        },
        win = {
          list = {
            keys = {
              ['<c-j>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['<c-k>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
            },
          },
          input = {
            keys = {
              ['<c-j>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['<c-k>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
            },
          },
        },
        ui_select = true,
        sources = {
          projects = {
            dev = { '~/Repos' },
            patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'package.json', 'Makefile', 'be-group' },
          },
          explorer = {
            finder = function(opts, ctx)
              ---@diagnostic disable-next-line: undefined-field
              if ctx.picker.opts.git_filter then
                ---@diagnostic disable-next-line: inject-field
                ctx.picker.git_nodes = get_git_nodes(ctx.filter.cwd)
              else
                ---@diagnostic disable-next-line: inject-field
                ctx.picker.git_nodes = nil
              end
              return require('snacks.picker.source.explorer').explorer(opts, ctx)
            end,
            transform = function(item, ctx)
              ---@diagnostic disable-next-line: undefined-field
              if ctx.picker.git_nodes then
                ---@diagnostic disable-next-line: undefined-field
                return is_git_item(item, ctx.picker.git_nodes)
              end
              return true
            end,
            toggles = {
              git_filter = { icon = '', value = false },
            },
            win = {
              list = {
                keys = {
                  ['gs'] = 'toggle_git_filter',
                },
              },
            },
          },
        },
      },
    },
    keys = {
      {
        '<a-f>',
        function()
          Snacks.zen.zoom()
        end,
        mode = { 'n', 't' },
        desc = 'Toggle Full Screen / Zoom',
      },
      {
        '<leader>e',
        function()
          Snacks.explorer { hidden = true }
        end,
        desc = '[E]xplorer',
        mode = { 'n' },
      },
      {
        '<leader>gB',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Git Browse',
        mode = { 'n', 'v' },
      },
      {
        '<leader><leader>',
        function()
          snacks_search.project('git_files', { untracked = true })
        end,
        desc = '[F]ind [G]it Files',
      },
      {
        '<leader>fa',
        function()
          snacks_search.project('files', { hidden = true, ignored = true })
        end,
        desc = '[F]ind [A]ll',
      },
      {
        '<F2>',
        function()
          snacks_search.pwd('files', { hidden = true, ignored = true })
        end,
        desc = '[F]ind [A]ll (cwd)',
      },
      {
        '<F3>',
        function()
          snacks_search.pwd 'grep'
        end,
        desc = '[G]rep (cwd)',
      },
      {
        '<leader>ff',
        function()
          snacks_search.project('files', {
            hidden = true,
            ignore = true,
            exclude = {
              'node_modules',
              'vendor',
              'target',
              'dist',
              'build',
              'out',
              'obj',
              'bin',
              '.venv',
              'venv',
              '.mypy_cache',
              '.pytest_cache',
              '.next',
              '.nuxt',
              '.svelte-kit',
              '.angular',
              '.expo',
              '.git',
              '.terraform',
              '.terragrunt-cache',
              '.DS_Store',
              'Thumbs.db',
            },
          })
        end,
        desc = '[F]ind [F]iles',
      },
      {
        '<leader>Ff',
        function()
          snacks_search.pwd('files', {
            hidden = true,
            ignore = true,
            exclude = {
              'node_modules',
              'vendor',
              'target',
              'dist',
              'build',
              'out',
              'obj',
              'bin',
              '.venv',
              'venv',
              '.mypy_cache',
              '.pytest_cache',
              '.next',
              '.nuxt',
              '.svelte-kit',
              '.angular',
              '.expo',
              '.git',
              '.terraform',
              '.terragrunt-cache',
              '.DS_Store',
              'Thumbs.db',
            },
          })
        end,
        desc = '[F]ind [F]iles (cwd)',
      },
      {
        '<leader>ft',
        function()
          Snacks.picker.pickers()
        end,
        desc = '[F]ind Picker [T]ypes',
      },
      {
        '<leader>fW',
        function()
          local word = vim.fn.expand '<cword>'
          snacks_search.project('files', { pattern = word })
        end,
        desc = '[F]ind file of the current [W]ord',
      },
      {
        '<leader>FW',
        function()
          local word = vim.fn.expand '<cword>'
          snacks_search.pwd('files', { pattern = word })
        end,
        desc = '[F]ind file of the current [W]ord (cwd)',
      },
      {
        '<leader>fw',
        function()
          snacks_search.project 'grep_word'
        end,
        desc = '[F]ind current [W]ord',
      },
      {
        '<leader>Fw',
        function()
          snacks_search.pwd 'grep_word'
        end,
        desc = '[F]ind current [W]ord (cwd)',
      },
      {
        '<leader>/',
        function()
          snacks_search.project 'grep'
        end,
        desc = '[G]rep',
      },
      {
        '<leader>?',
        function()
          local text = vim.fn.getreg '+'
          text = vim.trim(text:gsub('[\n\r]', ' '))
          snacks_search.project('grep', { search = text })
        end,
        desc = '[G]rep with copied text',
      },
      {
        '<leader>F?',
        function()
          local text = vim.fn.getreg '+'
          text = vim.trim(text:gsub('[\n\r]', ' '))
          snacks_search.pwd('grep', { search = text })
        end,
        desc = '[G]rep with copied text (cwd)',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.resume()
        end,
        desc = '[F]ind [R]esume',
      },
      {
        '<leader>fo',
        function()
          Snacks.picker.recent()
        end,
        desc = '[F]ind Recent Files',
      },
      {
        '_',
        function()
          Snacks.picker.buffers()
        end,
        desc = '[_] Find existing buffers',
      },
      {
        '<leader>gb',
        function()
          snacks_search.project 'git_branches'
        end,
        desc = 'Git Branches',
      },
      -- {
      --   '<leader>gl',
      --   function()
      --     snacks_search.project 'git_log'
      --   end,
      --   desc = 'Git Log',
      -- },
      {
        '<leader>gl',
        function()
          snacks_search.project 'git_log_line'
        end,
        desc = 'Git Log Line',
      },
      {
        '<leader>gs',
        function()
          snacks_search.project 'git_status'
        end,
        desc = 'Git Status',
      },
      -- {
      --   '<leader>gS',
      --   function()
      --     local explorer = Snacks.picker.get({ source = 'explorer' })[1]
      --     if explorer and not explorer.closed then
      --       explorer:action 'toggle_git_filter'
      --       return
      --     end
      --     Snacks.picker.explorer {
      --       git_filter = true,
      --     }
      --   end,
      --   desc = 'Toggle Git Status Explorer Filter',
      -- },
      {
        '<leader>gd',
        function()
          snacks_search.project 'git_diff'
        end,
        desc = 'Git Diff (Hunks)',
      },
      {
        '<leader>gf',
        function()
          snacks_search.project 'git_log_file'
        end,
        desc = 'Git Log File',
      },
      {
        '<leader>fc',
        function()
          Snacks.picker.commands()
        end,
        desc = '[F]ind [C]ommands',
      },
      {
        '<leader>fn',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[F]ind [N]eovim files',
      },
      {
        '<leader>fh',
        function()
          Snacks.picker.help()
        end,
        desc = '[F]ind [H]elp',
      },
      {
        '<leader>fk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = '[F]ind [K]eymaps',
      },
      {
        '<leader>fd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = '[F]ind [D]iagnostics',
      },
      {
        '<leader>fp',
        function()
          Snacks.picker.projects {
            dev = {
              '~/Repos',
            },
            matcher = {
              cwd_bonus = true,
            },
          }
        end,
        desc = '[F]ind [P]rojects',
      },
      {
        '<leader>fm',
        function()
          Snacks.picker.marks()
        end,
        desc = '[F]ind [M]arks',
      },
    },
    config = function(_, opts)
      require('snacks').setup(opts)
      _ = Snacks.notifier
    end,
  },
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
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      -- auto_restore_last_session = true,
      auto_create = false,
      post_restore_cmds = { set_tab_title },
      post_save_cmds = { set_tab_title },
      legacy_cmds = false,
      cwd_change_handling = true,
      session_lens = {
        picker = 'snacks',
      },
      close_filetypes_on_save = {
        'checkhealth',
        'snacks_terminal',
        'snacks_layout_box',
        'snacks_picker_list',
        'snacks_picker_input',
        'OverseerList',
        'OverseerOutput',
        'aerial',
        'neotest-output-panel',
        'neotest-summary',
        'qf',
        'help',
      },
      bypass_save_filetypes = {
        'BookmarksTree',
        'kulala_ui',
        'snacks_picker_list',
        'snacks_terminal',
        'snacks_layout_box',
        'OverseerList',
        'OverseerOutput',
      },
    },
    keys = {
      { '<leader>fs', '<cmd>AutoSession search<CR>', desc = 'Session search' },
    },
  },
  {
    'stevearc/aerial.nvim',
    opts = {
      backends = { 'lsp', 'treesitter', 'markdown', 'asciidoc', 'man' },
      -- 1. Ensure Variable and Constant are permitted for JS/TS
      filter_kind = {
        'Class',
        'Constructor',
        'Enum',
        'Function',
        'Interface',
        'Module',
        'Method',
        'Struct',
        -- Required to catch arrow functions:
        -- 'Variable',
        -- 'Constant',
      },

      -- post_parse_symbol = function(bufnr, item, _)
      --   local filetype = vim.bo[bufnr].filetype
      --   if filetype == 'typescript' or filetype == 'typescriptreact' or filetype == 'javascript' or filetype == 'javascriptreact' then
      --     -- If it's a constant or variable, only keep it if it acts like a function component or block (has children)
      --     if item.kind == 'Constant' or item.kind == 'Variable' then
      --       return item.children and #item.children > 0
      --     end
      --     if item.kind == 'Function' and (string.match(item.name, ' callback$') or item.name == '<function>') then
      --       return false
      --     end
      --   end
      --
      --   return true -- Keep everything else intact
      -- end,
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = { 'AerialToggle', 'AerialOpen' },
    keys = {
      {
        '<leader>A',
        function()
          require('aerial').toggle {}
        end,
        mode = 'n',
        desc = '[A]erial toggle',
      },
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    enabled = false,
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
      label = {
        uppercase = false,
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
  ---@module "neominimap.config.meta"
  -- {
  --   'Isrothy/neominimap.nvim',
  --   version = 'v3.x.x',
  --   lazy = false, -- NOTE: NO NEED to Lazy load
  --   -- Optional. You can also set your own keybindings
  --   init = function()
  --     -- -- The following options are recommended when layout == "float"
  --     -- vim.opt.wrap = false
  --     -- vim.o.sidescrolloff = 20 -- Set a large value
  --
  --     --- Put your configuration here
  --     ---@type Neominimap.UserConfig
  --     vim.g.neominimap = {
  --       auto_enable = true,
  --       layout = 'split',
  --       float = {
  --         window_border = 'none',
  --       },
  --     }
  --   end,
  -- },
  -- {
  --   'MeanderingProgrammer/render-markdown.nvim',
  --   dependencies = { 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
  --   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
  --   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  --   ---@module 'render-markdown'
  --   ---@type render.md.UserConfig
  --   opts = {
  --     file_types = { 'markdown', 'practice-description' },
  --   },
  -- For `plugins/markview.lua` users.
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    -- Completion for `blink.cmp`
    dependencies = { 'saghen/blink.cmp' },
  },
  -- },
  -- {
  --   'soulis-1256/eagle.nvim',
  --   opts = {},
  --   event = 'VeryLazy',
  -- },
  -- {
  --   'lewis6991/satellite.nvim',
  --   opts = {},
  --   event = 'VeryLazy',
  -- },
  {
    'glacambre/firenvim',
    build = ':call firenvim#install(0)',
    config = function()
      vim.g.firenvim_config = {
        globalSettings = {
          ['<C-w>'] = 'noop',
          ['<C-n>'] = 'default',
        },
        localSettings = {
          ['.*'] = {
            cmdline = 'neovim',
            content = 'text',
            priority = 0,
            selector = 'textarea',
            takeover = 'never',
          },
          ['.*designgurus\\.io.*'] = {
            takeover = 'always',
            priority = 1, -- Higher priority so it overrides the catch-all rule
            cmdline = 'neovim',
            content = 'text',
            selector = 'textarea.inputarea.monaco-mouse-cursor-text',
            filename = '/home/troy/Downloads/coding/main.py',
          },
        },
      }

      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = '*designgurus*.txt',
        callback = function()
          vim.cmd 'set filetype=python'
          vim.cmd 'GuessIndent'
        end,
      })
      vim.o.guifont = 'JetBrainsMono Nerd Font Propo:h9.5'
    end,
  },
  {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = 'screen'
    end,
    opts = {
      options = {
        left = { size = 35 },
      },
      right = {
        {
          ft = 'snacks_terminal',
          title = '%{b:snacks_terminal.id}: %{b:term_title}',
          size = { width = 0.4 },
          filter = function(_, win)
            return vim.w[win].snacks_win
              and vim.w[win].snacks_win.position == 'right'
              and vim.w[win].snacks_win.relative == 'editor'
              and not vim.w[win].trouble_preview
          end,
        },
      },
      bottom = {
        {
          ft = 'OverseerOutput',
          title = 'Overseer Output',
          size = { height = 7 },
        },
        {
          ft = 'qf',
          title = 'QuickFix',
          size = { height = 10 },
        },
        {
          ft = 'help',
          size = { height = 15 },
          filter = function(buf)
            return vim.bo[buf].buftype == 'help'
          end,
        },
        {
          ft = 'neotest-summary',
          title = 'Neotest Summary',
        },
      },
      left = {
        {
          ft = 'snacks_layout_box',
          title = 'Explorer',
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ''
          end,
        },
        {
          ft = 'aerial',
          -- pinned = true,
          title = 'Symbols (Aerial)',
          open = 'AerialOpen',
        },
        {
          ft = 'OverseerList',
          title = 'Overseer',
          open = function()
            require('overseer').open()
          end,
          size = { height = 10 },
          pinned = false,
        },
      },
      animate = {
        enabled = false,
      },
      wo = {
        winbar = false,
      },
    },
  },
}
