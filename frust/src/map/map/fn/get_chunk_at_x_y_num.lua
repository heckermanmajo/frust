--- Get the chunk at the given x and y coordinates (in chunk numbers).
--- @param xNum number The x coordinate in chunk numbers.
--- @param yNum number The y coordinate in chunk numbers.
--- @return Chunk|nil
function Map:get_chunk_at_x_y_num(xNum, yNum)
  local fn = "Map:get_chunk_at_x_y_num"

  assert(xNum ~= nil, "xNum must not be nil")
  assert(yNum ~= nil, "yNum must not be nil")
  assert(type(xNum) == "number", "xNum must be a number")
  assert(type(yNum) == "number", "yNum must be a number")

  --if xNum < 0 then L:warn(fn .. "xNum should be <= 0 is " .. tostring(xNum)) end
  --if yNum < 0 then L:warn(fn .. "yNum should be <= 0 is " .. tostring(yNum)) end
  --if xNum > self.widthInChunks then L:warn(fn .. "xNum must be < widthInChunks is " .. tostring(xNum)) end
  --if yNum > self.heightInChunks then L:warn(fn .. "yNum must be < heightInChunks is " .. tostring(yNum)) end

  if self.chunksOnXYNum[xNum] == nil then return nil end
  return self.chunksOnXYNum[xNum][yNum]
end


-- todo: add tests
table.insert(
  Map.__tests,
  function()
    Logger:warn("No Map:get_chunk_at_x_y_num-test")
  end
)