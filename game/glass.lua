local class = require "libs.class"
local anim8 = require "libs.anim8"
local u = require "libs.underscore"

local Glass = class{}

Glass.LENTS_VELOCITY = 2
Glass.MAX_MANA = 200

function Glass:init(level)
  self.level = level
  self.radius = 0
  self.canvas = love.graphics.newCanvas(2048, 2048)
  self.mana = Glass.MAX_MANA
end

function Glass:update(dt)
  if love.mouse.isDown('l') then
    self:increaseGlass()
  else
    self:decreaseGlass()
  end
end

function Glass:draw(camera)
  self.canvas:clear()
  self.canvas:renderTo(function()
    camera:draw(function()
      self.level.map:drawLayer(self.level.map.layers["platform"])
      u.invoke(self.level.entities, "draw")

      local x, y = camera:mousepos()

      love.graphics.setBlendMode("subtractive")
      love.graphics.setColor(0, 0, 0)
      love.graphics.circle("fill", x, y, self.radius)
      love.graphics.setBlendMode("alpha")
      love.graphics.setColor(255, 255, 255)
      love.graphics.circle("line", x, y, self.radius)
    end)
  end)
  love.graphics.draw(self.canvas)
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
  self.mana = math.min(self.mana + Glass.LENTS_VELOCITY, Glass.MAX_MANA)
end

return Glass
