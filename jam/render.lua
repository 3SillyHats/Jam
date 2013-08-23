local scene = require("jam.scene")

local M = {}

M.draw = function ()
  for _,e in ipairs(scene.entities()) do
    if e.sprite and e.pos then
      love.graphics.drawq(
        e.sprite.image,
        e.sprite.quad,
        e.pos.x,
        e.pos.y
      )
    end
  end
end

return M

