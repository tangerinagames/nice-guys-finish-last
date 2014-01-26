local class = require "libs.class"

local Glass = require "game.glass"
local Player = require "game.player"

local Hud = class{}

Hud.MANA_X_OFFSET = 50
Hud.MANA_Y_OFFSET = 30
Hud.MANA_WIDTH = 20
Hud.MANA_SCALE = 2

Hud.HEALTH_X_OFFSET = 50
Hud.HEALTH_PADDING = 30
Hud.HEALTH_Y_OFFSET = 30

Hud.POINTS_Y_OFFSET = 5
Hud.POINTS_SCALE = 1
Hud.POINTS_PADDING = 60
Hud.POINTS_ORIENTATION = 0
Hud.POINTS_LIMIT = 5
Hud.FONT_SCALE = 2

function Hud:init(player, glass)
  self.player = player
  self.glass = glass
  self.coin = love.graphics.newImage("images/items/coinGold.png")
end

function Hud:draw()
  self:drawMana()
  self:drawHealth()
  self:drawPoints()
end

function Hud:drawPoints()
  love.graphics.draw(self.coin,
    love.graphics.getWidth()/2,
    Hud.POINTS_Y_OFFSET,
    Hud.POINTS_ORIENTATION,
    Hud.POINTS_SCALE,
    Hud.POINTS_SCALE)

  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(self.player.points,
    love.graphics.getWidth()/2 + Hud.POINTS_PADDING,
    Hud.POINTS_Y_OFFSET + 23,
    Hud.POINTS_LIMIT,
    "left",
    Hud.POINTS_ORIENTATION,
    Hud.FONT_SCALE,
    Hud.FONT_SCALE
    )
  self:resetColor()
end

function Hud:drawHealth()
  love.graphics.setColor(255, 0, 0)
  for i = 1, Player.MAX_HEALTH do
    love.graphics.circle('line',
      Hud.HEALTH_X_OFFSET + (Hud.HEALTH_PADDING * i),
      Hud.HEALTH_Y_OFFSET,
      10
      )
  end

  for i = 1, self.player.health do
    love.graphics.circle('fill',
      Hud.HEALTH_X_OFFSET + (Hud.HEALTH_PADDING * i),
      Hud.HEALTH_Y_OFFSET,
      10
      )
  end
  self:resetColor()
end

function Hud:drawMana()
  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle('fill',
    love.graphics.getWidth() - Hud.MANA_X_OFFSET,
    Hud.MANA_SCALE * Glass.MAX_MANA + Hud.MANA_Y_OFFSET,
    Hud.MANA_WIDTH,
    -self.glass.mana * Hud.MANA_SCALE
  )
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle('line',
    love.graphics.getWidth() - Hud.MANA_X_OFFSET,
    Hud.MANA_Y_OFFSET,
    Hud.MANA_WIDTH,
    Hud.MANA_SCALE * Glass.MAX_MANA)
  self:resetColor()
end

function Hud:resetColor()
  love.graphics.setColor(255, 255, 255)
end


return Hud
