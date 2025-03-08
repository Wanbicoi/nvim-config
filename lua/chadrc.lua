-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "nano-light",
}
M.nvdash = { load_on_startup = false }
M.term = {
  float = {
    width = 0.8,
    height = 0.8,
    col = 0.1,
    row = 0.05
  },
  sizes = { sp = 0.3, vsp = 0.4 },
  winopts = { scl = 'no' }
}
M.ui = {
  cmp = {
    style = "atom_colored", -- default/flat_light/flat_dark/atom/atom_colored
  },
  statusline = {
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor", "codecompanion" },
    modules = {
      codecompanion = "",
    }
  }
}

return M
