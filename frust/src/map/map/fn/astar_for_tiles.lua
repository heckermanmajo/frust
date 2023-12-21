-- A* algorithm implementation in Lua

-- Node structure
Node = {
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
  node.parent = nil
  return node
end

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

--- A* algorithm function for tiles of one chunk.
--- @param _start number[] the start position {x, y}, f.e. {1, 1} or {2, 3}
--- @param _goal number[] the goal position {x, y}, f.e. {1, 1} or {2, 3}
--- @param map number[][] the table of number tables 1 = obstacle, 0 = traversable
--- @return table|nil looks like {{x=number,y=number},...} the path as a table of tables of the relative coordiniates of the given map, f.e. {{1, 1}, {1, 2}, {1, 3}}
function astar_for_tiles(_start, _goal, map)
  local start = newNode(_start.x, _start.y)
  local goal = newNode(_goal.x, _goal.y)
  local openList = {}
  local closedList = {}

  table.insert(openList, start)

  while #openList > 0 do
    local current = getLowestF(openList)

    if current.x == goal.x and current.y == goal.y then
      return reconstructPath(current)
    end

    table.remove(openList, indexof(openList, current))
    table.insert(closedList, current)

    local neighbors = {
      { x = current.x - 1, y = current.y },
      { x = current.x + 1, y = current.y },
      { x = current.x, y = current.y - 1 },
      { x = current.x, y = current.y + 1 }
    }

    for _, neighbor in ipairs(neighbors) do
      if neighbor.x >= 1 and neighbor.x <= #map[1] and neighbor.y >= 1 and neighbor.y <= #map then
        if map[neighbor.y][neighbor.x] == 0 and not nodeInList(neighbor, closedList) then
          local tentativeG = current.g + 1

          local neighborNode = newNode(neighbor.x, neighbor.y)
          if not nodeInList(neighborNode, openList) or tentativeG < neighborNode.g then
            neighborNode.parent = current
            neighborNode.g = tentativeG
            neighborNode.h = calculateHeuristic(neighborNode, goal)
            neighborNode.f = neighborNode.g + neighborNode.h

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




-- Example usage:
-- Assuming a 2D map where 0 represents walkable space and 1 represents obstacles
table.insert(
  Map.__tests,
  function()
    local map = {
      { 0, 0, 0, 1, 0 },
      { 1, 1, 0, 1, 0 },
      { 0, 0, 0, 0, 0 },
      { 0, 1, 1, 1, 1 },
      { 0, 0, 0, 0, 0 }
    }

    local start = { x = 1, y = 1 }
    local goal = { x = 5, y = 5 }

    local path = astar_for_tiles(start, goal, map)

    if path then
      print("Path found - test passed")
      for _, node in ipairs(path) do
        --print("(" .. node.x .. ", " .. node.y .. ")")
      end
    else
      error("No path found.")
      print("No path found.")
    end
  end
)



table.insert(
  Map.__tests,
  function()
    local map = {
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
      { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
    }

    local start = { x = 1, y = 1 }
    local goal = { x = 11, y = 11 }

    local path = astar_for_tiles(start, goal, map)

    if path then
      print("Path found - test passed")
      for _, node in ipairs(path) do
        --print("(" .. node.x .. ", " .. node.y .. ")")
      end
    else
      error("No path found.")
      print("No path found.")
    end
  end
)

table.insert(
  Map.__tests,
  function()
    -- todo: more tests
  end
)