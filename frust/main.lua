require "src/lib"
require "src/lib/logger"

require "src/camera"

require "src/collision"
require "src/drawing"

-- map stuff
require "src/map/map/Map"
require "src/map/chunk/Chunk"
require "src/map/tile/Tile"
require "src/map/astar_for_graph"
require "src/map/haastar"

-- units


-- factions


-- ui
-- TODO: PLACE DEBUG INFO HERE

-- user controller
require "src/user_controller"

CURRENT_MAP = Map.new(32, 32, 3, 3)

function love.load()
  for _,t in ipairs(Map.__tests) do t() end
  --Search Source, then the save directory
  love.filesystem.setIdentity(love.filesystem.getIdentity(), true)
end

function love.update(dt)
  if love.keyboard.isDown("escape") then love.event.quit() end
  Camera.moveTheScreenWhenMiddleMouseIsPressed()
  Camera.moveTheScreenWhenMouseIsAtTheEdgeOfTheScreen()

  UserController.handleInput()
end

function love.draw()
  --- draw all tiles
  for _, chunk in ipairs(CURRENT_MAP.chunks) do
    if Camera.is_in_viewport(chunk) then
      for _, tile in ipairs(chunk.tilesAsList) do
        draw(tile) -- using the drawable protocol
      end
    end
    Chunk.drawRectAroundMyBorderTiles(chunk)
  end
  for _, chunk in ipairs(CURRENT_MAP.chunks) do
    Chunk.drawRectAroundChunk(chunk)
    Chunk.drawTraversableNumbersOnTiles(chunk)
    Chunk.drawClearanceNumbersOnTiles(chunk)
  end

  -- hello world
  -- fps
  -- TODO: MOVE DEBUG INFO TO UI FUNCTION
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 0, 300, 20)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
  -- mouse position
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 20, 300, 20)
  love.graphics.setColor(255, 255, 255)
  local x, y = love.mouse.getPosition()
  love.graphics.print("x: " .. x .. " y: " .. y, 0, 20)
  -- camera position and zoom Camera.x Camera.y Camera.zoom
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 40, 300, 20)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Camera.x: " .. Camera.x .. " Camera.y: " .. Camera.y .. " Camera.zoom: " .. Camera.zoom, 0, 40)
  -- mouse after camera transformation
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 60, 300, 20)
  love.graphics.setColor(255, 255, 255)
  local xcam = Camera.getMouseXAfterCameraTransformation()
  local ycam = Camera.getMouseYAfterCameraTransformation()
  love.graphics.print("xcam: " .. xcam .. " ycam: " .. ycam, 0, 60)


  if UserController.path then
    for _, tile in ipairs(UserController.path) do
      love.graphics.setColor(255, 0, 0)
      love.graphics.rectangle(
        "fill",
        tile.x - Camera.x+tile.width/4,
        tile.y - Camera.y+tile.height/4,
        tile.width/2,
        tile.height/2
      )
      love.graphics.setColor(255, 255, 255)
    end
  end


end

function love.wheelmoved(x, y)
  -- TODO: MAKE ZOOMING WORK
  -- x and y represent the movement of the wheel in horizontal and vertical directions, respectively
  -- y > 0 indicates scrolling up, y < 0 indicates scrolling down

  -- Example: Increase or decrease a variable based on vertical wheel movement
  if y > 0 then
    -- Scroll up
    --Camera.zoom = Camera.zoom + 0.1
  elseif y < 0 then
    -- Scroll down
    --Camera.zoom = Camera.zoom - 0.1
  end
end
