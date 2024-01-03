--- @class Soldier
--- @field x number The x position in absolute pixels.
--- @field y number The y position in absolute pixels.
--- @field width number The width in pixels.
--- @field height number The height in pixels.
--- @field tile_i_am_on Tile The tile that the soldier is currently on.
--- @field tile_i_want_to_go_to Tile The tile that the soldier wants to go to.
--- @field path_to_goal Tile[] The path to the goal.
--- @field speed number The speed of the soldier in pixels per second.
--- @field chunk_i_am_on Chunk The chunk that the soldier is currently on.
--- @field health number The health of the soldier.
--- @field attack_damage number The attack damage of the soldier.
--- @field range number The range of the soldier.
--- @field attack_speed number The attack speed of the soldier.
--- @field attack_cooldown number The attack cooldown of the soldier.
--- @field armor number The armor of the soldier.
--- @field training_level number The training level of the soldier, determines the stats of the soldier.
--- @field map Map The map that the soldier is on.
--- @field dead boolean Whether the soldier is dead. If you have a ref to a soldier, you need to check this before using it.
--- @field faction Faction The faction of the soldier.
---
--- @field instances table<string, Soldier> ::STATIC:: A table of all instances of Soldier.
Soldier = {
  Atlas = nil,
  quads = {}
}

local soldier_image_data = love.image.newImageData("assets/img/soldier.png")
local replace_r, replace_g, replace_b, replace_a = soldier_image_data:getPixel( 0, 0 )

-- replace the replace_coolor with the transparent color
soldier_image_data:mapPixel(function(x, y, r, g, b, a)
  if r == replace_r and g == replace_g and b == replace_b and a == replace_a then
    return 0, 0, 0, 0
  else
    return r, g, b, a
  end
end)

Soldier.Atlas = love.graphics.newImage(soldier_image_data)

Soldier.quads.STAND = love.graphics.newQuad(64*6, 0, 64, 64, Soldier.Atlas:getDimensions())



Soldier.__index = Soldier
Soldier.instances = {}

------------------------------------------------------------------------------
--- Creates a new Soldier.
---
--- @param x number The x position in absolute pixels.
--- @param y number The y position in absolute pixels.
--- @param width number The width in pixels.
--- @param height number The height in pixels.
--- @param faction Faction The faction of the soldier.
--- @param map Map The map that the soldier is on.
--- @param speed number The speed of the soldier in pixels per second.
--- @param health number The health of the soldier.
--- @param attack_damage number The attack damage of the soldier.
--- @param range number The range of the soldier.
--- @param attack_speed number The attack speed of the soldier.
--- @param attack_cooldown number The attack cooldown of the soldier.
--- @param armor number The armor of the soldier.
--- @param training_level number The training level of the soldier, determines the stats of the soldier.
---
--- @see Map
--- @see Chunk
---
--- @return Soldier The Soldier.
------------------------------------------------------------------------------
function Soldier.new(
  x,
  y,
  width,
  height,
  faction,
  map,
  speed,
  health,
  attack_damage,
  range,
  attack_speed,
  attack_cooldown,
  armor,
  training_level
)
  local soldier = setmetatable({}, Soldier)
  soldier.x = x
  soldier.y = y
  soldier.width = width
  soldier.height = height
  soldier.faction = faction
  soldier.speed = speed
  soldier.health = health
  soldier.attack_damage = attack_damage
  soldier.range = range
  soldier.attack_speed = attack_speed
  soldier.attack_cooldown = attack_cooldown
  soldier.armor = armor
  soldier.training_level = training_level

  soldier.map = map
  soldier.tile_i_am_on = map:get_tile_at_x_y_pixel(x, y)
  soldier.tile_i_want_to_go_to = nil
  soldier.path_to_goal = nil
  soldier.chunk_i_am_on = map:get_chunk_at_x_y_pixel(x, y)
  -- todo: register soldier in chunk


  table.insert(Soldier.instances, soldier)
  return soldier
end

function Soldier:check()
  -- todo: check that all the fields are correct
end

------------------------------------------------------------------------------
--- All n frames a soldier thinks.
---
--- This means he looks for enemies, tries to go to better positions in the near
--- environment, updates this morale, decides to charge or retreat, etc.
---
--- This can take longer, since it ois not called for each unit every frame.
---
--- @return nil
------------------------------------------------------------------------------
function Soldier:think()

end

------------------------------------------------------------------------------
--- Updates default behaviours, like movment, attack cooldown, etc.
---
--- Remove dead soldiers from references.
---
--- @param dt number The delta time.
--- @return nil
------------------------------------------------------------------------------
function Soldier:update(dt)

end

------------------------------------------------------------------------------
--- Draws the Soldier.
---
--- @return nil
------------------------------------------------------------------------------
function Soldier:draw()
  love.graphics.draw(
    Soldier.Atlas,
    Soldier.quads.STAND,
    (self.x * Camera.zoom - Camera.x * Camera.zoom),
    (self.y * Camera.zoom - Camera.y * Camera.zoom),
    0,
    Camera.zoom,
    Camera.zoom
  )
end

------------------------------------------------------------------------------
--- Deletes the Soldier.
---
--- This returns the soldier from all the lists and tables which it is in.
--- Also it is set to dead == true, so that it is removed over the next few frames
--- by other units, that still have a reference to it.
---
--- @return nil
------------------------------------------------------------------------------
function Soldier:delete()

end

------------------------------------------------------------------------------
--- Draws all Soldiers.
---
--- @return nil
------------------------------------------------------------------------------
function Soldier.draw_all()
  -- todo optimize this by only drawing the soldiers that are in the camera view
  -- use draw them by chunk
  for _, soldier in ipairs(Soldier.instances) do
    soldier:draw()
  end
end

------------------------------------------------------------------------------
--- Updates all Soldiers.
---
--- @param dt number The delta time.
--- @return nil
------------------------------------------------------------------------------
function Soldier.update_all(dt)

end

------------------------------------------------------------------------------
--- Returns the number of dead soldiers.
--- Can be used to check if there is a memory leak.
--- This can happen if some table still has a reference to a soldier, but the
--- soldier is already dead, but the refernces is not deleted.
---
--- @return number The number of dead soldiers.
------------------------------------------------------------------------------
function Soldier.count_dead_ones()
  local count = 0
  for _, soldier in ipairs(Soldier.instances) do
    if soldier.dead then
      count = count + 1
    end
  end
  return count
end

function Soldier.spawn_in_default_solders(x, y, number, faction)

end