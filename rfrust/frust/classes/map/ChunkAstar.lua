-- A* algorithm implementation in Lua

-- Node structure
local Node = {
  x = 0,
  y = 0,
  g = 0, -- Cost from the start node to this node
  h = 0, -- Heuristic: estimated cost from this node to the goal
  f = 0, -- Total cost (g + h)
  parent = nil
}

-- Function to create a new node
local function newNode(x, y)
  local node = {}
  node.x = x
  node.y = y
  node.g = 0
  node.h = 0
  node.f = 0
  node.worldPositionX = 0
  node.worldPositionY = 0
  node.parent = nil
  return node
end

-- Function to find the index of an object in a table
local function indexof(t, object)
  for i, v in ipairs(t) do
    if v == object then
      return i
    end
  end
  return nil
end

-- Function to calculate the heuristic (Manhattan distance)
local function calculateHeuristic(node, goal)
  return math.abs(node.x - goal.x) + math.abs(node.y - goal.y)
end

-- Function to check if a node is in the list
local function nodeInList(node, list)
  for _, n in ipairs(list) do
    if n.x == node.x and n.y == node.y then
      return true
    end
  end
  return false
end

-- Function to get the node with the lowest f value from the list
local function getLowestF(list)
  local lowest = list[1]
  for _, node in ipairs(list) do
    if node.f < lowest.f then
      lowest = node
    end
  end
  return lowest
end

-- Function to reconstruct the path from the goal to the start
local function reconstructPath(goal)
  local path = {}
  local current = goal
  while current do
    table.insert(path, 1, current)
    current = current.parent
  end
  return path
end

-- A* algorithm function
function astar(start, goal, map)
  local openList = {}
  local closedList = {}

  table.insert(openList, start)

  while #openList > 0 do
    local current = getLowestF(openList)

    if current.x == goal.x and current.y == goal.y then
      return reconstructPath(current)  -- Path found
    end

    table.remove(openList, indexof(openList, current))
    table.insert(closedList, current)

    -- Define neighboring nodes
    local neighbors = {
      { x = current.x - 1, y = current.y },
      { x = current.x + 1, y = current.y },
      { x = current.x, y = current.y - 1 },
      { x = current.x, y = current.y + 1 }
    }

    -- Iterate through neighbors
    for _, neighbor in ipairs(neighbors) do
      if neighbor.x >= 1 and neighbor.x <= #map[1] and neighbor.y >= 1 and neighbor.y <= #map then
        -- Check if the neighbor is traversable and not in the closed list
        if not nodeInList(neighbor, closedList) then
          local worldPosX = map[neighbor.y][neighbor.x][1]
          local worldPosY = map[neighbor.y][neighbor.x][2]
          local distanceFromNeighborToCurrent = math.sqrt((current.worldPositionX - worldPosX) ^ 2 + (current.worldPositionY - worldPosY) ^ 2)
          local tentativeG = current.g + distanceFromNeighborToCurrent

          local neighborNode = newNode(neighbor.x, neighbor.y)
          if not nodeInList(neighborNode, openList) or tentativeG < neighborNode.g then
            neighborNode.parent = current
            neighborNode.g = tentativeG
            neighborNode.h = calculateHeuristic(neighborNode, goal)
            neighborNode.f = neighborNode.g + neighborNode.h
            neighborNode.worldPositionX = worldPosX
            neighborNode.worldPositionY = worldPosY

            if not nodeInList(neighborNode, openList) then
              table.insert(openList, neighborNode)
            end
          end
        end
      end
    end
  end

  return nil  -- No path found
end

do
  -- Test case for A* algorithm

  -- Create a simple map for testing with real-world positions
  local testMap = {
    { { 1, 1 }, { 2, 1 }, { 3, 1 }, { 4, 1 }, { 5, 1 } },
    { { 1, 2 }, { 2, 2 }, { 3, 2 }, { 4, 2 }, { 5, 2 } },
    { { 1, 3 }, { 2, 3 }, { 3, 3 }, { 4, 3 }, { 5, 3 } },
    { { 1, 4 }, { 2, 4 }, { 3, 4 }, { 4, 4 }, { 5, 4 } },
    { { 1, 5 }, { 2, 5 }, { 3, 5 }, { 4, 5 }, { 5, 5 } }
  }

  -- Define start and goal nodes with real-world positions
  local startNode = newNode(1, 1)
  local goalNode = newNode(5, 5)

  -- Run the A* algorithm
  local path = astar(startNode, goalNode, testMap)

  -- Define the expected path with real-world positions
  local expectedPath = {
    { x = 1, y = 1 },
    { x = 2, y = 1 },
    { x = 3, y = 1 },
    { x = 4, y = 1 },
    { x = 5, y = 1 },
    { x = 5, y = 2 },
    { x = 5, y = 3 },
    { x = 5, y = 4 },
    { x = 5, y = 5 }
  }

  -- Check if the obtained path matches the expected path
  assert(#path == #expectedPath, "Test failed: Path length mismatch")

  for i, node in ipairs(path) do
    assert(node.x == expectedPath[i].x and node.y == expectedPath[i].y, "Test failed: Incorrect path")
  end

  print("Test passed: A* algorithm successfully found the path.")
end
do
  local testMap = {
    { { 1, 1 }, { 20, 10 }, { 3, 1 }, { 4, 1 }, { 5, 1 } },
    { { 1, 2 }, { 2, 2 }, { 3, 2 }, { 4, 2 }, { 5, 2 } },
    { { 1, 3 }, { 2, 3 }, { 3, 3 }, { 4, 3 }, { 5, 3 } },
    { { 1, 4 }, { 2, 4 }, { 3, 4 }, { 4, 4 }, { 5, 4 } },
    { { 1, 5 }, { 2, 5 }, { 3, 5 }, { 4, 5 }, { 5, 5 } }
  }

  local startNode = newNode(1, 1)
  local goalNode = newNode(5, 5)
  local path = astar(startNode, goalNode, testMap)
  for _, node in ipairs(path) do
    --print(string.format("{x= %s, y= %s},", node.x, node.y))
  end

  local expectedPath = {
    { x = 1, y = 1 },
    { x = 1, y = 2 },
    { x = 2, y = 2 },
    { x = 3, y = 2 },
    { x = 4, y = 2 },
    { x = 5, y = 2 },
    { x = 5, y = 3 },
    { x = 5, y = 4 },
    { x = 5, y = 5 },
  }
  assert(#path == #expectedPath, "Test failed: Path length mismatch")

  for i, node in ipairs(path) do
    assert(node.x == expectedPath[i].x and node.y == expectedPath[i].y, "Test failed: Incorrect path")
  end

  print("Test passed: A* algorithm successfully found the path.")
end