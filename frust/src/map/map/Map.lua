--- @class Map Class that represents a map.
--- We can have multiple maps for testing, loading, etc.
---
--- @field chunks Chunk[]
--- @field chunksOnXYNum Chunk[][]
--- @field chunkSizeInTiles number
--- @field tileSizeInPixels number
--- @field widthInChunks number
--- @field heightInChunks number
---
--- @field __className string static! the name of the class
--- @field __logfile file
Map = {
  __className = "Map",
  __logfile = nil,
  __tests = {}
}

---!debug:start
print("open map.log to see debug messages of Map class")
Map.__logfile = io.open("map.log", "w")
---!debug:end

--- Check if the given object is a Map.
--- @param object any
--- @return boolean
function Map.checkType(object)
  if object == nil then
    error("object must not be nil: Wanted to call Map.checkType(object) but object is nil")
  end
  assert(object.__className == "Map", "object must be a Map")
  assert(type(object) == "table", "object must be a table")
  assert(type(object.chunks) == "table", "object.chunks must be a table")
  assert(type(object.chunksOnXYNum) == "table", "object.chunksOnXYNum must be a table")
  assert(type(object.chunkSizeInTiles) == "number", "object.chunkSizeInTiles must be a number")
  assert(type(object.tileSizeInPixels) == "number", "object.tileSizeInPixels must be a number")
  assert(type(object.widthInChunks) == "number", "object.widthInChunks must be a number")
  assert(type(object.heightInChunks) == "number", "object.heightInChunks must be a number")
end

--- Create a new map.
--- @param chunkSizeInTiles number The size of a chunk in tiles.
--- @param tileSizeInPixels number The size of a tile in pixels.
--- @param widthInChunks number The width of the map in chunks.
--- @param heightInChunks number The height of the map in chunks.
---
--- Number of chunks in the map: widthInChunks * heightInChunks
--- Number of tiles in the map: widthInChunks * heightInChunks * chunkSizeInTiles * chunkSizeInTiles
--- Number of pixels in the map: widthInChunks * heightInChunks * chunkSizeInTiles * chunkSizeInTiles * tileSizeInPixels * tileSizeInPixels
--- @return Map
function Map.new(
  chunkSizeInTiles,
  tileSizeInPixels,
  widthInChunks,
  heightInChunks
)
  ---!debug:start
  positiveInteger(chunkSizeInTiles)
  positiveInteger(tileSizeInPixels)
  positiveInteger(widthInChunks)
  positiveInteger(heightInChunks)
  ---!debug:end

  local map = {
    chunks = {},
    chunksOnXYNum = {},
    chunkSizeInTiles = chunkSizeInTiles,
    tileSizeInPixels = tileSizeInPixels,
    widthInChunks = widthInChunks,
    heightInChunks = heightInChunks,
  }

  setmetatable(map, { __index = Map })

  -- create the chunks
  for x = 0, widthInChunks - 1 do
    map.chunksOnXYNum[x] = {}
    for y = 0, heightInChunks - 1 do
      local chunk = Chunk.new(x, y, map)
      Chunk.checkType(chunk)
      --print("created chunk " .. Chunk.repr(chunk))
      table.insert(map.chunks, chunk)
      map.chunksOnXYNum[x][y] = chunk
    end
  end

  ---!debug:start
  Map.checkType(map)
  Map.__logfile:write("created new map: " .. Map.repr(map) .. "\n")
  ---!debug:end
  return map
end

require "src/map/map/fn/repr"
require "src/map/map/fn/from_repr"
require "src/map/map/fn/astar_for_tiles"
require "src/map/map/fn/get_chunk_at_x_y_num"
require "src/map/map/fn/getPathFromTo"

--- Get the chunk at the given x and y coordinates.
--- The x and y coordinates are the real positions in pixels.
--- @param x number The x coordinate in pixels.
--- @param y number The y coordinate in pixels.
--- @return Chunk|nil
function Map:getChunkAtXY(x, y)
  local xNum = math.floor(x / (self.chunkSizeInTiles * self.tileSizeInPixels))
  local yNum = math.floor(y / (self.chunkSizeInTiles * self.tileSizeInPixels))
  return self:get_chunk_at_x_y_num(xNum, yNum)
end

--- Check if a chunk exists at the given x and y coordinates.
--- @param self Map
--- @param x number
--- @param y number
--- @return boolean
function Map.chunkExistsAtXY(self, x, y)
  local xNum = math.floor(x / (self.chunkSizeInTiles * self.tileSizeInPixels))
  local yNum = math.floor(y / (self.chunkSizeInTiles * self.tileSizeInPixels))
  return self.chunksOnXYNum[xNum] ~= nil and self.chunksOnXYNum[xNum][yNum] ~= nil
end

--- Get the tile at the given x and y coordinates.
--- @param x number
--- @param y number
--- @return Tile
function Map:getTileAtXY(x, y)
  local chunk = self:getChunkAtXY(x, y)
  if chunk == nil then return nil end
  return chunk:getTileAtXY(x, y)
end

--- Save the map to a file.
--- @param map Map
--- @param relative_file_name string
--- @return nil
function Map.save_map_to_file(map, relative_file_name)
  local file = io.open(relative_file_name, "w")
  file:write(Map.repr(map))
  file:close()
end

--- Get the width of the map in pixels.
--- @return number
function Map:getWidthInPixels()
  return self.widthInChunks * self.chunkSizeInTiles * self.tileSizeInPixels
end

--- Get the height of the map in pixels.
--- @return number
function Map:getHeightInPixels()
  return self.heightInChunks * self.chunkSizeInTiles * self.tileSizeInPixels
end

--- For pathfinding we need to know the border-tiles of the chunks.
---
function Map:get_border_pairs()
  -- Problem to solve: we dont want to have the same border twice.
  -- solution: we dont make it "chunk-wise", but based on the chunk number and size, we generate
  -- the borders our self and then just request the tiles from the chunks.
  -- @see Chunk:get_border_tiles(side)
end