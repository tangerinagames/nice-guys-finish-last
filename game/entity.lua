local class = require "libs.class"
local signals = require "libs.signal"
local anim8 = require "libs.anim8"
local u = require "libs.underscore"

local Entity = class{}

function Entity:init(posx, posy, world, object)
  self.signals = signals.new()
  self.initial = {
    x = posx,
    y = posy,
  }

  self.image = love.graphics.newImage("images/enemies/fly.png")
  self.width = math.floor(self.image:getWidth() / 2)
  self.height = self.image:getHeight()

  self.body = love.physics.newBody(world, posx, posy, "kinematic")
  self.shape = love.physics.newCircleShape(30)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData{
    ["type"] = "entity",
    ["element"] = self
  }

  self.body:setGravityScale(0)

  self:setAmount(object.properties["amount"])
  self:defineEvilness(object.properties["probability"])
  self:setLimit(object.properties["limit"])
  self:setVelocity(object.properties["velocity"])

  local g = anim8.newGrid(self.width, self.height, self.image:getWidth(), self.image:getHeight())
  self.animation = anim8.newAnimation(g('1-2', 1), 0.2)
end

function Entity:update(dt)
  self.animation:update(dt)

  local x = self.body:getX()
  local y = self.body:getY()
  local vx, vy = self.body:getLinearVelocity()

  if (x > (self.initial.x + self.limit.x)) or (x < self.initial.x) then
    vx = vx * -1
  end

  if (y < (self.initial.y + self.limit.y)) or (y > self.initial.y) then
    vy = vy * -1
  end

  self.body:setLinearVelocity(vx, vy)
end

function Entity:draw()
  local x = self.body:getX() - self.width / 2
  local y = self.body:getY() - self.height / 2
  self.animation:draw(self.image, x, y)
end

function Entity:setVelocity(velocity)
  local v = string.split(velocity, ",")
  self.body:setLinearVelocity(tonumber(v[1]), tonumber(v[2]))
end

function Entity:setLimit(limit)
  local l = string.split(limit, ",")
  self.limit = {
    x = tonumber(l[1]),
    y = tonumber(l[2])
  }
end

function Entity:defineEvilness(probability)
  self.evil = tonumber(probability) > math.random()
end

function Entity:isEvil()
  return self.evil
end

function Entity:setAmount(amount)
  self.amount = tonumber(amount)
end

function Entity:destroy()
  self.signals:emit('destroy', self)
  self.body:destroy()
end

function Entity:collisionWithPlayer(player)
  if self:isEvil() then
    player:getHarm(self.amount)
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
