return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  opts = {
    provider = 'gemini',
    cursor_applying_provider = 'gemini',
    windows = {
      width = 40,
      ask = {
        start_insert = false,
      },
      sidebar = {
        switch_windows = nil,
        reverse_switch_windows = nil,
      },
    },
    gemini = {
      -- model = 'gemini-2.5-pro-preview-03-25',
    },
    behaviour = {
      enable_cursor_planning_mode = true,
      auto_suggestions = false, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = true,
      support_paste_from_clipboard = false,
      minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
      enable_token_counting = false, -- Whether to enable token counting. Default to true.
      enable_claude_text_editor_tool_mode = false, -- Whether to enable Claude Text Editor Tool Mode.
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- build = "make",
  build = 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false', -- for windows
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
  },
}
