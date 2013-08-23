local M = {}

local raw = {
  key = {
    down = {},
    pressed = {},
    released = {},
  },
  joystick = {},
  mouse = {
    down = {},
    pressed = {},
    released = {},
  },
}

M.bind = {}
M.actions = {}
M.states = {}
M.ranges = {}

--[[
control.bind = {
  "actions" = {
    "keys" = {
      "space" = "jump",
      "ctrl" = {"release" = "slide"},
    }
  },
  "states" = {
    "keys" = {
      "ctrl" = "crouch",
    }
  }
}

if input.actions.jump then
end
--]]

--- The function to call when a joystick button is pressed
-- @param joystick (number) The id of the joystick on which the button was pressed
-- @param button (number) The id of the button that was pressed
M.joystickPressed = function(joystick, button)
  if raw.joystick[joystick] then
    raw.joystick[joystick].down[button] = true
    raw.joystick[joystick].pressed[button] = true
  end
end

--- The function to call when a joystick button is released
-- @param joystick (number) The id of the joystick on which the button was released
-- @param button (number) The id of the button that was released
M.joystickReleased = function(joystick, button)
  if raw.joystick[joystick] then
    raw.joystick[joystick].down[button] = nil
    raw.joystick[joystick].released[button] = true
  end
end

--- The function to call when a key is pressed
-- @param key (string) The key pressed
M.keyPressed = function (key)
  if key == "escape" then
    love.event.push("quit")
    love.event.push("q")
  end

  raw.key.down[key] = true
  raw.key.pressed[key] = true
end

--- The function to call when a key is released
-- @param key (string) The key released
M.keyReleased = function (key)
  raw.key.down[key] = nil
  raw.key.released[key] = true
end

--- The function to call when a mouse button is pressed
-- @param x (number) The x position of the mouse when the button was pressed
-- @param y (number) The y position of the mouse when the button was pressed
-- @param button (string) The button pressed
M.mousePressed = function (x, y, button)
  raw.mouse.down[button] = true
  raw.mouse.pressed[button] = true
end

--- The function to call when a mouse button is released
-- @param x (number) The x position of the mouse when the button was released
-- @param y (number) The y position of the mouse when the button was released
-- @param button (string) The button released
M.mouseReleased = function (x, y, button)
  raw.mouse.down[button] = nil
  raw.mouse.released[button] = true
end


--- Map raw inputs to logical inputs
-- @param dt (number) Time delta in seconds.
M.update = function (dt)
  for i=1,love.joystick.getNumJoysticks() do
    if not raw.joystick[i] then
      raw.joystick[i] = {
        down = {},
        pressed = {},
        released = {},
        axis = {},
      }
    end
    for i=1,love.joystick.getNumAxes(1) do
      raw.joystick.axis[i] = love.joystick.getAxis(1, i)
    end
  end
 
  M.actions = {}
  
  if M.bind.actions then
    if M.bind.actions.keys then
      for key,action in pairs(M.bind.actions.keys) do
        if type(action) == "string" then
          M.actions[action] = raw.key.pressed[key]
        else
          if action.press then
            M.actions[action.press] = raw.key.pressed[key]
          end
          if action.release then
            M.actions[action.release] = raw.key.released[key]
          end
        end
      end
    end
    
    if M.bind.actions.mouse then
      for button,action in pairs(M.bind.actions.mouse) do
        if type(action) == "string" then
          M.actions[action] = raw.mouse.pressed[button]
        else
          if action.press then
            M.actions[action.press] = raw.mouse.pressed[button]
          end
          if action.release then
            M.actions[action.release] = raw.mouse.released[button]
          end
        end
      end
    end
    
    if M.bind.actions.joystick then
      for i,bind in ipairs(M.bind.actions.joystick) do
        if raw.joystick[i] then
          for button,action in pairs(bind) do
            if type(action) == "string" then
              M.actions[action] = raw.joystick[i].pressed[button]
            else
              if action.press then
                M.actions[action.press] = raw.joystick[i].pressed[button]
              end
              if action.release then
                M.actions[action.release] = raw.joystick[i].released[button]
              end
            end
          end
        end
      end
    end
  end
  
  if M.bind.states then
    if M.bind.states.keys then
      for key,action in pairs(M.bind.states.keys) do
         M.states[action] = raw.key.down[key]
      end
    end
    
    if M.bind.states.mouse then
      for button,action in pairs(M.bind.states.mouse) do
        M.states[action] = raw.mouse.down[button]
      end
    end
    
    if M.bind.states.joystick then
      for i,bind in ipairs(M.bind.states.joystick) do
        if raw.joystick[i] then
          for button,action in pairs(bind) do
            M.states[action] = raw.joystick[i].down[button]
          end
        end
      end
    end
  end
  
  if M.bind.ranges then
    if M.bind.ranges.joystick then
      for i,bind in ipairs(M.bind.ranges.joystick) do
        if raw.joystick[i] then
          for axis,action in pairs(bind) do
            M.ranges[action] = raw.joystick[i].axis[axis]
          end
        end
      end
    end
  end
  
  raw.key.pressed = {}
  raw.key.released = {}
  raw.mouse.pressed = {}
  raw.mouse.released = {}
  raw.joystick.pressed = {}
  raw.joystick.released = {}
end

return M
