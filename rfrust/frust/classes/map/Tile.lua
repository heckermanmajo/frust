
--- @type love.graphics.Image the tile texture atlas, contains all tile images
local tileTextureAtlas = love.graphics.newImage("assets/img/tiles.png")
local defaultGras = love.graphics.newImage("assets/img/gras_outline.png")

--- @class Tile A simple tile of a game world.
--- @field public x number the x position in absolute pixels
--- @field public y number the y position in absolute pixels
--- @field public width number the width in pixels
--- @field public height number the height in pixels
--- @field public tile_type string of TileType - defines the type of the tile
--- @field public chunk Chunk the chunk that the tile belongs to
---
--- @field public TileTypes table<string, string> STATIC: a table of all possible tile types
--- @field public TileAssets table<string, love.graphics.Quad> STATIC: a table of all possible tile assets
Tile = {
  TileTypes = {
    GRASS = "GRASS",
    WATER = "WATER",
    STONE = "STONE",
  },
  TileAssets = {
    GREEN_OUTLINE = love.graphics.newQuad(0, 0, 32, 32, tileTextureAtlas:getDimensions()),
    BLUE_OUTLINE = love.graphics.newQuad(32, 0, 32, 32, tileTextureAtlas:getDimensions()),
    RED_OUTLINE = love.graphics.newQuad(64, 0, 32, 32, tileTextureAtlas:getDimensions()),

    WATER = love.graphics.newQuad(26*32, 0, 32, 32, tileTextureAtlas:getDimensions()),
  }
}
Tile.__index = Tile

--------------------------------------------------------------------------
---
--- Creates a new Tile.
---
--- @param x number The x position in absolute pixels.
--- @param y number The y position in absolute pixels.
--- @param width number The width in pixels.
--- @param height number The height in pixels.
--- @param tile_type string of TileType - defines the type of the tile.
--- @param chunk Chunk The chunk that the Tile belongs to.
--- @return Tile The Tile.
---
--- @see Tile.check
-----------------------------------------------------------------------------
function Tile.new(x, y, width, height, tile_type, chunk)
  -- no param checks needed, because they are done in Tile:check() at the end
  --- @type Tile
  local tile = setmetatable({}, Tile)
  tile.x = x
  tile.y = y
  tile.width = width
  tile.height = height
  tile.tile_type = tile_type
  tile.chunk = chunk
  tile:check()
  return tile
end

--------------------------------------------------------------------------
--- Checks the Tile for errors.
---
--- @return nil
--------------------------------------------------------------------------------
function Tile:check()
  Utils.assert_positive_integer(self.x)
  Utils.assert_positive_integer(self.y)
  Utils.assert_positive_integer(self.width)
  Utils.assert_positive_integer(self.height)
  Utils.assert_in_table(self.tile_type, Tile.TileTypes)
  assert(self.chunk ~= nil)
  assert(getmetatable(self.chunk) == Chunk)
end

--------------------------------------------------------------------------
--- Returns a string representation of the Tile.
---
--- @return string The representation of the Tile.
---
--- @see Tile.from_repr
-----------------------------------------------------------------------------
function Tile:repr()
  self:check()
  local result = "{\n"
  result = result .. "__class_name__=\"Tile\",\n"
  result = result .. "__version__=0.1,\n"
  result = result .. "x=" .. self.x .. ",\n"
  result = result .. "y=" .. self.y .. ",\n"
  result = result .. "width=" .. self.width .. ",\n"
  result = result .. "height=" .. self.height .. ",\n"
  result = result .. "tile_type=\"" .. self.tile_type .. "\",\n"
  result = result .. "}"
  return result
end

--------------------------------------------------------------------------
---
--- Creates a new Tile from a string representation of a Tile.
---
--- @param raw_repr_table string The representation of the Tile.
--- @param parent_chunk Chunk The chunk that the Tile belongs to.
--- @return Tile The Tile.
---
--- @see Tile.repr()
-----------------------------------------------------------------------------
function Tile.from_repr(raw_repr_table, parent_chunk)

  assert(type(raw_repr_table) == "table")
  assert(type(parent_chunk) == "table")
  assert(getmetatable(parent_chunk) == Chunk)
  parent_chunk:check()

  --- @type Tile
  local tile = setmetatable({}, Tile)

  tile.x = raw_repr_table.x
  tile.y = raw_repr_table.y
  tile.width = raw_repr_table.width
  tile.height = raw_repr_table.height
  tile.tile_type = raw_repr_table.tile_type
  tile.chunk = parent_chunk

  tile:check()
  return tile
end

--------------------------------------------------------------------------
--- Is the tile traversable for the given traveler?
---
--- @param traveler table The traveler that wants to traverse the tile.
---
--- @return boolean true if the tile is traversable, false otherwise
--------------------------------------------------------------------------
function Tile:is_traversable(traveler)
  return self.type == Tile.TileType.GRASS
end

--------------------------------------------------------------------------
--- Returns the cost to traverse the tile for the given traveler.
---
--- @param traveler table The traveler that wants to traverse the tile.
---
--- @return number The cost to traverse the tile.
--------------------------------------------------------------------------
function Tile:get_traverse_cost(traveler)
  return 1
end

--------------------------------------------------------------------------
--- Returns the image to draw for the tile.
---
--- @return love.graphics.Quad, love.graphics.Image The image to draw for the tile and te quad of the image.
--------------------------------------------------------------------------
function Tile:get_image_to_draw()
  -- correct: return Tile.TileAssets[self.type]
  -- but for now:
  if self.tile_type == Tile.TileTypes.WATER then
    return Tile.TileAssets.WATER, tileTextureAtlas
  elseif self.tile_type == Tile.TileTypes.GRASS then
    --return Tile.TileAssets.GREEN_OUTLINE, tileTextureAtlas
    return love.graphics.newQuad(0, 0, 32, 32, 32,32), defaultGras
  end
  -- (0, 0, 32, 32, {32,32}), defaultGras
  --return Tile.TileAssets.GREEN_OUTLINE, tileTextureAtlas
end