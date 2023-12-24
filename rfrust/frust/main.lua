
require "lib/utils"
require "lib/astar_for_chunks"
require "lib/astar_for_tiles"

require "protocol/ColliderProtocol"
require "protocol/DrawProtocol"

require "dynamic_state/Animation"
require "dynamic_state/Camera"

require "classes/map/Map"
require "classes/map/Chunk"
require "classes/map/Tile"

require "loaders/MapLoader"
require "loaders/ChunkLoader"
require "loaders/TileLoader"

require "scenes/rts_editor/UserController"
require "scenes/rts_editor/RtsEditor"

Scene = RtsEditor
-- todo: other scenes

function love.load()
  Scene.load()
end

function love.update(dt)
  Scene.update(dt)
end

function love.draw()
  Scene.draw()
end
