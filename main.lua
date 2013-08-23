local anim = require("jam.anim")
local asset = require("jam.asset")
local entity = require("jam.entity")
local control = require("jam.control")
local render = require("jam.render")
local scene = require("jam.scene")
local system = require("jam.system")

control.bind = {
  states = {
    keys = {
      left = "left",
      right = "right",
    },
  }
}

love.load = function ()
  love.graphics.setMode(800,600, false)
  local img = asset.get("img/Player/p1_spritesheet.png")
  local w = img:getWidth()
  local h = img:getHeight()
  local e = entity.new()
  scene.addEntity(e)
  e.pos = {x=0,y=0}
  e.sprite = {
    image = img,
    quad = love.graphics.newQuad(67, 196, 66, 92, w, h),
  }
  e.anim = {
    t = 0,
    frame = 1,
    playing = "walk",
    anims = {
      stand = {
        { x = 67, y = 196, w = 66, h = 92 },
      },
      walk = {
        after = "stand",
        { x = 0, y = 0, w = 72, h = 97, t = .1 },
        { x = 73, y = 0, w = 72, h = 97, t = .1 },
        { x = 146, y = 0, w = 72, h = 97, t = .1 },
        { x = 0, y = 98, w = 72, h = 97, t = .1 },
        { x = 73, y = 98, w = 72, h = 97, t = .1 },
        { x = 146, y = 98, w = 72, h = 97, t = .1 },
        { x = 219, y = 0, w = 72, h = 97, t = .1 },
        { x = 292, y = 0, w = 72, h = 97, t = .1 },
        { x = 219, y = 98, w = 72, h = 97, t = .1 },
        { x = 365, y = 0, w = 72, h = 97, t = .1 },
        { x = 219, y = 98, w = 72, h = 97, t = .1 },
      },
    }
  }
  
  local e2 = entity.new()
  scene.addEntity(e2)
  e2.pos = {x=12,y=101}
  e2.sprite = {
    image = img,
    quad = love.graphics.newQuad(67, 196, 66, 92, w, h),
  }
  system.add(function (dt)
    for _,e in ipairs(scene.entities()) do
      if e.pos then
        e.pos.y = e.pos.y + dt*50
        if e.id == 1 then
          if control.states.right then
            e.pos.x = e.pos.x + dt*500
          end
          if control.states.left then
            e.pos.x = e.pos.x - dt*500
          end
        end
        if e.pos.y > 0 and e.pos.y > 500 then
          scene.deleteEntity(e)
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

