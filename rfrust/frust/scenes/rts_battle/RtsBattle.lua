RtsBattle = {
  currently_loaded_map = nil,
  --- @type Soldier[]
  currently_selected_units = {},
  name="RtsBattle-1"
}

local s
local player_faction, enemy_faction = Faction.init_default_factions()

RtsBattle.load = function()
  RtsBattle.currently_loaded_map = Map.load_map_from_file("./frust/saves/default.save.lua")

  s = Soldier.new(
    200,
    200,
    64,
    64,
    nil,
    RtsBattle.currently_loaded_map,
    100,
    10,
    10,
    10,
    10,
    10,
    10,
    1
  )
end

RtsBattle.update = function(dt)
  Camera.moveTheScreenWhenMiddleMouseIsPressed()
  Camera.moveTheScreenWhenMouseIsAtTheEdgeOfTheScreen()

  if love.keyboard.isDown("escape") then
    love.event.quit()
  end

end

RtsBattle.draw = function()

  RtsBattle.currently_loaded_map:draw()

  Soldier.draw_all()

end