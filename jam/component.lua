local M = {}

local components = {}

--- Register a new type of component
-- @param type (string) The name of the component type
-- @parm f (function) The constructor to call (signature f(table))
M.register = function (type, f)
  components[type] = f
end

--- Create a new component.
-- @return (table) The component.
M.new = function (type, t)
  print(type, t)
  assert(components[type], "unknown component type: " .. type)
  return components[type](t)
end

return M

