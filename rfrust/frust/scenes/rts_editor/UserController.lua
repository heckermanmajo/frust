--- @class UserControllerMode
--- @field value string
UserControllerMode = {
  PLACE_OBSTACLE = "PLACE_OBSTACLE",
}

--- @class UserController
--- @field currentMap Map
--- @field mode UserControllerMode

UserController = {
  currentMap = nil,
  mode = UserControllerMode.PLACE_OBSTACLE,
  path = nil,
}

function UserController.handleInput()

  if UserController.mode == UserControllerMode.PLACE_OBSTACLE then
    if love.mouse.isDown(1) then
      local x = Camera.getMouseXAfterCameraTransformation()
      local y = Camera.getMouseYAfterCameraTransformation()
      if x < 0 or y < 0 then goto continue end
      if CURRENT_MAP:chunkExistsAtXY(x, y) == false then goto continue end
      local tile = CURRENT_MAP:getTileAtXY(x, y)
      if tile then
        tile.type = TileType.WATER
      end
      ::continue::
    end

    if love.mouse.isDown(2) then
      local x = Camera.getMouseXAfterCameraTransformation()
      local y = Camera.getMouseYAfterCameraTransformation()
      if x < 0 or y < 0 then goto continue end
      if CURRENT_MAP:chunkExistsAtXY(x, y) == false then goto continue end
      local tile = CURRENT_MAP:getTileAtXY(x, y)
      if tile then
        tile.type = TileType.STONE
      end
      ::continue::
    end


  end

  -- save on S
  if love.keyboard.isDown("s") then
    CURRENT_MAP:save_map_to_file("myMap.save")
  end

  if love.keyboard.isDown("l") then
    CURRENT_MAP = loadfile("myMap.save")()
  end

  if love.keyboard.isDown("p") then
    UserController.path = CURRENT_MAP:getPathFromTo(10,10,640, 640)
    if UserController.path == nil then
      print("no path found")
      return
    else
      for _, tile in ipairs(UserController.path) do
        print(tile.x, tile.y)
      end
    end
  end

end