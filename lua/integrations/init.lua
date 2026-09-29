--- Terminal multiplexer facade.
---
--- Picks the first available adapter (zellij > tmux > wezterm > none) and
--- exposes a single environment-agnostic API. Callers never branch on
--- `$ZELLIJ`/`$TMUX` themselves.
---
--- Requiring this module has no side effects: adapter detection is resolved
--- lazily on first use and memoized. Adapter modules are only loaded when
--- needed.
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

---@param title string
function M.set_title(title)
  return adapter().set_title(title)
end

---@return table[]
function M.panes()
  return adapter().panes()
end

--- Find the best agent pane, preferring one on the editor's own tab.
---@return string|nil pane_id
---@return string|nil reason
function M.find_agent_pane()
  local a = adapter()
  if not a.capabilities.panes then
    return nil, 'Agent discovery is not supported in ' .. a.name
  end

  local agents = require 'integrations.agents'
  local panes = a.panes()
  local current = a.current_pane_id()

  local current_tab
  for _, pane in ipairs(panes) do
    if tostring(pane.id) == tostring(current) then
      current_tab = pane.tab_id
      break
    end
  end

  local same_tab, other_tab
  for _, pane in ipairs(panes) do
    if not pane.is_plugin and tostring(pane.id) ~= tostring(current) and agents.is_agent_command(pane.cmd) then
      if current_tab ~= nil and pane.tab_id == current_tab then
        same_tab = same_tab or pane.id
      else
        other_tab = other_tab or pane.id
      end
    end
  end

  local best = same_tab or other_tab
  if best then
    return best
  end
  return nil, 'No AI agent pane found'
end

--- Send text to the best agent pane and focus it.
---@param text string
function M.send_to_agent(text)
  if not text or text == '' then
    return
  end

  local pane, reason = M.find_agent_pane()
  if not pane then
    vim.notify(reason or 'No agent pane found', vim.log.levels.WARN, { title = 'Agent' })
    return
  end

  local a = adapter()
  a.send(pane, text)
  a.focus(pane)
end

return M
