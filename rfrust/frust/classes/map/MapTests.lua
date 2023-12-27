-- todo: Create map tests: creation of map, serialisatzion tests, un-serialisation tests
-- todo: test all functions tests, and negative expect errors tests with pcall

do

  do
    local map = Map.new(32, 16, 2, 2)
    local max_x_pixel = map.size_of_chunks_in_tiles * map.size_of_tiles_in_pixels * map.len_of_map_in_chunks
    local max_y_pixel = map.size_of_chunks_in_tiles * map.size_of_tiles_in_pixels * map.height_of_map_in_chunks

    local test_file = io.open("./frust/saves/debug_test_map_1.save.lua", "w")
    test_file:write("return " .. map:repr())
    test_file:close()

    -- calculate some random numbers acn check if the tiles are correct
    for i = 1, 1000 do
      local x = math.random(0, max_x_pixel-1)
      local y = math.random(0, max_y_pixel-1)
      local tile = map:get_tile_at_x_y_pixel(x, y, false)
      assert(tile.x == math.floor(x / map.size_of_tiles_in_pixels) * map.size_of_tiles_in_pixels)
      assert(tile.y == math.floor(y / map.size_of_tiles_in_pixels) * map.size_of_tiles_in_pixels)
    end

    do
      local first_tile = map:get_tile_at_x_y_pixel(0, 0, false)
      assert(first_tile.x == 0, "first_tile.x == " .. first_tile.x)
      assert(first_tile.y == 0, "first_tile.y == " .. first_tile.y)
    end

    do
      local first_tile = map:get_tile_at_x_y_pixel(31, 15, false)
      assert(first_tile.x == 0)
      assert(first_tile.y == 0)
    end

    do
      local second_tile = map:get_tile_at_x_y_pixel(32, 32, false)
      assert(second_tile.x == 32, "second_tile.x == " .. second_tile.x)
      assert(second_tile.y == 32, "second_tile.y == " .. second_tile.y)
    end

    do
      local second_tile = map:get_tile_at_x_y_pixel(40, 40, false)
      assert(second_tile.x == 32, "second_tile_2.x == " .. second_tile.x)
      assert(second_tile.y == 32, "second_tile_2.y == " .. second_tile.y)
    end

    do
      -- we dont expect a tile here
      local code, _ = pcall(function() map:get_tile_at_x_y_pixel(-10, -10, false) end)
      assert(code == false, "code == " .. tostring(code))
    end

    do
      -- outside of the map
      local code, _ = pcall(function() map:get_tile_at_x_y_pixel(max_x_pixel + 12, max_y_pixel, false) end)
      assert(code == false, "code == " .. tostring(code))
    end

    map:check()

  end

  DEBUGLOG("map: direct creation tests passed")

  do
    local test_content = io.open("./frust/saves/debug_test_map_1.save.lua", "r"):read("*all")
    test_content = loadstring(test_content)()
    local map = Map.from_repr(test_content)
    local max_x_pixel = map.size_of_chunks_in_tiles * map.size_of_tiles_in_pixels * map.len_of_map_in_chunks
    local max_y_pixel = map.size_of_chunks_in_tiles * map.size_of_tiles_in_pixels * map.height_of_map_in_chunks

    do
      local first_tile = map:get_tile_at_x_y_pixel(0, 0, false)
      assert(first_tile.x == 0, "first_tile.x == " .. first_tile.x)
      assert(first_tile.y == 0, "first_tile.y == " .. first_tile.y)
    end

    do
      local first_tile = map:get_tile_at_x_y_pixel(31, 15, false)
      assert(first_tile.x == 0)
      assert(first_tile.y == 0)
    end

    do
      local second_tile = map:get_tile_at_x_y_pixel(32, 32, false)
      assert(second_tile.x == 32, "second_tile.x == " .. second_tile.x)
      assert(second_tile.y == 32, "second_tile.y == " .. second_tile.y)
    end

    do
      local second_tile = map:get_tile_at_x_y_pixel(40, 40, false)
      assert(second_tile.x == 32, "second_tile_2.x == " .. second_tile.x)
      assert(second_tile.y == 32, "second_tile_2.y == " .. second_tile.y)
    end

    do
      -- we dont expect a tile here
      local code, _ = pcall(function() map:get_tile_at_x_y_pixel(-10, -10, false) end)
      assert(code == false, "code == " .. tostring(code))
    end

    do
      -- outside of the map
      local code, _ = pcall(function() map:get_tile_at_x_y_pixel(max_x_pixel + 12, max_y_pixel, false) end)
      assert(code == false, "code == " .. tostring(code))
    end

    -- calculate some random numbers acn check if the tiles are correct
    for i = 1, 1000 do
      local x = math.random(0, max_x_pixel-1)
      local y = math.random(0, max_y_pixel-1)
      local tile = map:get_tile_at_x_y_pixel(x, y, false)
      assert(tile.x == math.floor(x / map.size_of_tiles_in_pixels) * map.size_of_tiles_in_pixels)
      assert(tile.y == math.floor(y / map.size_of_tiles_in_pixels) * map.size_of_tiles_in_pixels)
    end


  end

  DEBUGLOG("map test 1 passed")

end