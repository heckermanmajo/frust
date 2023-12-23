

--- @class Soldier
--- A soldier is a unit that is 32 * 32 pixels big.
--- @field x number The x position of the soldier in pixels on the map.
--- @field y number The y position of the soldier in pixels on the map.
--- @field health string The health state of the soldier.
--- @field weapon1 string
--- @field weapon1Ammo number
--- @field weapon2 string
--- @field moral number
--- @field armor string
--- @field training number
--- @field granates table<string, number>
--- @field animation Animation
--- @field graphPath ChunkEntrance[]
--- @field tilePath Tile[]

Soldier = {}
Soldier.__index = Soldier