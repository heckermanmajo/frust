--- Create a string representation of a Map that is valid Lua code.
--- @param self Map
function Map.repr(self)
  local chunks = {}
  for _, chunk in ipairs(self.chunks) do
    table.insert(chunks, Chunk.repr(chunk))
    if self.chunksOnXYNum[chunk.xNum] == nil then
      self.chunksOnXYNum[chunk.xNum] = {}
    end
    self.chunksOnXYNum[chunk.xNum][chunk.yNum] = chunk
  end
  chunks = table.concat(chunks, ",\n")
  chunks = string.format([[ { %s } ]], chunks)
  return string.format(
    [[return Map.from_repr{ chunks=%s, chunkSizeInTiles=%s, tileSizeInPixels=%s, widthInChunks=%s, heightInChunks=%s }]],
    chunks, self.chunkSizeInTiles, self.tileSizeInPixels, self.widthInChunks, self.heightInChunks
  )
end


table.insert(
  Map.__tests,
  function ()
    print("Map.repr-test")
    local map = Map.new(32, 32, 1, 1)
    local repr = Map.repr(map)
  end
)
