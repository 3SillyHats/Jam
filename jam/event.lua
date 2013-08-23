local M = {}

local handlers = {}

--- Notify all subcribers of an event.
M.notify = function(event, data)
  if not handlers[event] then return end
  for _,h in ipairs(handlers[event]) do
    h(data)
  end
end

--- Subscribe a callback to an event.
M.subscribe = function(event, handler)
  if not handlers[event] then
    handlers[event] = {}
  end
  table.insert(handlers[event], handler)
end

return M
