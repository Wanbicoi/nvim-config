return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      current_line_blame = true,
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- gitsigns annotates every `Gitsigns.NavOpts` field as required in its
        -- public `nav_hunk` signature, but they are optional at runtime (the
        -- plugin itself uses `Partial<Gitsigns.NavOpts>`). Suppress the false
        -- positive here and reuse the table for both directions.
        ---@diagnostic disable-next-line: missing-fields
        local nav_opts = { target = 'all' }

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk('next', nav_opts)
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk('prev', nav_opts)
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions (visual mode)
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })

        -- Actions (normal mode)
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        -- stage_hunk toggles: on an unstaged hunk it stages, on a staged sign it
        -- unstages (gitsigns deprecated undo_stage_hunk in favour of this).
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', function()
          gitsigns.diffthis '~'
        end, { desc = 'git [d]iff against index' })
        map('n', '<leader>hf', gitsigns.refresh, { desc = 'git re[f]resh' })
      end,
    },
  },
}
