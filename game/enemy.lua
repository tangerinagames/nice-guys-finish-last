local class = require "libs.class"
local signals = require "libs.signal"
local anim8 = require "libs.anim8"
local u = require "libs.underscore"

local Enemy = class{}

function Enemy:init(posx, posy, world, object)
  self.signals = signals.new()
  self.initial = {
    x = posx,
    y = posy,
  }

  self.image = love.graphics.newImage("images/enemies/fly.png")
  self.width = math.floor(self.image:getWidth() / 2)
  self.height = self.image:getHeight()

  self.body = love.physics.newBody(world, posx, posy, "dynamic")
  self.shape = love.physics.newCircleShape(30)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData{
    ["type"] = "enemy",
    ["element"] = self
  }

  self.body:setGravityScale(0)

  self:setAmount(10)
  self:defineEvilness(0.5)
  self:setLimit(100, -50)
  self:setVelocity(80, -50)

  local g = anim8.newGrid(self.width, self.height, self.image:getWidth(), self.image:getHeight())
  self.animation = anim8.newAnimation(g('1-2', 1), 0.2)
end

function Enemy:update(dt)
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

function Enemy:draw()
  local x = self.body:getX() - self.width / 2
  local y = self.body:getY() - self.height / 2
  self.animation:draw(self.image, x, y)
end

function Enemy:setVelocity(vx, vy)
  self.body:setLinearVelocity(vx, vy)
end

function Enemy:setLimit(lx, ly)
  self.limit = {
    x = lx,
    y = ly
  }
end

function Enemy:defineEvilness(probability)
  self.evil = probability > math.random()
end

function Enemy:isEvil()
  return self.evil
end

function Enemy:setAmount(amount)
  self.amount = amount
end

function Enemy:destroy()
  self.signals:emit('destroy', self)
  self.body:destroy()
end

function Enemy:collisionWithPlayer(collided)
  if self:isEvil() then
    collided:getHarm(self.amount)
  else
    collided:getLove(self.amount)
  end
  self:destroy()
end

return Enemy
