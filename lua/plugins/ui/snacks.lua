local snacks_search = require 'utils.snacks_search'

-- Common noise directories/files excluded from file pickers.
local EXCLUDE = {
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
}

local function get_git_nodes(root_path)
  local Tree = require 'snacks.explorer.tree'
  local nodes = {}
  Tree:walk(Tree:find(root_path), function(node)
    if node.status then
      table.insert(nodes, node)
    end
  end)
  return nodes
end

local function is_git_item(item, git_nodes)
  return vim.iter(git_nodes):any(function(node)
    if node.dir_status then
      return vim.fs.relpath(node.path, item.file) ~= nil
    end
    return vim.fs.relpath(item.file, node.path) ~= nil
  end)
end

return {
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
          ['gitlab.*%.com'] = {
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
            actions = {
              explorer_open_all = function(picker)
                local Tree = require 'snacks.explorer.tree'
                local Explorer = require 'snacks.explorer.actions'

                local seen = {}
                local function expand(node)
                  node.open = true
                  if not node.dir then
                    return
                  end
                  -- Guard against symlink cycles by tracking real paths.
                  local real = vim.uv.fs_realpath(node.path) or node.path
                  if seen[real] then
                    return
                  end
                  seen[real] = true

                  Tree:expand(node)
                  for _, child in pairs(node.children) do
                    if child.dir then
                      expand(child)
                    end
                  end
                end

                expand(Tree:find(picker:cwd()))
                Explorer.update(picker, { refresh = true })
              end,
            },
            win = {
              list = {
                keys = {
                  ['gs'] = 'toggle_git_filter',
                  ['z'] = 'explorer_open_all',
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
          snacks_search.pwd('files', { hidden = true, ignored = true, exclude = EXCLUDE })
        end,
        desc = '[F]ind [A]ll (cwd)',
      },
      {
        '<F3>',
        function()
          snacks_search.pwd('grep', { exclude = EXCLUDE })
        end,
        desc = '[G]rep (cwd)',
      },
      {
        '<leader>ff',
        function()
          snacks_search.project('files', { hidden = true, ignore = true, exclude = EXCLUDE })
        end,
        desc = '[F]ind [F]iles',
      },
      {
        '<leader>Ff',
        function()
          snacks_search.pwd('files', { hidden = true, ignore = true, exclude = EXCLUDE })
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
    end,
  },
}
