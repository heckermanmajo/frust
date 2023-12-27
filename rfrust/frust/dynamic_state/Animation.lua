------------------------------------------------------------
--- @class Animation
--- @field frames table<love.Quad>
--- @field speed number
--- @field timer number
--- @field currentFrame number
------------------------------------------------------------
Animation = {}
Animation.__index = Animation

------------------------------------------------------------
--- Create a new animation
---
--- @param frames table<love.Quad>
--- @param speed number
---
--- @return Animation
------------------------------------------------------------
function Animation.new(frames, speed)
  local self = setmetatable({}, Animation)
  self.frames = frames or {}
  self.speed = speed or 0.1
  self.timer = 0
  self.currentFrame = 1
  return self
end

-----------------------------------------------------------------
--- Update the animation.
---
--- @param dt number
---
--- @return nil
-----------------------------------------------------------------
function Animation:update(dt)
  self.timer = self.timer + dt
  if self.timer > self.speed then
    self.timer = self.timer - self.speed
    self.currentFrame = self.currentFrame % #self.frames + 1
  end
end

-----------------------------------------------------------------
--- Get the current frame of the animation.
--- Used to draw the animation.
---
--- @return love.Quad
-----------------------------------------------------------------
function Animation:getCurrentFrame()
  return self.frames[self.currentFrame]
end





-- EXAMPLE
if false then
  love.graphics.setBackgroundColor(255, 255, 255)

  local image = love.graphics.newImage("path/to/your/image.png")

  local frames = {
    love.graphics.newQuad(0, 0, 32, 32, image:getDimensions()),
    love.graphics.newQuad(32, 0, 32, 32, image:getDimensions()),
    -- Add more frames as needed
  }

  animation = Animation.new(frames, 0.1)
end