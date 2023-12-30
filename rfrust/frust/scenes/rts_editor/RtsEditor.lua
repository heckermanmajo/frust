RtsEditor = {
  --- @type Map
  currently_loaded_map = nil,
  current_ui_mode = "select", -- f.e. place tile
  tile_to_place = "water",
  --- @type Tile
  currently_clicked_tile = nil,
}

RtsEditor.load = function()
  -- first create an empty map
  RtsEditor.currently_loaded_map = Map.new(
    32,
    10,
    4,
    4
  )
end

RtsEditor.cooldown = 0

local btn = Button.new(
  "test_button",
  300,
  300,
  100,
  100,
  "test",
  function()
    print("test")
  end
)

RtsEditor.update = function(dt)
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end
  Camera.moveTheScreenWhenMiddleMouseIsPressed()
  Camera.moveTheScreenWhenMouseIsAtTheEdgeOfTheScreen()

  if RtsEditor.current_ui_mode == "select" then
    if love.mouse.isDown(1) then
      local x = Camera.getMouseXAfterCameraTransformation()
      local y = Camera.getMouseYAfterCameraTransformation()
      local tile = RtsEditor.currently_loaded_map:get_tile_at_x_y_pixel(x, y)
      if tile ~= nil then
        RtsEditor.currently_clicked_tile = tile
      end
    end
  end

  if RtsEditor.current_ui_mode == "place_tile" then
    if love.mouse.isDown(1) then
      local x = Camera.getMouseXAfterCameraTransformation()
      local y = Camera.getMouseYAfterCameraTransformation()
      local tile = RtsEditor.currently_loaded_map:get_tile_at_x_y_pixel(x, y)
      if tile ~= nil then
        tile.tile_type = Tile.TileTypes.WATER
      end
    end
  end

  -- if f1 is pressed, save the map
  local DEFAULT_MAP_NAME = "./frust/saves/default.save.lua"
  if love.keyboard.isDown("f1") then
    if RtsEditor.cooldown <= 0 then
      RtsEditor.cooldown = 0.2
    else
      goto wait_for_cooldown
    end
    local map_name = DEFAULT_MAP_NAME
    RtsEditor.currently_loaded_map:save_to_file(map_name)
    :: wait_for_cooldown ::
  end


  -- if f2 is pressed, load the map
  if love.keyboard.isDown("f2") then
    if RtsEditor.cooldown <= 0 then
      RtsEditor.cooldown = 0.2
    else
      goto wait_for_cooldown
    end
    local map_name = DEFAULT_MAP_NAME
    RtsEditor.currently_loaded_map = Map.load_map_from_file(map_name)
    :: wait_for_cooldown ::
  end


  -- if f3 is pressed, change the ui mode to "place tile"
  if love.keyboard.isDown("f3") then
    if RtsEditor.cooldown <= 0 then
      RtsEditor.cooldown = 0.2
    else
      goto wait_for_cooldown
    end
    if RtsEditor.current_ui_mode == "place_tile" then
      RtsEditor.current_ui_mode = "select"
    else
      RtsEditor.current_ui_mode = "place_tile"
    end
    :: wait_for_cooldown ::
  end

  if RtsEditor.cooldown > 0 then
    RtsEditor.cooldown = RtsEditor.cooldown - dt
  end

  Button.update_all(dt)

end






RtsEditor.draw = function()
  -- draw the map
  -- draw the ui
  RtsEditor.currently_loaded_map:draw()

  -- draw an outline around the currently clicked tile
  if RtsEditor.currently_clicked_tile ~= nil then
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle(
      "line",
      (RtsEditor.currently_clicked_tile.x - Camera.x) * Camera.zoom,
      (RtsEditor.currently_clicked_tile.y - Camera.y) * Camera.zoom,
      RtsEditor.currently_loaded_map.size_of_tiles_in_pixels * Camera.zoom,
      RtsEditor.currently_loaded_map.size_of_tiles_in_pixels * Camera.zoom
    )
  end

  -- draw at the right side of the screen the current ui mode
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.rectangle("fill", love.graphics.getWidth() - 200, 0, 200, love.graphics.getHeight())
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("Current UI mode: " .. RtsEditor.current_ui_mode, love.graphics.getWidth() - 200, 0)

  Button.draw_all()

end