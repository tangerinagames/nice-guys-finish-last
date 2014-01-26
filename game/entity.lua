local class = require "libs.class"
local signals = require "libs.signal"
local anim8 = require "libs.anim8"
local u = require "libs.underscore"

local Entity = class{}

function Entity:init(posx, posy, world, object, image)
  self.signals = signals.new()
  self.initial = {
    x = posx,
    y = posy,
  }

  self.image = love.graphics.newImage(image)
  self.width = math.floor(self.image:getWidth() / 2)
  self.height = self.image:getHeight()

  self.body = love.physics.newBody(world, posx, posy, "dynamic")
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData{
    ["type"] = "entity",
    ["element"] = self
  }

  self:setAmount(10)
  self:defineEvilness(0.5)

  self.grid = anim8.newGrid(self.width, self.height, self.image:getWidth(), self.image:getHeight())
end

function Entity:update(dt)
  self.animation:update(dt)
end

function Entity:draw(realFace)
  realFace = realFace or false
  local x = self.body:getX() - self.width / 2
  local y = self.body:getY() - self.height / 2

  if realFace and self:isEvil() then love.graphics.setColor(200, 0, 200) end
  self.animation:draw(self.image, x, y)
  if realFace then love.graphics.setColor(255, 255, 255) end
end

function Entity:defineEvilness(probability)
  self.evil = probability > math.random()
end

function Entity:isEvil()
  return self.evil
end

function Entity:setAmount(amount)
  self.amount = amount
end

function Entity:destroy()
  self.signals:emit('destroy', self)
  self.body:destroy()
end

function Entity:collisionWithPlayer(player)
  if self:isEvil() then
    player:getDamage(self.amount)
  else
    player:getLove(self.amount)
  end
  self:destroy()
end

function Entity:killedByPlayer(player)
  if not self:isEvil() then
    player:getHarm(self.amount)
  else
    player:getLove(self.amount)
  end
  self:destroy()
end

return Entity
