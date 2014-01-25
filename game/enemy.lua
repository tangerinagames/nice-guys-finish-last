local class = require "libs.class"
local anim8 = require "libs.anim8"

local Enemy = class{}

function Enemy:init(posx, posy, world, object)
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

  self.body:setGravityScale(0)

  self:setVelocity(object.properties["velocity"])
  self:setLimit(object.properties["limit"])

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

function Enemy:setVelocity(velocity)
  local v = string.split(velocity, ",")
  self.body:setLinearVelocity(tonumber(v[1]), tonumber(v[2]))
end

function Enemy:setLimit(limit)
  local l = string.split(limit, ",")
  self.limit = {
    x = tonumber(l[1]),
    y = tonumber(l[2])
  }
end

return Enemy
