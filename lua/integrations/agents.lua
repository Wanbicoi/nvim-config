--- Registry of coding-agent executables.
local M = {}

--- Executables we treat as coding agents.
M.patterns = { 'claude', 'codex', 'agy', 'opencode', 'pi' }

--- True when a buffer name or terminal title mentions a known agent.
---@param text string|nil
---@return boolean
function M.is_agent_text(text)
  if type(text) ~= 'string' or text == '' then
    return false
  end
  local lower = text:lower()
  for _, pat in ipairs(M.patterns) do
    if lower:find(pat, 1, true) then
      return true
    end
  end
  return false
end

return M
