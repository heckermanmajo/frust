--- @class Chunk
--- @field x number The x coordinate of the Chunk.
--- @field y number The y coordinate of the Chunk.
--- @field width number The width of the Chunk.
--- @field height number The height of the Chunk.
--- @field size_of_chunks_in_tiles number The size of the chunks in tiles.
--- @field tile_size_in_pixels number The size of a tile in pixels.
--- @field map Map The map that the Chunk belongs to.
--- @field tiles Tile[] The tiles that the Chunk contains.
---
--- @field draw_rects_around_chunks boolean ::STATIC:: If true, the Chunk draws a rectangle around itself.
Chunk = {}
Chunk.__index = Chunk
Chunk.draw_rects_around_chunks = true
Chunk.mark_border_tiles = true

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
  chunk.width = size_of_chunks_in_tiles * tile_size_in_pixels
  chunk.height = size_of_chunks_in_tiles * tile_size_in_pixels
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
function Chunk.from_repr(raw_repr_data, parent_map)
  assert(type(raw_repr_data) == "table")
  assert(raw_repr_data.__class_name__ == "Chunk")
  assert(raw_repr_data.__version__ == 0.1)

  local chunk = setmetatable({}, Chunk)
  chunk.x = raw_repr_data.x
  chunk.y = raw_repr_data.y
  chunk.size_of_chunks_in_tiles = raw_repr_data.size_of_chunks_in_tiles
  chunk.tile_size_in_pixels = raw_repr_data.tile_size_in_pixels

  chunk.width = chunk.size_of_chunks_in_tiles * chunk.tile_size_in_pixels
  chunk.height = chunk.size_of_chunks_in_tiles * chunk.tile_size_in_pixels

  assert(type(parent_map) == "table")
  assert(getmetatable(parent_map) == Map)
  chunk.map = parent_map

  chunk.tiles = {}
  for _, tile_repr in pairs(raw_repr_data.tiles) do
    local raw_repr_table_for_tile = tile_repr
    local parent_chunk_of_tile = chunk
    local tile = Tile.from_repr(raw_repr_table_for_tile, parent_chunk_of_tile)
    table.insert(chunk.tiles, tile)
  end

  chunk:check()

  return chunk

end

--------------------------------------------------------------------------
--- Draws the chunk.
---
--- It does not check if the chunk is in the viewport -> this is done by the map.
---
--- BUT it applies the camera transformation to the tiles and all other drawing-routines.
---
--- It iterates over all tiles and draws them.
--- Also it draws the special chunk-outlines if Chunk.draw_rects_around_chunks is true.
---
--- @return nil
---
--- @see Map.draw
--- @see Camera
--- @see Chunk.draw_rects_around_chunks
--------------------------------------------------------------------------
function Chunk:draw()

  for _, tile in ipairs(self.tiles) do
    local image_quad, atlas = tile:get_image_to_draw()
    local rotation = 0
    love.graphics.draw(
      atlas,
      image_quad,
      (tile.x * Camera.zoom - Camera.x * Camera.zoom),
      (tile.y * Camera.zoom - Camera.y * Camera.zoom),
      rotation,
      Camera.zoom,
      Camera.zoom
    )
  end

  -- color white
  love.graphics.setColor(1, 1, 1, 1)
  if Chunk.draw_rects_around_chunks then
    love.graphics.rectangle(
      "line",
      (self.x - Camera.x) * Camera.zoom,
      (self.y - Camera.y) * Camera.zoom,
      self.width * Camera.zoom,
      self.height * Camera.zoom
    )
  end

  -- color red: draw the top border-tiles
  if Chunk.mark_border_tiles then

    -- top
    love.graphics.setColor(1, 0, 0, 1)
    local top_border_tiles = self:get_top_border_tiles()
    for _, tile in ipairs(top_border_tiles) do
      love.graphics.circle(
        "fill",
        ((tile.x + tile.width / 4) - Camera.x) * Camera.zoom,
        ((tile.y + tile.height / 4) - Camera.y) * Camera.zoom,
        7 * Camera.zoom,
        7 * Camera.zoom
      )
    end

    -- blue left
    love.graphics.setColor(0, 0, 1, 1)
    local left_border_tiles = self:get_left_border_tiles()
    for _, tile in ipairs(left_border_tiles) do
      love.graphics.circle(
        "fill",
        ((tile.x + (tile.width / 4 * 3)) - Camera.x) * Camera.zoom,
        ((tile.y + tile.height / 4) - Camera.y) * Camera.zoom,
        7 * Camera.zoom,
        7 * Camera.zoom
      )
    end

    -- green right
    love.graphics.setColor(0, 1, 0, 1)
    local right_border_tiles = self:get_right_border_tiles()
    for _, tile in ipairs(right_border_tiles) do
      love.graphics.circle(
        "fill",
        ((tile.x + tile.width / 4) - Camera.x) * Camera.zoom,
        ((tile.y + (tile.height / 4 * 3)) - Camera.y) * Camera.zoom,
        7 * Camera.zoom,
        7 * Camera.zoom
      )
    end

    -- yellow bottom
    love.graphics.setColor(1, 1, 0, 1)
    local bottom_border_tiles = self:get_bottom_border_tiles()
    for _, tile in ipairs(bottom_border_tiles) do
      love.graphics.circle(
        "fill",
        ((tile.x + (tile.width / 4 * 3)) - Camera.x) * Camera.zoom,
        ((tile.y + (tile.height / 4 * 3)) - Camera.y) * Camera.zoom,
        7 * Camera.zoom,
        7 * Camera.zoom
      )
    end


  end

  love.graphics.setColor(1, 1, 1, 1)

end

--------------------------------------------------------------------------
--- Returns if the given chunk is a neighbour of this chunk.
---
--- @param given_chunk Chunk The other chunk.
--- @param allow_diagonal boolean If true, diagonal neighbours also count as neighbours and return true.
---
--- @return boolean If the given chunk is a neighbour of this chunk.
--------------------------------------------------------------------------
function Chunk:given_chunk_is_neighbour_of_this_chunk(given_chunk, allow_diagonal)
  ---!debug:start
  assert(type(given_chunk) == "table")
  assert(getmetatable(given_chunk) == Chunk)
  given_chunk:check()
  assert(type(allow_diagonal) == "boolean")
  self:check()
  ---!debug:end
  local SIZE_OF_CHUNK_IN_TILES = self.size_of_chunks_in_tiles * self.tile_size_in_pixels
  local delta_x = math.abs(self.x - given_chunk.x)
  local delta_y = math.abs(self.y - given_chunk.y)
  if delta_x == SIZE_OF_CHUNK_IN_TILES and delta_y == 0 then
    return true
  elseif delta_x == 0 and delta_y == SIZE_OF_CHUNK_IN_TILES then
    return true
  elseif allow_diagonal and delta_x == SIZE_OF_CHUNK_IN_TILES and delta_y == SIZE_OF_CHUNK_IN_TILES then
    return true
  else
    return false
  end
end

--------------------------------------------------------------------------
--- Returns a list of the tiles at the left border of the chunk.
--- sorted from top to bottom.
---
--- @return Tile[] The list of tiles.
--------------------------------------------------------------------------
function Chunk:get_left_border_tiles()
  local result = {}
  for _, tile in ipairs(self.tiles) do
    if tile.x == self.x then
      table.insert(result, tile)
    end
  end
  table.sort(result, function(a, b) return a.y < b.y end)
  return result
end

--------------------------------------------------------------------------
--- Returns a list of the tiles at the right border of the chunk.
--- sorted from top to bottom.
---
--- @return Tile[] The list of tiles.
--------------------------------------------------------------------------
function Chunk:get_right_border_tiles()
  local result = {}
  for _, tile in ipairs(self.tiles) do
    if tile.x == self.x + self.width - self.tile_size_in_pixels then
      table.insert(result, tile)
    end
  end
  table.sort(result, function(a, b) return a.y < b.y end)
  return result
end

--------------------------------------------------------------------------
--- Returns a list of the tiles at the top border of the chunk.
--- sorted from left to right.
---
--- @return Tile[] The list of tiles.
--------------------------------------------------------------------------
function Chunk:get_top_border_tiles()
  local result = {}
  for _, tile in ipairs(self.tiles) do
    if tile.y == self.y then
      table.insert(result, tile)
    end
  end
  table.sort(result, function(a, b) return a.x < b.x end)
  return result
end

--------------------------------------------------------------------------
--- Returns a list of the tiles at the bottom border of the chunk.
--- sorted from left to right.
---
--- @return Tile[] The list of tiles.
--------------------------------------------------------------------------
function Chunk:get_bottom_border_tiles()
  local result = {}
  for _, tile in ipairs(self.tiles) do
    if tile.y == self.y + self.height - self.tile_size_in_pixels then
      table.insert(result, tile)
    end
  end
  table.sort(result, function(a, b) return a.x < b.x end)
  return result
end

--------------------------------------------------------------------------
--- Returns a list of lists of tile-pairs that connect this chunk with the
--- other (given) chunk.
---
--- One entrance is a continuous line of tiles that are connected to each other with
--- no non-passable tiles in between.
---
--- Note: it makes sense to cache the result of this function somewhere and
---       only call it if one of both chunks is changed.
---
--- @param other_chunk Chunk The other chunk.
---
--- @return table<table<Tile, Tile> The list of lists of tile-pairs.
--------------------------------------------------------------------------
function Chunk:get_connected_entrances_to(other_chunk)

  ---!debug:start
  assert(type(other_chunk) == "table")
  assert(getmetatable(other_chunk) == Chunk)
  other_chunk:check()
  self:check()
  assert(self:given_chunk_is_neighbour_of_this_chunk(other_chunk, false))
  ---!debug:end

  local my_border_tiles = {}
  local other_border_tiles = {}

  if self.x == other_chunk.x then
    -- chunks are on the same x axis
    -- so we need to find the y axis where they are connected
    -- and then find the entrances on that y axis
    if self.y < other_chunk.y then
      -- neighbour is below this chunk
      -- we need to get the left tiles
      my_border_tiles = self:get_bottom_border_tiles()
      other_border_tiles = other_chunk:get_top_border_tiles()
    end

    if self.y > other_chunk.y then
      -- neighbour is above this chunk
      -- we need to get the right tiles
      my_border_tiles = self:get_top_border_tiles()
      other_border_tiles = other_chunk:get_bottom_border_tiles()
    end

  end

  if self.y == other_chunk.y then
    -- chunks are on the same y axis
    -- so we need to find the x axis where they are connected
    -- and then find the entrances on that x axis
    if self.x < other_chunk.x then
      -- neighbour is to the right of this chunk
      my_border_tiles = self:get_right_border_tiles()
      other_border_tiles = other_chunk:get_left_border_tiles()
    end

    if self.x > other_chunk.x then
      -- neighbour is to the left of this chunk
      my_border_tiles = self:get_left_border_tiles()
      other_border_tiles = other_chunk:get_right_border_tiles()
    end

  end

  local result = {}

  -- zip the two lists together
  for i, my_border_tile in ipairs(my_border_tiles) do
    local other_border_tile = other_border_tiles[i]
    table.insert(result, { my_border_tile, other_border_tile })
  end

  return result

end