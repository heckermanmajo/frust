--- @class Button Simple button
--- @field x number The x position in absolute pixels.
--- @field y number The y position in absolute pixels.
--- @field width number The width in pixels.
--- @field height number The height in pixels.
--- @field text string The text to display on the button.
--- @field onclick function The function to call when the button is clicked.
--- @field is_hovered boolean Whether the mouse is hovering over the button.
--- @field cool_down number The cool down time in seconds.
--- @field label string The label of the button.
---
--- @field instances table<string, Button> ::STATIC:: A table of all instances of Button.
--- @field mouse_is_consumed boolean ::STATIC:: Whether the mouse is consumed by a button, this allows other control elements to ignore the mouse if it is over a button.
Button = {}
Button.__index = Button
Button.instances = {}
Button.mouse_is_consumed = false

----------------------------------------------------------------------------
--- Creates a new Button.
---
--- @param label string The label of the button.
--- @param x number The x position in absolute pixels.
--- @param y number The y position in absolute pixels.
--- @param width number The width in pixels.
--- @param height number The height in pixels.
--- @param text string The text to display on the button.
--- @param onclick function The function to call when the button is clicked.
--- @return Button The Button.
----------------------------------------------------------------------------
function Button.new(label, x, y, width, height, text, onclick)
  local button = setmetatable({}, Button)
  button.x = x
  button.y = y
  button.width = width
  button.height = height
  button.text = text
  button.is_hovered = false
  button.onclick = onclick

  button.cool_down = 0.2

  Button.instances[label] = button

  return button
end

----------------------------------------------------------------------------
--- Draws the Button.
---
--- @return nil
----------------------------------------------------------------------------
function Button:draw()
  if self.is_hovered then
    love.graphics.setColor(1, 0, 1)
  else
    love.graphics.setColor(0, 0, 0)
  end
  -- todo: text centering
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

  love.graphics.setColor(0.6, 0.3, 0.3)
  love.graphics.print(self.text, self.x, self.y)

  love.graphics.setColor(1, 1, 1)
end

----------------------------------------------------------------------------
--- Updates the Button.
---
--- @return nil
----------------------------------------------------------------------------
function Button:update(dt)

  local x, y = love.mouse.getPosition()

  if (
    x >= self.x and
      x <= self.x + self.width and
      y >= self.y and
      y <= self.y + self.height
  ) then
    self.is_hovered = true
    -- consume mouse -> other can elements ignore it
    Button.mouse_is_consumed = true
  else
    self.is_hovered = false
  end

  if self.is_hovered and love.mouse.isDown(1) then
    if self.cool_down <= 0 then
      self.cool_down = 0.2
      self.onclick()
    else
      self.cool_down = self.cool_down - dt
    end
  end

  if self.cool_down > 0 then
    self.cool_down = self.cool_down - dt
  end

end

----------------------------------------------------------------------------
--- Deletes the Button.
--- @return nil
----------------------------------------------------------------------------
function Button:delete()
  Button.instances[self.label] = nil
end


----------------------------------------------------------------------------
--- Updates all Buttons.
---
--- @param dt number The delta time.
--- @return nil
----------------------------------------------------------------------------
function Button.update_all(dt)
  Button.mouse_is_consumed = false
  for _, button in pairs(Button.instances) do
    button:update(dt)
  end
end

----------------------------------------------------------------------------
--- Draws all Buttons.
---
--- @return nil
----------------------------------------------------------------------------
function Button.draw_all()
  for _, button in pairs(Button.instances) do
    button:draw()
  end
end