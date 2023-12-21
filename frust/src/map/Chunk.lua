--- @class Chunk A chunk of the map. Used to make rendering and collision detection efficient.
--- @field public x number
--- @field public y number
--- @field public xNum number
--- @field public yNum number
--- @field public width number
--- @field public height number
--- @field public tilesAsMap Tile[][]
--- @field public tilesAsList Tile[]
--- @field public drawablesInMe[] A list of all drawables that are in this chunk.
--- @field public map Map The parent map. A chunk always needs a map.
---
--- @field public __className string static! the name of the class
--- @field private __logfile file

Chunk = {
  __className = "Chunk",
  __protocols = { "Collider" },
  __logfile = nil,
}

---!debug:start
print("open chunk.log to see debug messages of Chunk class")
Chunk.__logfile = io.open("chunk.log", "w")
---!debug:end

--- Check if a table implements the Chunk protocol.
--- It crashes if the table does not implement the protocol.
--- @param object table
--- @return nil
function Chunk.checkType(object)
  assert(type(object) == "table", "object must be a table")
  assert(type(object.x) == "number", "object.x must be a number")
  assert(type(object.y) == "number", "object.y must be a number")
  assert(type(object.xNum) == "number", "object.xNum must be a number")
  assert(type(object.yNum) == "number", "object.yNum must be a number")
  assert(type(object.width) == "number", "object.width must be a number")
  assert(type(object.height) == "number", "object.height must be a number")
  assert(type(object.tilesAsMap) == "table", "object.tilesAsMap must be a table")
  assert(type(object.tilesAsList) == "table", "object.tilesAsList must be a table")
end

--- Creates a string representation of a Chunk that is valid Lua code.
--- @param chunk Chunk
--- @return string
function Chunk.repr(chunk)
  -- TODO: EXTEND
  local allTiles = {}
  for _, tile in ipairs(chunk.tilesAsList) do
    table.insert(allTiles, Tile.repr(tile))
  end
  local tiles = table.concat(allTiles, ",\n")
  tiles = string.format([[ { %s } ]], tiles)
  return string.format(
    [[{ x=%s, y=%s, xNum=%s, yNum=%s, tilesAsList=%s }]],
    chunk.x, chunk.y, chunk.xNum, chunk.yNum, tiles
  )
end

--- Create a new Chunk from a string representation.
--- @param raw_chunk_data table
--- @param map Map You need to pass in the map to correctly create the chunk.
--- @return Chunk
function Chunk.fromRepr(raw_chunk_data, map)
  setmetatable(raw_chunk_data, { __index = Chunk })
  raw_chunk_data.map = map
  raw_chunk_data.tilesAsMap = {}
  raw_chunk_data.width = map.chunkSizeInTiles * map.tileSizeInPixels
  raw_chunk_data.height = map.chunkSizeInTiles * map.tileSizeInPixels
  local newTiles = {}
  for _, raw_tile in ipairs(raw_chunk_data.tilesAsList) do
    local tile = Tile.fromRepr(raw_tile, raw_chunk_data)
    Tile.checkType(tile)
    table.insert(newTiles, tile)
    local tile_real_x = math.floor(tile.x / map.tileSizeInPixels)
    local tile_real_y = math.floor(tile.y / map.tileSizeInPixels)
    if raw_chunk_data.tilesAsMap[tile_real_x] == nil then
      raw_chunk_data.tilesAsMap[tile_real_x] = {}
    end
    raw_chunk_data.tilesAsMap[tile_real_x][tile_real_y] = tile
  end
  Chunk.checkType(raw_chunk_data)
  return raw_chunk_data
end

--- Creates a new chunk and adds it to the list of all chunks.
--- It needs the map to get all the information about the sizes.
--- @param xNum number
--- @param yNum number
--- @param map Map
--- @return Chunk
function Chunk.new(xNum, yNum, map)
  ---!debug:start
  positiveInteger(xNum)
  positiveInteger(yNum)
  Map.checkType(map)
  ---!debug:end
  local chunk = {
    x = xNum * map.chunkSizeInTiles * map.tileSizeInPixels,
    y = yNum * map.chunkSizeInTiles * map.tileSizeInPixels,
    xNum = xNum,
    yNum = yNum,
    width = map.chunkSizeInTiles * map.tileSizeInPixels,
    height = map.chunkSizeInTiles * map.tileSizeInPixels,
    tilesAsMap = {},
    tilesAsList = {},
    drawablesInMe = {},
    map = map,
  }
  setmetatable(chunk, { __index = Chunk })

  -- create the tiles
  for relative_to_chunk_x = 0, map.chunkSizeInTiles - 1 do
    for relative_to_chunk_y = 0, map.chunkSizeInTiles - 1 do
      local real_x = chunk.x + relative_to_chunk_x * map.tileSizeInPixels
      local real_y = chunk.y + relative_to_chunk_y * map.tileSizeInPixels
      local real_x_num = math.floor(real_x / map.tileSizeInPixels)
      local real_y_num = math.floor(real_y / map.tileSizeInPixels)
      local tile = Tile.new(
        real_x,
        real_y,
        TileType.GRAS,
        chunk
      )
      Tile.checkType(tile)
      table.insert(chunk.tilesAsList, tile)
      if chunk.tilesAsMap[real_x_num] == nil then
        chunk.tilesAsMap[real_x_num] = {}
      end
      chunk.tilesAsMap[real_x_num][real_y_num] = tile
    end
  end

  ---!debug:start
  Chunk.__logfile:write("Created chunk " .. Chunk.repr(chunk) .. "\n")
  Chunk.checkType(chunk)
  ---!debug:end

  return chunk
end

--- Returns a list of all tiles that are in the chunk.
--- @return number[][] the table of tables 1 = obstacle, 0 = traversable
---
---  {
---    { 0, 0, 0, 0, 1, 1, 1, 0, 0, 0 },
---    ...
---  }
---
function Chunk:getAllMyTilesAsMapOfNavigationNumbers()
  -- 1 = obstacle
  -- 0 = traversable
  local tiles = {
    -- { 0, 0, 0, 0, 1, 1, 1, 0, 0, 0 },
    -- ...
  }
  for y = 0, self.map.chunkSizeInTiles - 1 do
    local row = {}
    for x = 0, self.map.chunkSizeInTiles - 1 do
      local tile = self.tilesAsMap[x][y]
      if tile:is_traversable() then
        table.insert(row, 0)
      else
        table.insert(row, 1)
      end
    end
    table.insert(tiles, row)
  end

  return tiles

end

--- Returns a list of all chunks that are neighbours of the given chunk.
--- @param self Chunk
--- @param alsoDiagonal boolean
--- @return Chunk[]
function Chunk.getNeighboursOfChunk(self, alsoDiagonal)
  local neighbours = {}
  local map = self.map
  local xNum = self.xNum
  local yNum = self.yNum
  if xNum > 0 then table.insert(neighbours, map:get_chunk_at_x_y_num(xNum - 1, yNum)) end
  if xNum < map.widthInChunks - 1 then table.insert(neighbours, map:get_chunk_at_x_y_num(xNum + 1, yNum)) end
  if yNum > 0 then table.insert(neighbours, map:get_chunk_at_x_y_num(xNum, yNum - 1)) end
  if yNum < map.heightInChunks - 1 then table.insert(neighbours, map:get_chunk_at_x_y_num(xNum, yNum + 1)) end
  if alsoDiagonal then
    if xNum > 0 and yNum > 0 then table.insert(neighbours, map:get_chunk_at_x_y_num(xNum - 1, yNum - 1)) end
    if xNum < map.widthInChunks - 1 and yNum > 0 then table.insert(neighbours, map:get_chunk_at_x_y_num(xNum + 1, yNum - 1)) end
    if xNum > 0 and yNum < map.heightInChunks - 1 then table.insert(neighbours, map:get_chunk_at_x_y_num(xNum - 1, yNum + 1)) end
    if xNum < map.widthInChunks - 1 and yNum < map.heightInChunks - 1 then table.insert(neighbours, map:get_chunk_at_x_y_num(xNum + 1, yNum + 1)) end
  end
  return neighbours
end

--- Draws a rect around all tiles that surround the chunk.
--- Uses the draw rect function from love2d.
--- @param self Chunk
--- @return nil
function Chunk.drawRectAroundMyBorderTiles(self)
  -- first get all border tiles
  local myBorderTiles = {}
  local my_x_start_position = self.x
  local my_x_end_position = self.x + self.width
  local my_y_start_position = self.y
  local my_y_end_position = self.y + self.height
  for _, tile in ipairs(self.tilesAsList) do
    local tile_x_start_position = tile.x
    local tile_x_end_position = tile.x + tile.width
    local tile_y_start_position = tile.y
    local tile_y_end_position = tile.y + tile.height
    if tile_x_start_position == my_x_start_position then
      table.insert(myBorderTiles, tile)
    end
    if tile_x_end_position == my_x_end_position then
      table.insert(myBorderTiles, tile)
    end
    if tile_y_start_position == my_y_start_position then
      table.insert(myBorderTiles, tile)
    end
    if tile_y_end_position == my_y_end_position then
      table.insert(myBorderTiles, tile)
    end
  end
  -- color the rect
  love.graphics.setColor(255, 255, 0, 1)
  -- draw the rect
  for _, tile in ipairs(myBorderTiles) do
    love.graphics.rectangle(
      "line",
      tile.x - Camera.x,
      tile.y - Camera.y,
      tile.width,
      tile.height
    )
  end

  love.graphics.setColor(255, 255, 255, 1)

end

function Chunk.drawRectAroundChunk(self)
  love.graphics.setColor(255, 255, 255, 1)
  love.graphics.rectangle(
    "line",
    self.x - Camera.x,
    self.y - Camera.y,
    self.width,
    self.height
  )
end

--- Draws all the traversable numbers on the tiles of a chunk.
--- @param self Chunk
--- @return nil
function Chunk.drawTraversableNumbersOnTiles(self)
  for _, tile in ipairs(self.tilesAsList) do
    if tile:is_traversable() then
      love.graphics.setColor(255, 255, 255, 1)
    else
      love.graphics.setColor(255, 100, 100, 1)
    end
    love.graphics.print(
      tile:is_traversable() == true and 0 or 1,
      tile.x - Camera.x,
      tile.y - Camera.y
    )
  end
end

function Chunk:drawClearanceNumbersOnTiles()
  -- todo: dont do this in the draw function
  for _, tile in ipairs(self.tilesAsList) do tile:checkForClearanceLevel(0) end
  for _, tile in ipairs(self.tilesAsList) do tile:checkForClearanceLevel(1) end
  for _, tile in ipairs(self.tilesAsList) do tile:checkForClearanceLevel(2) end
  for _, tile in ipairs(self.tilesAsList) do tile:checkForClearanceLevel(3) end
  for _, tile in ipairs(self.tilesAsList) do
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.print(
      tile.clearance,
      tile.x - Camera.x,
      tile.y - Camera.y + 10
    )
  end
  love.graphics.setColor(255, 255, 255, 1)
end

--- Returns the tile at the given x and y position.
--- @param self Chunk
--- @param x number
--- @param y number
--- @return Tile|nil
function Chunk.getTileAtXY(self, x, y)
  ---!debug:start
  assert(type(x) == "number", "x must be a number")
  assert(type(y) == "number", "y must be a number")
  ---!debug:end
  local tile_x = math.floor(x / self.map.tileSizeInPixels)
  local tile_y = math.floor(y / self.map.tileSizeInPixels)
  local potential_tile_map = self.tilesAsMap[tile_x]
  if potential_tile_map == nil then
    error(string.format("No tile at position %s, %s", tile_x, tile_y))
  end
  local potential_tile = self.tilesAsMap[tile_x][tile_y]
  if potential_tile == nil then
    error(string.format("No tile at position %s, %s", tile_x, tile_y))
  end
  return potential_tile
end