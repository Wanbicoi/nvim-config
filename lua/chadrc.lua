-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "default-dark",
}
M.nvdash = { load_on_startup = false }
M.term = {
  float = {
    width = 0.8,
    height = 0.8,
    col = 0.1,
    row = 0.05
  },
  winopts = { scl = 'no' }
}

return M
