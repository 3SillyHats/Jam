local scene = require("jam.scene")

local M = {}

local nextId = 1
local templates = {}

--- Add a new template constructor
-- @param type (string) The name of the template
-- @parm f (function) The constructor to call (signature f(entity, args))
-- @see build
M.addTemplate = function (type, f)
  templates[type] = f
end

---Construct an entity from a template
-- @param type (string) The name of the template
-- @param args (table) The template-specific arguments
-- @return (table) The constructed entity
M.build = function (type, args)
  local template = templates[type]
  local e = M.new()
  if template ~= nil then
    template(e, args)
  else
    error("unknown entity template: " .. type)
  end
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

--- Update the entity manager.
-- @param dt (number) Time delta in seconds.
M.update = function (dt)
  
end

return M
