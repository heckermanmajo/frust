-- todo: Create map tests: creation of map, serialisatzion tests, un-serialisation tests
-- todo: test all functions tests, and negative expect errors tests with pcall

do
  local map = Map.new(32, 16, 2, 2)

  -- TODO: check some random requests for tiles and chunks

  print(map:repr())
  local test_file = io.open("./frust/saves/debug_test_map_1.save.lua", "w")
  test_file:write("return " .. map:repr())
  test_file:close()

  --TODO: read the file again

  --TODO: test the same requests again

  print("map test 1 passed")

end