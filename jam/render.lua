local scene = require("jam.scene")

local M = {}

M.draw = function ()
  for _,ent in ipairs(scene.entities()) do
    if ent.position then
      love.graphics.rectangle("fill", ent.position.x, ent.position.y, 10, 10)
    end
  end
end

return M
