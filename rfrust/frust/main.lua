--------------------------------------------------------------------------------
--- Prints a statement if in debug mode.
--- All Debug prints are removed by the preprocessor in release mode.
--- @param log string
--------------------------------------------------------------------------------
DEBUGLOG = function(log)
  print(log)
end

local VERSION = "0.0"

require "lib/utils"

require "protocol/ColliderProtocol"
require "protocol/DrawProtocol"

require "dynamic_state/Animation"
require "dynamic_state/Camera"

require "classes/map/Map"
require "classes/map/Chunk"
require "classes/map/ChunkAstar"
require "classes/map/Tile"
require "classes/map/TileAstar"

require "ui/Button"

require "classes/mob/Soldier"

require "classes/faction/Faction"

require "scenes/rts_editor/UserController"
require "scenes/rts_editor/RtsEditor"
require "scenes/rts_battle/RtsBattle"


---!debug:start
require "classes/map/MapTests"
---!debug:end

-- love list dir get all saves
local dir = "saves"
local files = love.filesystem.getDirectoryItems( dir )
for k, file in ipairs(files) do
  print( k, file )
end

-- check if the cmd argument is "battle"
-- if it is, then load the battle scene
-- if it is not, then load the editor scene
if arg[2] == "battle" then
  -- set title
  love.window.setTitle("Frust " .. VERSION .. " - Battle")
  Scene = RtsBattle
else
  Scene = RtsEditor
  -- set title
  love.window.setTitle("Frust " .. VERSION .. " - Editor")
end

function love.load()
  Scene.load()
end

function love.update(dt)
  Scene.update(dt)
end

function love.draw()
  Scene.draw()

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
  -- debug info version and scene
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 80, 300, 20)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Version: " .. VERSION .. " Scene: " .. Scene.name, 0, 80)


end

function love.wheelmoved(x, y)
  -- TODO: MAKE ZOOMING WORK
  -- x and y represent the movement of the wheel in horizontal and vertical directions, respectively
  -- y > 0 indicates scrolling up, y < 0 indicates scrolling down

  -- Example: Increase or decrease a variable based on vertical wheel movement
  if y > 0 then
    -- Scroll up
    Camera.zoom = Camera.zoom + 0.1
    -- increase the camera zoom
    --love.graphics.scale(1.1, 1.1)
  elseif y < 0 then
    -- Scroll down
    Camera.zoom = Camera.zoom - 0.1
    -- decrease the camera zoom
    --love.graphics.scale(0.9, 0.9)
  end
end
