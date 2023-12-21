--- @class Drawable
--- @field public x number
--- @field public y number
--- @field public width number
--- @field public height number
--- @field public getImage function
--- @field public animationCounter number|nil if nil the animationCounter is not updated
--- @field public zoom number|nil if nil the zoom is 1
--- @field public rotation number|nil if nil the rotation is 0

function checkDrawable(object)
  assert(type(object) == "table", "object must be a table")
  assert(type(object.x) == "number", "object.x must be a number")
  assert(type(object.y) == "number", "object.y must be a number")
  assert(type(object.width) == "number", "object.width must be a number")
  assert(type(object.height) == "number", "object.height must be a number")
  assert(type(object.get_image) == "function", "object.getImage must be a function")
  if object.animationCounter ~= nil then
    assert(type(object.animationCounter) == "number", "object.animationCounter must be a number")
  end
  if object.zoom ~= nil then
    assert(type(object.zoom) == "number", "object.zoom must be a number")
  end
  if object.rotation ~= nil then
    assert(type(object.rotation) == "number", "object.rotation must be a number")
  end
end

function progressAnimation() end
--- Draws a drawable object.
--- @param drawableObject Drawable
function draw(drawableObject)
  ---!debug:start
  checkDrawable(drawableObject)
  ---!debug:end
  --if Camera.is_in_viewport(drawableObject) == false then return end
  local image = drawableObject:get_image()
  local x = drawableObject.x
  local y = drawableObject.y
  local width = drawableObject.width
  local height = drawableObject.height
  local zoom = drawableObject.zoom or Camera.zoom
  local rotation = drawableObject.rotation or 0
  love.graphics.draw(
    image,
    (x - Camera.x + width / 2 ) * zoom,
    (y - Camera.y + height / 2) * zoom,
    rotation,
    zoom,
    zoom,
    width / 2,
    height / 2
  )
end