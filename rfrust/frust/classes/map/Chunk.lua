--- @class Chunk
--- @field x number The x coordinate of the Chunk.
--- @field y number The y coordinate of the Chunk.
--- @field size_of_chunks_in_tiles number The size of the chunks in tiles.
--- @field tile_size_in_pixels number The size of a tile in pixels.
--- @field map Map The map that the Chunk belongs to.
--- @field tiles Tile[] The tiles that the Chunk contains.
Chunk = {}
Chunk.__index = Chunk

--------------------------------------------------------------------------
--- Creates a new Chunk.
---
--- @param x number The x coordinate of the Chunk.
--- @param y number The y coordinate of the Chunk.
--- @param size_of_chunks_in_tiles number The size of the chunks in tiles.
--- @param tile_size_in_pixels number The size of a tile in pixels.
--- @param map Map The map that the Chunk belongs to.
---
--- @return Chunk The Chunk.
--------------------------------------------------------------------------
function Chunk.new(x, y, size_of_chunks_in_tiles, tile_size_in_pixels, map)

  Utils.assert_positive_integer(x)
  Utils.assert_positive_integer(y)
  Utils.assert_positive_integer(size_of_chunks_in_tiles)
  -- x multiple of size_of_chunks_in_tiles
  assert(x % size_of_chunks_in_tiles * tile_size_in_pixels == 0,
         "x must be a multiple of size_of_chunks_in_tiles, but is " .. x .. " and size_of_chunks_in_tiles is " .. size_of_chunks_in_tiles)
  -- y multiple of size_of_chunks_in_tiles
  assert(y % size_of_chunks_in_tiles * tile_size_in_pixels == 0,
         "y must be a multiple of size_of_chunks_in_tiles, but is " .. y .. " and size_of_chunks_in_tiles is " .. size_of_chunks_in_tiles)
  assert(type(map) == "table")
  assert(getmetatable(map) == Map)
  map:check()

  local chunk = {}
  setmetatable(chunk, Chunk)
  chunk.x = x
  chunk.y = y
  chunk.size_of_chunks_in_tiles = size_of_chunks_in_tiles
  chunk.tile_size_in_pixels = tile_size_in_pixels
  chunk.map = map
  chunk.tiles = {} -- need to be set manually since tiles have the chunk reference teh belong to, so to make
  -- it work we need to set the tiles after the chunk is created, so we can add the chunk reference to the tiles firts
  -- otherwise the chunk function would fail (called in the tile constructor)

  chunk:check()
  return chunk
end

--------------------------------------------------------------------------
--- Checks if the Chunk is valid.
---
--- @return nil
--- @raise error if the Chunk is not valid
--------------------------------------------------------------------------
function Chunk:check()
  Utils.assert_positive_integer(self.x)
  Utils.assert_positive_integer(self.y)
  Utils.assert_positive_integer(self.size_of_chunks_in_tiles)
  Utils.assert_positive_integer(self.tile_size_in_pixels)

  assert(type(self.map) == "table")
  assert(getmetatable(self.map) == Map)
  --self.map:check() dont check the map here, because it would lead to an infinite loop -> the map checks all the chunks in it

  -- only check the tile correctness if the len of ties ii not 0
  if #self.tiles > 0 then
    -- check that all tiles are in the right order
    -- we assume that maps are build from left to right and then from top to bottom
    -- f.e. if tile_size_in_pixels is 32:
    -- so the first tile should be at x=0 and y=0 and the next tile should be at x=32 and y=0
    -- so when we reach the end of the row x is reset to 0 and y is increased by 32
    local last_tile = nil
    for i, tile in ipairs(self.tiles) do
      print("tile " .. i .. ": ")
      if last_tile == nil then
        assert(tile.x - self.x == 0, "tile " .. i .. " is not in the right order, got x=" .. tile.x .. " but expected x=0")
        assert(tile.y - self.y == 0, "tile " .. i .. " is not in the right order, got y=" .. tile.y .. " but expected y=0")
        last_tile = tile
      else
        assert(tile.x >= last_tile.x, "tile " .. i .. " is not in the right order")
        if tile.x == last_tile.x then
          assert(tile.y >= last_tile.y, "tile " .. i .. " is not in the right order")
        else
          assert(tile.y - self.y == 0, "tile " .. i .. " is not in the right order, got y=" .. tile.y .. " but expected y=0")
        end
        last_tile = tile
      end
    end
  end

end

--------------------------------------------------------------------------
--- Returns a string representation of the Chunk.
---
--- @return string The representation of the Chunk.
---
--- @see Chunk.from_repr
--------------------------------------------------------------------------
function Chunk:repr()
  local result = "\n{\n"
  result = result .. "__class_name__=\"Chunk\",\n"
  result = result .. "__version__ =0.1,\n"
  result = result .. "x=" .. self.x .. ",\n"
  result = result .. "y=" .. self.y .. ",\n"
  result = result .. "size_of_chunks_in_tiles=" .. self.size_of_chunks_in_tiles .. ",\n"
  result = result .. "tile_size_in_pixels=" .. self.tile_size_in_pixels .. ",\n"

  result = result .. "tiles={\n"
  for _, tile in pairs(self.tiles) do
    result = result .. tile:repr() .. ",\n"
  end
  result = result .. "},\n"

  result = result .. "}"
  return result
end

--------------------------------------------------------------------------
--- Returns a Chunk from a string representation.
---
--- @param raw_repr_data table The raw table-representation of the Chunk.
---
--- @return Chunk The Chunk.
---
--- @see Chunk.repr
--------------------------------------------------------------------------
function Chunk:from_repr(raw_repr_data)
  -- todo: implement
end
