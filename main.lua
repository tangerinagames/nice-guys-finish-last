Gamestate = require "libs.gamestate"
local Playing = require "game.states.playing"

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(Playing)

  local w, h = love.graphics.getDimensions()
  scaleX, scaleY = w / 1280, h / 720
end

function love.draw()
  love.graphics.scale(scaleX, scaleY)
end
