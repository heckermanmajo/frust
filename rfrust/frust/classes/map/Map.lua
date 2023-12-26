--- @class Map
--- @field chunks Chunk[]
--- @field chunk_map table<number,<table<number, Chunk>>
--- @field tile_map table<number,<table<number, Tile>>
--- @field size_of_tiles_in_pixels number
--- @field size_of_chunks_in_tiles number
--- @field len_of_map_in_chunks number
--- @field height_of_map_in_chunks number
Map = {}
Map.__index = Map

--------------------------------------------------------------------------
--- Creates a new Map.
---
--- @param size_of_tiles_in_pixels number The size of a tile in pixels.
--- @param size_of_chunks_in_tiles number The size of a chunk in tiles.
--- @param len_of_map_in_chunks number The length of the map in chunks.
--- @param height_of_map_in_chunks number The height of the map in chunks.
---
--- @return Map The Map.
--------------------------------------------------------------------------
function Map.new(-- todo: create chunks from input data
  size_of_tiles_in_pixels,
  size_of_chunks_in_tiles,
  len_of_map_in_chunks,
  height_of_map_in_chunks
)
  local map = {}
  setmetatable(map, Map)
  map.size_of_tiles_in_pixels = size_of_tiles_in_pixels
  map.size_of_chunks_in_tiles = size_of_chunks_in_tiles
  map.len_of_map_in_chunks = len_of_map_in_chunks
  map.height_of_map_in_chunks = height_of_map_in_chunks

  map.chunks = {}
  map.chunk_map = {}
  map.tile_map = {}

  -- for all chunks in the len (go left to right)
  for x = 0, len_of_map_in_chunks - 1 do
    -- for all chunks in the height (go top to bottom)
    for y = 0, height_of_map_in_chunks - 1 do

      -- create the chunk (but dont set the tiles yet)
      local chunk = Chunk.new(
        x * size_of_chunks_in_tiles * size_of_tiles_in_pixels,
        y * size_of_chunks_in_tiles * size_of_tiles_in_pixels,
        size_of_chunks_in_tiles,
        size_of_tiles_in_pixels,
        map
      )

      -- Create the tiles of the chunk
      local tiles_of_chunk = {}
      -- for all tiles in the chunk (go left to right)
      for _x = 0, size_of_chunks_in_tiles - 1 do
        -- for all tiles in the chunk (go top to bottom)
        for _y = 0, size_of_chunks_in_tiles - 1 do
          -- calculate the absolute position of the tile, since the current position is the relative number to the chunk
          local absolute_tile_x = x * size_of_chunks_in_tiles * size_of_tiles_in_pixels + _x * size_of_tiles_in_pixels
          local absolute_tile_y = y * size_of_chunks_in_tiles * size_of_tiles_in_pixels + _y * size_of_tiles_in_pixels
          local tile = Tile.new(
            absolute_tile_x,
            absolute_tile_y,
            size_of_tiles_in_pixels,
            size_of_tiles_in_pixels,
            Tile.TileTypes.GRASS, -- set all tiles to grass on default
            chunk
          )
          -- add the tile to the tile associative table in the Mamp-Class instance
          -- this way we can access the tiles directly by their position
          if map.tile_map[_x] == nil then
            map.tile_map[_x] = {}
          end
          map.tile_map[_x][_y] = tile

          -- add the tiles also into a list for fast iteration over all tiles
          table.insert(tiles_of_chunk, tile)
        end
      end

      -- set the tiles of the chunk manually
      chunk.tiles = tiles_of_chunk
      -- check chunk again after adding the tiles
      chunk:check()

      -- add the chunk to the mapping on its position
      if map.chunk_map[x] == nil then
        map.chunk_map[x] = {}
      end
      map.chunk_map[x][y] = chunk

      -- add the chunk to the list of chunks for fast iteration
      table.insert(map.chunks, chunk)
    end
  end

  -- create all the tiles
  map:check()

  return map
end

------------------------------------ --------------------------------------
--- Checks if the Map is valid.
---
--- @return nil
---
--- @raise error if the Map is not valid
--------------------------------------------------------------------------
function Map:check()

  assert(type(self) == "table")
  assert(getmetatable(self) == Map)
  Utils.assert_positive_number(self.size_of_tiles_in_pixels)
  Utils.assert_positive_integer(self.size_of_chunks_in_tiles)
  Utils.assert_positive_integer(self.len_of_map_in_chunks)
  Utils.assert_positive_integer(self.height_of_map_in_chunks)
  assert(type(self.chunks) == "table", "self.chunks must be a table, but is " .. type(self.chunks))

  -- check all chunks in the chunks-list
  for _, chunk in pairs(self.chunks) do
    assert(type(chunk) == "table")
    assert(getmetatable(chunk) == Chunk)
    chunk:check()
  end

  -- assert that all chunks are in the chunk_map
  for x, chunk_map in pairs(self.chunk_map) do
    Utils.assert_positive_integer(x)
    assert(math.floor(x / self.size_of_chunks_in_tiles) == 0)
    assert(type(chunk_map) == "table")
    for y, chunk in pairs(chunk_map) do
      Utils.assert_positive_integer(y)
      assert(math.floor(y / self.size_of_chunks_in_tiles) == 0)
      assert(type(chunk) == "table")
      assert(getmetatable(chunk) == Chunk)
      chunk:check()
    end
  end

  -- check that the chunks in the chunk_map are the same as in the chunks-list
  for _, chunk in pairs(self.chunks) do
    local number_position_instead_of_pixels_x = math.floor(chunk.x / (self.size_of_chunks_in_tiles * self.size_of_tiles_in_pixels))
    local number_position_instead_of_pixels_y = math.floor(chunk.y / (self.size_of_chunks_in_tiles * self.size_of_tiles_in_pixels))
    assert(self.chunk_map[number_position_instead_of_pixels_x] ~= nil)
    assert(self.chunk_map[number_position_instead_of_pixels_x][number_position_instead_of_pixels_y] ~= nil)
  end

  return nil
end

--------------------------------------------------------------------------
--- Returns a string representation of the Map.
---
--- @return string The representation of the Map.
---
--- @see Map.from_repr
--------------------------------------------------------------------------
function Map:repr(save_name)
  local currentTime = os.date("%c", os.time())
  local result = "{\n"
  result = result .. "__version__=0.1,\n"
  result = result .. "__class_name__=\"Map\",\n"
  result = result .. "__creation_time__=\"" .. currentTime .. "\",\n"
  result = result .. "__creation_time_unix__=\"" .. os.time() .. "\",\n"
  if save_name ~= nil then
    result = result .. "__save_name__=\"" .. save_name .. "\",\n"
  end
  result = result .. "size_of_tiles_in_pixels=" .. self.size_of_tiles_in_pixels .. ",\n"
  result = result .. "size_of_chunks_in_tiles=" .. self.size_of_chunks_in_tiles .. ",\n"
  result = result .. "len_of_map_in_chunks=" .. self.len_of_map_in_chunks .. ",\n"
  result = result .. "height_of_map_in_chunks=" .. self.height_of_map_in_chunks .. ",\n"

  result = result .. "chunks={"
  for _, chunk in ipairs(self.chunks) do
    chunk:check()
    result = result .. chunk:repr() .. ","
  end
  result = result .. "\n},\n" -- end of chunks

  -- chunk map is not included in the repr -> it is created from the chunks-table

  result = result .. "}\n"

  return result
end

--------------------------------------------------------------------------
--- Creates a new Map from a parsed string representation of a Map.
---
--- @param raw_table_data table The parsed representation of the Map.
---
--- @return Map The Map.
---
--- @see Map.repr()
--------------------------------------------------------------------------
function Map.from_repr(raw_table_data)
  assert(type(raw_table_data) == "table")
  if raw_table_data.__className__ ~= "Map" then
    error("raw_table_data.__className__ must be \"Map\"")
  end
  if raw_table_data.__version__ ~= 0.1 then
    error("raw_table_data.__version__ must be 0.1")
  end
  -- todo: read all chunks
  -- todo: then read all tiles from each chunk
  -- todo: check that all needed chunks exist


end

--------------------------------------------------------------------------
--- Returns the chunk at the given x and y pixel coordinates.
---
--- @param x number The x pixel coordinate.
--- @param y number The y pixel coordinate.
--- @param allow_nil boolean If true, then nil is returned if the chunk does not exist, otherwise an error is thrown.
---
--- @return Chunk The chunk at the given x and y pixel coordinates.
--------------------------------------------------------------------------
function Map:get_chunk_at_x_y_pixel(x, y, allow_nil)
  local _x = math.floor(x / (self.size_of_chunks_in_tiles * self.size_of_tiles_in_pixels))
  local _y = math.floor(y / (self.size_of_chunks_in_tiles * self.size_of_tiles_in_pixels))

  if not self:chunk_exists_at_x_y_pixel(_x, _y) then
    if allow_nil == nil then
      return nil
    else
      error("chunk does not exist at x=" .. _x .. " y=" .. _y)
    end
  end

  local chunk = self.chunk_map[_x][_y]

  ---!debug:start
  assert(type(chunk) == "table")
  assert(getmetatable(chunk) == Chunk)
  chunk:check()
  ---!debug:end

  return chunk
end

--------------------------------------------------------------------------
--- Returns true if a chunk exists at the given x and y pixel coordinates.
---
--- @param x number The x pixel coordinate.
--- @param y number The y pixel coordinate.
---
--- @return boolean True if a chunk exists at the given x and y pixel coordinates, false otherwise.
--------------------------------------------------------------------------
function Map:chunk_exists_at_x_y_pixel(x, y)

  local _x = math.floor(x / (self.size_of_chunks_in_tiles * self.size_of_tiles_in_pixels))
  local _y = math.floor(y / (self.size_of_chunks_in_tiles * self.size_of_tiles_in_pixels))

  if self.chunk_map[_x] == nil then
    return false
  end

  if self.chunk_map[_x][_y] == nil then
    return false
  end

  ---!debug:start
  assert(type(self.chunk_map[_x][_y]) == "table")
  assert(getmetatable(self.chunk_map[_x][_y]) == Chunk)
  self.chunk_map[_x][_y]:check()
  ---!debug:end

  return true
end

--------------------------------------------------------------------------
--- Returns the tile at the given x and y pixel coordinates.
---
--- @param x number The x pixel coordinate.
--- @param y number The y pixel coordinate.
--- @param allow_nil boolean If true, then nil is returned if the tile does not exist, otherwise an error is thrown.
---
--- @return Tile The tile at the given x and y pixel coordinates.
--------------------------------------------------------------------------
function Map:get_tile_at_x_y_pixel(x, y, allow_nil)
  local _x = math.floor(x / self.size_of_tiles_in_pixels)
  local _y = math.floor(y / self.size_of_tiles_in_pixels)

  if not self:tile_exists_at_x_y_pixel(_x, _y) then
    if allow_nil == nil then
      return nil
    else
      error("tile does not exist at x=" .. _x .. " y=" .. _y)
    end
  end

  local tile = self.tile_map[_x][_y]

  ---!debug:start
  assert(type(tile) == "table")
  assert(getmetatable(tile) == Tile)
  tile:check()
  ---!debug:end

  return tile
end

--------------------------------------------------------------------------
--- Returns true if a tile exists at the given x and y pixel coordinates.
---
--- @param x number The x pixel coordinate.
--- @param y number The y pixel coordinate.
---
--- @return boolean True if a tile exists at the given x and y pixel coordinates, false otherwise.
--------------------------------------------------------------------------
function Map:tile_exists_at_x_y_pixel(x, y)

  local _x = math.floor(x / self.size_of_tiles_in_pixels)
  local _y = math.floor(y / self.size_of_tiles_in_pixels)

  if self.tile_map[_x] == nil then
    return false
  end

  if self.tile_map[_x][_y] == nil then
    return false
  end

  ---!debug:start
  assert(type(self.tile_map[_x][_y]) == "table")
  assert(getmetatable(self.tile_map[_x][_y]) == Tile)
  self.tile_map[_x][_y]:check()
  ---!debug:end

  return true
end

--------------------------------------------------------------------------
--- Returns a list of tiles you need to walk to get from from_x, from_y to to_x, to_y.
---
--- @param from_x number The x pixel coordinate of the starting point.
--- @param from_y number The y pixel coordinate of the starting point.
--- @param to_x number The x pixel coordinate of the destination.
--- @param to_y number The y pixel coordinate of the destination.
--- @param traveler any|nil The traveler is an object that wants to go the way, it will be passed into the is_traversable and get_traverse_costs function of the tiles.
---
--- @return Tile[] The list of tiles you need to walk to get from from_x, from_y to to_x, to_y.
---
--- @see Tile.is_traversable
--- @see Tile.get_traverse_cost
--------------------------------------------------------------------------
function Map:get_path_from_to(from_x, from_y, to_x, to_y, traveler) -- todo: implement
end


