--- @class TileType Enum helper to define the typeof a tile.
--- @field value string
TileType = {
  GRAS = "GRAS",
  WATER = "WATER",
  STONE = "STONE",
}

local TileGraphics = {
  GRAS = love.graphics.newImage("assets/tile/gras.png"),
  WATER = love.graphics.newImage("assets/tile/water.png"),
  STONE = love.graphics.newImage("assets/tile/stone.png"),
}

function TileType.exists(value)
  for name, tileType in pairs(TileType) do
    if name ~= "exists" then
      if tileType == value then
        return true
      end
    end
  end
  return false
end

--- @class Tile
--- @field x number
--- @field y number
--- @field width number
--- @field height number
--- @field occupied boolean
--- @field type TileType
--- @field chunk Chunk
--- @field clearance number - number that indicates how many tiles are free around this tile
---
--- @field __className string static! the name of the class
--- @field __protocols string[] static! the protocols that this class fulfills
--- @field __logfile file
Tile = {
  __className = "Chunk",
  __protocols = { "Collider" },
  __logfile = nil,
}

function Tile.checkType(object)
  assert(type(object) == "table", "object must be a table")
  assert(type(object.x) == "number", "object.x must be a number")
  assert(type(object.y) == "number", "object.y must be a number")
  assert(type(object.width) == "number", "object.width must be a number")
  assert(type(object.height) == "number", "object.height must be a number")
  assert(type(object.occupied) == "boolean", "object.occupied must be a boolean")
  assert(type(object.type) == "string", "object.type must be a string but is " .. type(object.type))
  assert(type(object.chunk) == "table", "object.chunk must be a table")
  Chunk.checkType(object.chunk)
end

---!debug:start
print("open tile.log to see debug messages of Tile class")
Tile.__logfile = io.open("tile.log", "w")
---!debug:end

--- Creates a string representation of a Tile that is valid Lua code.
--- @param tile Tile
--- @return string
--- @usage repr(tile) or tile:repr()
function Tile.repr(tile)
  return string.format(
    [[{ type="%s", x=%s, y=%s, occupied=%s }]],
    tile.type, tile.x, tile.y, tostring(tile.occupied)
  )
end

--- Create a new Tile from raw data representation.
--- @param raw_tile_data table
--- @param chunk Chunk You need to pass in the chunk to correctly create the tile.
--- @return Tile
function Tile.fromRepr(raw_tile_data, chunk)
  raw_tile_data.chunk = chunk
  raw_tile_data.width = chunk.map.tileSizeInPixels
  raw_tile_data.height = chunk.map.tileSizeInPixels
  raw_tile_data.clearance = 0
  setmetatable(raw_tile_data, { __index = Tile })
  ---!debug:start
  Tile.checkType(raw_tile_data)
  ---!debug:end
  return raw_tile_data
end

--- Create a new Tile.
--- @param x number
--- @param y number
--- @param type string
--- @param chunk Chunk You need to pass in the chunk to correctly create the tile.
---
--- @return Tile
function Tile.new(x, y, type, chunk)
  ---!debug:start
  positiveInteger(x)
  positiveInteger(y)
  assert(TileType.exists(type), "type must be a valid TileType: " .. tostring(type))
  ---!debug:end
  local tile = {
    x = x,
    y = y,
    width = 32,
    height = 32,
    type = type,
    chunk = chunk,
    clearance = 0,
    occupied = false,
  }
  setmetatable(tile, { __index = Tile })

  ---!debug:start
  Tile.__logfile:write("Created tile " .. Tile.repr(tile) .. "\n")
  Tile.checkType(tile)
  ---!debug:end

  return tile
end

--- Returns true if the tile is traversable.
--- @return boolean
function Tile:is_traversable()
  return self.type == TileType.GRAS
end

--- Returns the image of the tile.
--- @param self Tile
--- @return love.Image
function Tile.get_image(self)
  local image = TileGraphics[self.type]
  if image == nil then
    error("No image for tile type " .. self.type.value)
  end
  return image
end

--- Returns the x coordinate of the tile relative to the chunk so that it is in the range of 0 to chunkSizeInTiles.
--- Used for the A* algorithm.
--- @param self Tile
--- @return number
function Tile.getRelativeXNumToChunk(self)
  return math.floor(self.x / self.chunk.map.tileSizeInPixels) - self.chunk.xNum * self.chunk.map.chunkSizeInTiles
end

--- Returns the y coordinate of the tile relative to the chunk so that it is in the range of 0 to chunkSizeInTiles.
--- Used for the A* algorithm.
--- @param self Tile
--- @return number
function Tile.getRelativeYNumToChunk(self)
  return math.floor(self.y / self.chunk.map.tileSizeInPixels) - self.chunk.yNum * self.chunk.map.chunkSizeInTiles
end

--- Returns the neighbours of the tile.
--- @return Tile[]
function Tile:getNeighbours()
  local neighbours = {}
  local x = self:getRelativeXNumToChunk()
  local y = self:getRelativeYNumToChunk()
  local map = self.chunk.map
  local chunk = self.chunk

  local n1 = chunk.map:getTileAtXY(self.x - map.tileSizeInPixels, self.y)
  if n1 ~= nil then table.insert(neighbours, n1) end

  local n2 = chunk.map:getTileAtXY(self.x + map.tileSizeInPixels, self.y)
  if n2~= nil then table.insert(neighbours, n2) end

  local n3 = chunk.map:getTileAtXY(self.x, self.y - map.tileSizeInPixels)
  if n3~= nil then table.insert(neighbours, n3) end

  local n4 = chunk.map:getTileAtXY(self.x, self.y + map.tileSizeInPixels)
  if n4~= nil then table.insert(neighbours, n4) end

  -- now the diagonal neighbours

  local n5 = chunk.map:getTileAtXY(self.x - map.tileSizeInPixels, self.y - map.tileSizeInPixels)
  if n5~= nil then table.insert(neighbours, n5) end

  local n6 = chunk.map:getTileAtXY(self.x + map.tileSizeInPixels, self.y - map.tileSizeInPixels)
  if n6~= nil then table.insert(neighbours, n6) end

  local n7 = chunk.map:getTileAtXY(self.x - map.tileSizeInPixels, self.y + map.tileSizeInPixels)
  if n7~= nil then table.insert(neighbours, n7) end

  local n8 = chunk.map:getTileAtXY(self.x + map.tileSizeInPixels, self.y + map.tileSizeInPixels)
  if n8~= nil then table.insert(neighbours, n8) end

  --print("neighbours: " .. #neighbours)
  --print(serializeTable(neighbours))

  return neighbours
end

--- Calculate how many tiles are free around this tile.
--- Needs to be called ofr all tiles in order 0,1,2,3,4, ...
--- @return number
function Tile:checkForClearanceLevel(level)
  if not self:is_traversable() then
    self.clearance = 0
    return 0
  end
  if level == 0 then
    self.clearance = 1
    return 1
  end
  local neighbours = self:getNeighbours()
  local allNeighboursHaveClearanceTwo = true
  for _, neighbour in ipairs(neighbours) do
    if neighbour.clearance < level then
      allNeighboursHaveClearanceTwo = false
    end
  end
  if allNeighboursHaveClearanceTwo then
    self.clearance = level + 1
  end
  return self.clearance
end
