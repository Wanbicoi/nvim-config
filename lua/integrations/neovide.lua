--- Neovide GUI integration.
---
--- Kept separate from options.lua so GUI-specific settings (and the clipboard
--- paste mappings Neovide needs) don't leak into the portable editor config.
local M = {}

local function paste_into_terminal()
  vim.api.nvim_chan_send(vim.b.terminal_job_id, vim.fn.getreg '+')
end

local function set_paste_keys(key)
  vim.keymap.set('n', key, '"+P')
  vim.keymap.set('v', key, '"+P')
  vim.keymap.set('c', key, '<C-R>+')
  vim.keymap.set('i', key, '<ESC>"+pa')
  vim.keymap.set('t', key, paste_into_terminal, { desc = 'Paste clipboard into terminal' })
end

--- Apply Neovide settings once the GUI attaches.
function M.setup()
  vim.api.nvim_create_autocmd('UIEnter', {
    once = true,
    group = vim.api.nvim_create_augroup('cfg-neovide', { clear = true }),
    desc = 'Apply Neovide GUI settings',
    callback = function()
      if not vim.g.neovide then
        return
      end

      vim.o.guifont = 'JetBrainsMono Nerd Font:h10'
      vim.g.neovide_cursor_vfx_mode = 'pixiedust'
      vim.g.neovide_floating_shadow = false
      vim.g.neovide_floating_blur_amount_x = 2
      vim.g.neovide_floating_blur_amount_y = 2
      vim.g.neovide_remember_window_size = true
      vim.g.neovide_scroll_animation_length = 0.2
      vim.g.neovide_text_contrast = 0.6
      vim.g.neovide_text_gamma = 1
      vim.g.neovide_cursor_animation_length = 0.02
      vim.g.neovide_title_background_color = '#faf4ed'
      vim.g.neovide_title_text_color = 'black'
      vim.g.neovide_progress_bar_enabled = true
      vim.g.neovide_progress_bar_height = 5.0
      vim.g.neovide_progress_bar_animation_speed = 200.0
      vim.g.neovide_progress_bar_hide_delay = 0.2

      set_paste_keys '<c-s-v>'
      set_paste_keys '<s-insert>'
    end,
  })
end

return M
