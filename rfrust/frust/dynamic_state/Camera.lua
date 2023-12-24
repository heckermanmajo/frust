Camera = {
  zoom = 1,
  x = 0,
  y = 0,
}

local padding = 100

function Camera.is_in_viewport(drawable)
  -- TODO: check collider...
  -- checkDrawable(drawable)
  return (
    drawable.x + drawable.width > Camera.x - padding
      and drawable.x < Camera.x + love.graphics.getWidth() / Camera.zoom + padding
      and drawable.y + drawable.height  > Camera.y - padding
      and drawable.y < Camera.y + love.graphics.getHeight() / Camera.zoom + padding
  )
end

--- Move the camera if the mouse is at the edge of the screen.
--- @return nil
--- @usage
--- function love.update(dt)
function Camera.moveTheScreenWhenMouseIsAtTheEdgeOfTheScreen()
  local x, y = love.mouse.getPosition()
  local speed = 10
  if x < 10 then
    Camera.x = Camera.x - speed
  end
  if x > love.graphics.getWidth() - 10 then
    Camera.x = Camera.x + speed
  end
  if y < 10 then
    Camera.y = Camera.y - speed
  end
  if y > love.graphics.getHeight() - 10 then
    Camera.y = Camera.y + speed
  end
end


local middleMouseWasPressedLastFrame = false
local lastFrameMouseX = 0
local lastFrameMouseY = 0
local speed = 10

--- Move the camera if the middle mouse is pressed.
--- Uses local module-variables to store the state of the mouse.
--- @return nil
function Camera.moveTheScreenWhenMiddleMouseIsPressed()
  local x, y = love.mouse.getPosition()
  if love.mouse.isDown(3) then
    if middleMouseWasPressedLastFrame then
      Camera.x = Camera.x + (x - lastFrameMouseX) * speed
      Camera.y = Camera.y + (y - lastFrameMouseY) * speed
    end
    middleMouseWasPressedLastFrame = true
  else
    middleMouseWasPressedLastFrame = false
  end
  lastFrameMouseX = x
  lastFrameMouseY = y
end


function Camera.getMouseXAfterCameraTransformation()
  return love.mouse.getX() / Camera.zoom + Camera.x
end

function Camera.getMouseYAfterCameraTransformation()
  return love.mouse.getY() / Camera.zoom + Camera.y
end