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
end

function Playing:keypressed(key, isrepeat)
  if key == " " then
    self.level.player:jump()
  end
end

return Playing
