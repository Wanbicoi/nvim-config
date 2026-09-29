--- Registry of coding-agent executables, shared by pane detection and autocmds.
local M = {}

--- Executables we treat as coding agents.
M.patterns = { 'claude', 'codex', 'agy', 'opencode', 'pi' }

--- True when a command line starts with a known agent executable.
--- Matches only the executable name so paths/arguments don't false-positive.
---@param cmd string|nil
---@return boolean
function M.is_agent_command(cmd)
  if type(cmd) ~= 'string' or cmd == '' then
    return false
  end

  local exe = cmd:match '^%s*(%S+)' or ''
  exe = exe:match '[^/]+$' or exe -- strip any directory part
  exe = exe:lower()

  for _, pat in ipairs(M.patterns) do
    if exe == pat then
      return true
    end
  end
  return false
end

--- True when a buffer name or pane title mentions a known agent.
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
