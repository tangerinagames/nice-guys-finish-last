local Level = require "game.level"

function love.load()
  local w, h = love.graphics.getDimensions()
  scaleX, scaleY = w / 1280, h / 720

  level = Level("levels/level01")
end

function love.update(dt)
  level:update(dt)
end

function love.draw()
  love.graphics.scale(scaleX, scaleY)
  level:draw()
end
