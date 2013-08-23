local entity = require("jam.entity")
local control = require("jam.control")
local render = require("jam.render")
local scene = require("jam.scene")
local system = require("jam.system")

control.bind = {
  states = {
    mouse = {
      l = "left",
      r = "right",
    },
  }
}

love.load = function ()
  love.graphics.setMode(800,600, false)
  local e = entity.new()
  scene.addEntity(e)
  e.position = {x=0,y=0}
  local e2 = entity.new()
  scene.addEntity(e2)
  e2.position = {x=12,y=101}
  system.add(function (dt)
    for _,ent in ipairs(scene.entities()) do
      if ent.position then
        ent.position.y = ent.position.y + dt*50
        if ent.id == 1 then
          if control.states.right then
            ent.position.x = ent.position.x + dt*500
          end
          if control.states.left then
            ent.position.x = ent.position.x - dt*500
          end
        end
        if ent.position.y > 0 and ent.position.y > 500 then
          scene.deleteEntity(ent)
        end
      end
    end
  end)
end

love.focus = function (f)
end

love.quit = function ()
end

love.update = function (dt)
  control.update(dt)
--  event.update(dt)
  system.update(dt)
  scene.update(dt)
end

love.draw = function ()
  render.draw()  
end

love.keypressed = control.keyPressed
love.keyreleased = control.keyReleased
love.mousepressed = control.mousePressed
love.mousereleased = control.mouseReleased
love.joystickpressed = control.joystickPressed
love.joystickreleased = control.joystickReleased

