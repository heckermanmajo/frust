RtsEditor = {
  currently_loaded_map = nil,
  current_ui_mode = "select", -- f.e. place tile
}

RtsEditor.load = function()
  -- first create an empty map
end

RtsEditor.update = function(dt)
  if love.keyboard.isDown("escape") then love.event.quit() end
end

RtsEditor.draw = function()
  -- draw the map
  -- draw the ui
end