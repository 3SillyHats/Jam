local scene = require("jam.scene")
local system = require("jam.system")

system.add(function (dt)
  for _,e in ipairs(scene.entities()) do
    if e.anim and e.sprite then
      e.anim.t = e.anim.t + dt
      
      -- Get current frame of animation
      local anim = e.anim.anims[e.anim.playing]
      local frame = anim[e.anim.frame]

      -- Advance the animation
      if frame.t and e.anim.t >= frame.t then
        e.anim.t = e.anim.t - frame.t
        e.anim.frame = (e.anim.frame % #anim) + 1
        
        -- Play after animation if given rather than loop
        if anim.after and e.anim.frame == 1 then
          e.anim.t = 0
          e.anim.playing = anim.after
          anim = e.anim.anims[e.anim.playing]
        end

        -- Update sprite quad
        local frame = anim[e.anim.frame]
        e.sprite.quad:setViewport(
          frame.x, frame.y, frame.w, frame.h
        )
      end
    end
  end
end)

