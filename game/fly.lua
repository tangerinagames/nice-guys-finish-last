local class = require "libs.class"
local signals = require "libs.signal"
local anim8 = require "libs.anim8"
local u = require "libs.underscore"

local Entity = require "game.entity"

local Fly = class{}
Fly:include(Entity)

function Fly:init(posx, posy, world, object)
  self.shape = love.physics.newCircleShape(30)
  Entity.init(self, posx, posy, world, object, "images/enemies/fly.png")
  self.body:setGravityScale(0)

  self:setLimit(100, -50)
  self:setVelocity(80, -50)

  self.animation = anim8.newAnimation(self.grid('1-2', 1), 0.2)
end

function Fly:update(dt)
  Entity.update(self, dt)

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

function Fly:setVelocity(vx, vy)
  self.body:setLinearVelocity(vx, vy)
end

function Fly:setLimit(lx, ly)
  self.limit = {
    x = lx,
    y = ly
  }
end

return Fly
