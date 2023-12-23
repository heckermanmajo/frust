

--- @class ChunkEntrance An entrance to a chunk from another chunk. Astar-for-graph takes these as node-inputs.
--- @field chunk1 Chunk The first chunk.
--- @field chunk2 Chunk The second chunk.
--- @field allTilePairs table<table<Tile,Tile>> all traversable & connected tiles next to each other - not sorted
--- @field tilesPairs table<table<Tile,Tile>> the traversable & connected tiles next to each other
--- @field bestTilePair table<Tile,Tile> the best tile pair to use for pathfinding since they have the highest clearance
--- @field pathsToOtherBestNodesInChunk1 table<BorderPathfindingNode,Tile[]> the paths to the best nodes in chunk1
--- @field pathsToOtherBestNodesInChunk2 table<BorderPathfindingNode,Tile[]> the paths to the best nodes in chunk2

-- TODO: pathfinding-logger into specific pathfinding log file

ChunkEntrance = {}

--- Read all entrances from the given map.
--- This is done by reading the chunks left to right and top to bottom.
--- @param map Map
--- @return ChunkEntrance[] all entrances of the whole map.
function ChunkEntrance.get_entrances_from_map(map)
  -- left to right
  for x = 1, map.widthInChunks do
    local chunk = map:get_chunk_at(x, y)  -- left
    local chunk2 = map:get_chunk_at(x + 1, y) -- right
    if chunk2 then -- if there is a chunk to the right -> there could be no ones
      local entrances = ChunkEntrance.getEntrancesFromChunks(chunk, chunk2)
      for _, entrance in ipairs(entrances) do table.insert(map.entrances, entrance) end
    end
  end

  -- top to bottom
  for y = 1, map.heightInChunks do
    local chunk = map:get_chunk_at(x, y)  -- top
    local chunk2 = map:get_chunk_at(x, y + 1) -- bottom
    if chunk2 then -- if there is a chunk to the bottom -> there could be no ones
      local entrances = ChunkEntrance.getEntrancesFromChunks(chunk, chunk2)
      for _, entrance in ipairs(entrances) do table.insert(map.entrances, entrance) end
    end
  end
end

--- Reads the entrances between the two given chunks.
--- @param chunk1 Chunk
--- @param chunk2 Chunk
--- @return ChunkEntrance[]
function ChunkEntrance.getEntrancesFromChunks(chunk1, chunk2)
  -- check that they are next to each other
  -- Check where they are matching
  -- call the chunk:registerMyEntrances() function
end

--- Calculate the paths between an entrance an all other entrances
--- of the chunks the entrance connects.
--- It changes its own state and therefore does not return anything.
--- @return nil
function ChunkEntrance:calculate_paths_to_all_chunk_entries()

end

--- This function checks if entrances between the two nodes are
--- redundant and removes them.
--- Redundant means that two entrances are connected to the exact same other entrances
--- in the chunk. If this is the case, we can remove the ones with less clearance.
---
--- Changes the state of the given chunks, namely the entrances.
---
--- @param chunk1 Chunk
--- @param chunk2 Chunk
--- @return nil
function ChunkEntrance.only_keep_best_paths(chunk1, chunk2)

end

--@TODO :  define @return Type
--- Returns the chunk-entrance-graph of the given map
--- This is used ny the astar-for-graph algorithm to properly
--- read the map.
---
--- @param map Map
function ChunkEntrance.get_graph_of_entrances_for_astar_for_graph(map)

end

function ChunkEntrance.get_resumable_calculation_of_entrance_graph_information(map, steps)
  -- use coroutines, so we can split it up
  return coroutine.create(function()

  end)
end

function ChunkEntrance.calculate_all_entrance_graph_information(map)
  local resumable_calculation = ChunkEntrance.calculate_entrance_graph_information(map)
  repeat coroutine.resume(resumable_calculation)
  until coroutine.status(resumable_calculation) == "dead"
end




