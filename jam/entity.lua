local scene = require("jam.scene")

local M = {}

local nextId = 1
local types = {}

--- Register a new type constructor
-- @param type (string) The name of the type
-- @parm f (function) The constructor to call (signature f(entity, args))
M.register = function (type, f)
  types[type] = f
end

---Construct an entity from a template
-- @param type (string) The name of the template
-- @param args (table) The template-specific arguments
-- @return (table) The constructed entity
M.build = function (type, args)
  local f = types[type]
  assert(f, "unknown entity type: " .. type)
  local e = M.new()
  e = f(e, args)
  return e
end

--- Create a new entity.
-- @return (table) The entity.
M.new = function ()
  local entity = {}
  entity.id = nextId
  nextId = nextId + 1
  entity.groups = {}
  
  return entity
end

return M

