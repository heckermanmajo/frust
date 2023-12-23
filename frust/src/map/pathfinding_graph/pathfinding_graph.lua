
--- @class PathfindingGraph
---
---
--- Will be calculated from the map data each time
--- the map changes or is loaded.
---
--- At the end we will have a graph that
--- contains all border-pair-lists that are connected
--- and all possible paths between them.
---
---
---

--- IMPORTANT: WE NEED TO CALCULATE THIS STEPWISE
--- So this may be a good use of coroutines.
--- One function that does this stepwise and one
--- function that does the same action but in one go -> for start and loading maps

PathfindingGraph = {
  --- The optimized graph is the graph that is used for graph-astar, so a unit knows
  --- what path through the chunks it needs to make.
  --- It is optimized since it only contains the best paths between the border-pairs
  --- (first with highest clearance, then with second shortest length, etc.)
  optimized_graph = nil,

  --- Raw graph is the graph that contains all possible paths between the border-pairs.
  raw_graph = nil,
}

--- Return all node-connections of the given chunk.
function PathfindingGraph:get_all_connections_of_chunk() end
