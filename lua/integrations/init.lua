--- Environment facade.
---
--- Picks the first available adapter (zellij > tmux > wezterm > none) and
--- exposes a small, environment-agnostic surface. Requiring this module has no
--- side effects: adapter detection is lazy and memoized, and adapter modules are
--- only loaded when needed.
local M = {}

local ADAPTERS = { 'integrations.zellij', 'integrations.tmux', 'integrations.wezterm' }

local active

local function adapter()
  if active then
    return active
  end

  for _, module in ipairs(ADAPTERS) do
    local candidate = require(module)
    if candidate.available() then
      active = candidate
      return active
    end
  end

  active = require 'integrations.none'
  return active
end

---@return string
function M.name()
  return adapter().name
end

---@return table
function M.capabilities()
  return adapter().capabilities
end

--- Set the pane/tab title where the environment supports it.
---@param title string
function M.set_title(title)
  return adapter().set_title(title)
end

return M
