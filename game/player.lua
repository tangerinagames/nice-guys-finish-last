local class = require "libs.class"
local anim8 = require "libs.anim8"

local Player = class{}

function Player:init(posx, posy, world)
  self.image = love.graphics.newImage("images/player/alien.png")
  self.width = math.floor(self.image:getWidth() / 4)
  self.height = math.floor(self.image:getHeight() / 3)

  self.body = love.physics.newBody(world, posx, posy, "dynamic")
  self.shape = love.physics.newCircleShape(20)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  -- self.fixture:setRestitution(0.7)

  local g = anim8.newGrid(self.width, self.height, self.image:getWidth(), self.image:getHeight())
  self.walk = anim8.newAnimation(g('2-3', 3), 0.2)

  self.touchs = 0
end

function Player:update(dt)
  self.walk:update(dt)

  local _, vy = self.body:getLinearVelocity()
  self.body:setLinearVelocity(100, vy)
end

function Player:draw()
  local x = self.body:getX() - self.width / 2
  local y = self.body:getY() - self.height + self.shape:getRadius()
  self.walk:draw(self.image, x, y)

  love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
  love.graphics.setColor(255, 255, 255)

  love.graphics.print("Touchs: " .. self.touchs, 10, 10)
end

function Player:jump()
  if self:canJump() then
    local vx, _ = self.body:getLinearVelocity()
    self.body:setLinearVelocity(vx, -400)
  end
end

function Player:canJump()
  return self.touchs > 0
end

function Player:beginContact(fixA, fixB, contact)
  self.touchs = self.touchs + 1
end

function Player:endContact(fixA, fixB, contact)
  self.touchs = self.touchs - 1
end

return Player
