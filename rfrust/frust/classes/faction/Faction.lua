--- @class Faction Rts-Faction.
--- @field public name string The name of the faction.
--- @field public color table The color of the faction.
--- @field public is_player boolean Whether the faction is the player faction.

Faction = {}
Faction.__index = Faction
Faction.instances = {}
Faction.by_name = {}

Faction.Colors = {
  RED = {r=1, g=0, b=0, a=1},
  GREEN = {r=0, g=1, b=0, a=1},
  BLUE = {r=0, g=0, b=1, a=1},
}


------------------------------------------------------------------------------
--- Creates a new Faction.
---
--- @param name string The name of the faction.
--- @param color table The color of the faction.
--- @param is_player boolean Whether the faction is the player faction.
---
--- @return Faction The Faction.
------------------------------------------------------------------------------
function Faction.new(name, color, is_player)
  local faction = setmetatable({}, Faction)
  faction.name = name
  faction.color = color
  faction.is_player = is_player
  table.insert(Faction.instances, faction)
  Faction.by_name[faction.name] = faction
  return faction
end

------------------------------------------------------------------------------
--- Creates and initializes the default factions ( two ones)
---
--- @return Faction, Faction The player faction and the enemy faction.
------------------------------------------------------------------------------
function Faction.init_default_factions()
  local player_faction = Faction.new("Player", Faction.Colors.BLUE, true)
  local enemy_faction = Faction.new("Enemy", Faction.Colors.RED, false)
  return player_faction, enemy_faction
end