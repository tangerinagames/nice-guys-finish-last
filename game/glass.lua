local class = require "libs.class"
local anim8 = require "libs.anim8"

local Glass = class{}

Glass.LENTS_VELOCITY = 2

function Glass:init(map)
  self.map = map
  self.radius = 0
  self.canvas = love.graphics.newCanvas(2048, 2048)
  self.mana = 50
end

function Glass:update(dt)
  if love.mouse.isDown('l') then
    self:increaseGlass()
  else
    self:decreaseGlass()
  end
end

function Glass:draw()
  self.canvas:clear()
  self.canvas:renderTo(function()
    self.map:drawLayer(self.map.layers["platform"])

    local x, y = love.mouse.getPosition()

    love.graphics.setBlendMode("subtractive")
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", x, y, self.radius)
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("line", x, y, self.radius)
  end)
end

function Glass:drawCanvas()
  love.graphics.draw(self.canvas, 0, 0)
end

function Glass:increaseGlass()
  if self.mana > 0 then
    self.radius = self.radius + Glass.LENTS_VELOCITY
  else
    self.radius = math.max(self.radius - 2 * Glass.LENTS_VELOCITY, 0)
  end
  self.mana = math.max(self.mana - Glass.LENTS_VELOCITY, 0)
end

function Glass:decreaseGlass()
  self.radius = math.max(self.radius - 2 * Glass.LENTS_VELOCITY, 0)
  self.mana = self.mana + Glass.LENTS_VELOCITY
end

return Glass
