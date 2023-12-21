
--- Get a path from the given x and y coordinates to the given x and y coordinates (in pixels).
--- @param fromX number
--- @param fromY number
--- @param toX number
--- @param toY number
--- @return Tile[]|nil nil if no path was found
function Map:getPathFromTo(fromX, fromY, toX, toY)
  ---!debug:start
  positiveNumber(fromX)
  positiveNumber(fromY)
  positiveNumber(toX)
  positiveNumber(toY)
  ---!debug:end

  -- TODO: ASSERT XY in map
  local fromTile = self:getTileAtXY(fromX, fromY)
  local toTile = self:getTileAtXY(toX, toY)

  assert(fromTile ~= nil, "fromTile must not be nil")
  assert(toTile ~= nil, "toTile must not be nil")
  assert(fromTile.chunk == toTile.chunk, "fromTile.chunk must be the same as toTile.chunk")

  local tableOfNumberTable = fromTile.chunk:getAllMyTilesAsMapOfNavigationNumbers()
  for _, row in ipairs(tableOfNumberTable) do
    io.write("{ ")
    for _, number in ipairs(row) do
      io.write(number .. ", ")
    end
    io.write("},\n")
  end
  -- +1 ->lua starts at 1
  local start = { x = fromTile:getRelativeXNumToChunk() + 1, y = fromTile:getRelativeYNumToChunk() + 1 }
  local goal = { x = toTile:getRelativeXNumToChunk() + 1, y = toTile:getRelativeYNumToChunk() + 1 }
  local path = astar_for_tiles(start, goal, tableOfNumberTable)

  if path == nil then return nil end

  local realPath = {}
  -- Important note: we need to subtract 1 from the x and y coordinates because the A* algorithm
  -- needs 1,1 as start but the initial tile has 0,0 as real coordinates.
  for _, node in ipairs(path) do
    local realX = (node.x-1 + fromTile.chunk.xNum * self.chunkSizeInTiles) * self.tileSizeInPixels
    local realY = (node.y-1 + fromTile.chunk.yNum * self.chunkSizeInTiles) * self.tileSizeInPixels
    table.insert(realPath, self:getTileAtXY(realX, realY))
  end

  return realPath
end