--- @file Hierarchical Annotated A*
--- Step1: Put clearance levels on the map
--- Step2: Divide Map into chunks
--- Step3: Create a graph of the chunks
---     - Make groups of the chunk connecting nodes(next to ech other one piece)
---     - Astar between the groups of all adjacent chunks
---     - take for it the one with the highest clearance
--- Step4: Weak dominance: Only retain the path between the groups with the highest clearance

