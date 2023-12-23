--- @class BorderPathfindingNode
--- @field chunk1 Chunk the first chunk
--- @field chunk2 Chunk the second chunk
--- @field allTilePairs table<table<Tile,Tile>> all traversable & connected tiles next to each other - not sorted
--- @field tilesPairs table<table<Tile,Tile>> the traversable & connected tiles next to each other
--- @field bestTilePair table<Tile,Tile> the best tile pair to use for pathfinding since they have the highest clearance
--- @field pathsToOtherBestNodesInChunk1 table<BorderPathfindingNode,Tile[]> the paths to the best nodes in chunk1
--- @field pathsToOtherBestNodesInChunk2 table<BorderPathfindingNode,Tile[]> the paths to the best nodes in chunk2

BorderPathfindingNode = {}

