local Level = require "game.level"

local Playing = {}

function Playing:enter()
  self.level = Level("levels/level01")
end

function Playing:update(dt)
  self.level:update(dt)
end

function Playing:draw()
  self.level:draw()
  love.graphics.print("touchs: " .. self.level.player.touchs, 10, 20)
end

function Playing:keypressed(key, isrepeat)
  if key == " " then
    self.level.player:jump()
  end
end

function Playing:leave()
  self.level:destroy()
end

return Playing
