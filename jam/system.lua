local M = {}

local systems = {}

--- Adds a system to the list of systems
-- @param system (function) The system to add.
M.add = function (system)
  table.insert(systems, system)
end

--- Updates the system, called each tick
-- @param dt The time delta in seconds.
M.update = function (dt)
  for _,s in ipairs(systems) do
    s(dt)
  end
end

return M
