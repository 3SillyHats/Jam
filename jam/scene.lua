local M = {}

local stack = {}
local popDepth = 0

--- Push a new scene onto the top of the stack.
M.push = function ()
  table.insert(stack, {
    entitiesById = {},
    entitiesByTag = {},
    entitiesByGroup = {},
    entityList = {},
    deleteQueue = {},
    addQueue = {},
  })
end

--- Pop scene(s) from the top of the stack.
-- @param num (number) How many scenes to pop (defaults to 1).
M.pop = function (num)
  num = num or 1
  popDepth = math.max(popDepth, num)
  assert(popDepth < #stack, "cannot pop initial scene")
end

--- How many scenes are in the stack.
-- @return (number) The number of scenes.
M.depth = function ()
  return #stack
end

--- Get a list of all active entities.
-- @param scene (number) The scene depth to get the entity from (defaults to current scene).
-- @return (table) The list of entities.
M.entities = function (scene)
  scene = scene or #stack
  return stack[scene].entityList
end

--- Get an entity by either its id or tag.
-- @param id The id (number) or tag (string) of an entity.
-- @param scene (number) The scene depth to get the entity from (defaults to current scene).
-- @return (table) The entity.
M.getEntity = function (id, scene)
  scene = scene or #stack
  if type(id) == "number" then
    return stack[scene].entitiesById[id]
  elseif type(id) == "string" then
    return stack[scene].entitiesByTag[id]
  else
    return nil
  end
end

--- Get the list of entities in a group.
-- @param name (string) The group.
-- @param scene (number) The scene depth to get the entity from (defaults to current scene).
-- @return (table) The list of entities.
M.getGroup = function (name, scene)
  scene = scene or #stack
  if stack[scene].entitiesByGroup[name] then
    return stack[scene].entitiesByGroup[name]
  end
  return {}
end

--- Add an entity.
-- @param entity (table) The entity.
-- @param scene (number) The scene depth to get the entity from (defaults to current scene).
M.addEntity = function (entity, scene)
  scene = scene or #stack
  table.insert(stack[scene].addQueue, entity)
end

--- Delete an entity.
-- @param entity (table) The entity.
-- @param scene (number) The scene depth to get the entity from (defaults to current scene).
M.deleteEntity = function (entity, scene)
  scene = scene or #stack
  table.insert(stack[scene].deleteQueue, entity)
end

--- Update all of the scenes.
-- @param dt (number) Frame time delta in seconds.
M.update = function (dt)
  while popDepth > 0 do
    table.remove(stack)
    popDepth = popDepth - 1
  end
  
  for _,scene in ipairs(stack) do
    -- Add queued entities
    for _,entity in ipairs(scene.addQueue) do
      -- Add to list
      table.insert(scene.entityList, entity)
      
      -- Add id
      scene.entitiesById[entity.id] = entity
      
      -- Add tag
      if entity.tag then
        scene.entitiesByTag[entity.tag] = entity
      end
      
      -- Add groups
      for _,group in ipairs(entity.groups) do
        if scene.entitiesByGroup[group] == nil then
          scene.entitiesByGroup[group] = { entity }
        else
          table.insert(scene.entitiesByGroup[group], entity)
        end
      end
    end
    
    -- Delete queued entities
    for _,entity in ipairs(scene.deleteQueue) do
      -- Remove from list
      for i,e in ipairs(scene.entityList) do
        if e == entity then
          table.remove(scene.entityList,i)
          break
        end
      end
      
      -- Remove id
      scene.entitiesById[entity.id] = nil
      
      -- Remove tag
      for t,e in pairs(scene.entitiesByTag) do
        if e == entity then
          scene.entitiesByTag[t] = nil
          break
        end
      end
      
      -- Remove groups
      for _,group in pairs(scene.entitiesByGroup) do
        for i,e in ipairs(group) do
          if e == entity then
            table.remove(group, i)
            break
          end
        end
      end
    end

    -- Clear queues
    scene.deleteQueue = {}
    scene.addQueue = {}
  end
end

-- Initial scene
M.push()

return M
