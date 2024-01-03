--- @class UnitSelector The unit selector manages the selection of units by the player.
--- @field public currently_selected_units Soldier[] The currently selected units.
---
---
--- The player can select also enemy units.
--- If different kinds are selected there are less details shown.
---
---
---
 -- todo: we need icons for the units
UnitSelector = {
  currently_selected_units = {}
}

local left_mouse_button_was_pressed = false
local start_x = 0
local start_y = 0
local current_x = 0
local current_y = 0

function UnitSelector.update()

  if love.mouse.isDown(1) then

    if left_mouse_button_was_pressed == false then
      left_mouse_button_was_pressed = true
      UnitSelector.currently_selected_units = {}
      start_x = Camera.getMouseXAfterCameraTransformation()
      start_y = Camera.getMouseYAfterCameraTransformation()
    end

    local x = Camera.getMouseXAfterCameraTransformation()
    local y = Camera.getMouseYAfterCameraTransformation()

    current_x = x
    current_y = y

    -- draw rect
    love.graphics.setColor(0, 0, 0, 0.5)

    local x1 = math.min(start_x, current_x)
    local y1 = math.min(start_y, current_y)
    local x2 = math.max(start_x, current_x)
    local y2 = math.max(start_y, current_y)

    love.graphics.rectangle(
      "line",
      x1 - Camera.x,
      y1 - Camera.y,
      x2 - x1 - Camera.x,
      y2 - y1 - Camera.y
    )

  else

    if left_mouse_button_was_pressed == true then
      left_mouse_button_was_pressed = false
      UnitSelector.currently_selected_units = {}
      -- get units in the rect

      local x1 = math.min(start_x, current_x)
      local y1 = math.min(start_y, current_y)
      local x2 = math.max(start_x, current_x)
      local y2 = math.max(start_y, current_y)

      -- todo: get rect

    end

    left_mouse_button_was_pressed = false

  end

end