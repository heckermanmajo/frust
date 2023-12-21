
--- Create a new map from a string representation.
--- @param raw_map_data table
--- @return Map
function Map.from_repr(raw_map_data)
  --local map = loadstring("return " .. repr)()
  setmetatable(raw_map_data, { __index = Map })
  local newChunks = {}
  raw_map_data.chunksOnXYNum = {}
  for _, raw_chunk in ipairs(raw_map_data.chunks) do
    local chunk = Chunk.fromRepr(raw_chunk, raw_map_data)
    Chunk.checkType(chunk)
    table.insert(newChunks, chunk)
    if raw_map_data.chunksOnXYNum[chunk.xNum] == nil then
      raw_map_data.chunksOnXYNum[chunk.xNum] = {}
    end
    raw_map_data.chunksOnXYNum[chunk.xNum][chunk.yNum] = chunk
  end
  raw_map_data.chunks = newChunks
  Map.checkType(raw_map_data)
  return raw_map_data
end


table.insert(
  Map.__tests,
  function()  end
)