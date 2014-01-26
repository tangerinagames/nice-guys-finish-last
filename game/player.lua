local class = require "libs.class"
local anim8 = require "libs.anim8"
local u = require "libs.underscore"

local Player = class{}

Player.MAX_HEALTH = 3

function Player:init(posx, posy, world)
  self.image = love.graphics.newImage("images/player/player.png")
  self.width = math.floor(self.image:getWidth() / 4)
  self.height = math.floor(self.image:getHeight() / 3)

  self.body = love.physics.newBody(world, posx, posy, "dynamic")
  self.body:setFixedRotation(true)
  self.shape = love.physics.newCircleShape(20)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setFriction(0)

  self.feet = {}
  self.feet.shape = love.physics.newRectangleShape(0, 16, 30, 10)
  self.feet.fixture = love.physics.newFixture(self.body, self.feet.shape)
  self.feet.fixture:setSensor(true)

  self.head = {}
  self.head.shape = love.physics.newRectangleShape(0, -30, 40, 80)
  self.head.fixture = love.physics.newFixture(self.body, self.head.shape)
  self.head.fixture:setSensor(true)

  local g = anim8.newGrid(self.width, self.height, self.image:getWidth(), self.image:getHeight())

  self.anims = {
    walk = anim8.newAnimation(g('2-3', 3), 0.2),
    fall = anim8.newAnimation(g(1, 2), 1),
    jump = anim8.newAnimation(g(2, 2), 1)
  }
  self.currentAnim = self.anims.walk

  self.touchs = 0
  self.points = 0
  self.health = Player.MAX_HEALTH
  self.small_jump = 0
end

function Player:update(dt)
  self.currentAnim:update(dt)

  local _, vy = self.body:getLinearVelocity()

  if self:touch() then
    self.body:setLinearVelocity(200, vy)
  else
    self.body:setLinearVelocity(150, vy)
  end

  if vy < -20 then
    self.currentAnim = self.anims.jump
  elseif vy > 20 then
    self.currentAnim = self.anims.fall
  elseif self:touch() then
    self.currentAnim = self.anims.walk
  end

  if self.body:getY() > 1000 then
    self:kill()
  end
end

function Player:debugDraw()
  love.graphics.setColor(255, 0, 0)
  love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())

  love.graphics.setColor(0, 255, 0)
  love.graphics.polygon("line", self.body:getWorldPoints(self.feet.shape:getPoints()))

  love.graphics.setColor(0, 0, 255)
  love.graphics.polygon("line", self.body:getWorldPoints(self.head.shape:getPoints()))

  love.graphics.setColor(255, 255, 255)
end

function Player:draw()
  local x = self.body:getX() - self.width / 2
  local y = self.body:getY() - self.height + self.shape:getRadius()
  self.currentAnim:draw(self.image, x, y)

  -- self:debugDraw()
end

function Player:jump(force)
  force = force or 1
  if self:touch() then
    local vx, _ = self.body:getLinearVelocity()
    self.body:setLinearVelocity(vx, -250 * force)
    -- self.body:applyForce(0, -100000)
  end
end

function Player:touch()
  return self.touchs > 0
end

function Player:touched()
  self.touchs = self.touchs + 1
end

function Player:beginContact(fixA, fixB, contact)
  local playerFix = self:getPlayerFixture(fixA, fixB)
  local otherFix = self:getOtherFixture(fixA, fixB)
  -- local ub = fixB:getUserData()
  -- if ub and ub.element then
  --   ub.element:collisionWithPlayer(self)
  -- end

  local otherData = otherFix:getUserData()
  if (otherData.type == 'block' and playerFix == self.feet.fixture) then
    self:touched()
  elseif otherData.type == 'entity' and playerFix == self.feet.fixture then
    self:killEntity(otherData.element)
  elseif otherData.type == 'entity' and playerFix ~= self.feet.fixture then
    otherData.element:collisionWithPlayer(self)
  end
end

function Player:endContact(fixA, fixB, contact)
  local playerFix = self:getPlayerFixture(fixA, fixB)
  if (playerFix == self.feet.fixture) then
    self.touchs = self.touchs - 1
  end
end

function Player:getHarm(amount)
  self.points = self.points - amount
end

function Player:getLove(amount)
  self.points = self.points + amount
end

function Player:killEntity(entity)
  entity:killedByPlayer(self)
  self:touched()
  self:jump(0.5)
end

function Player:getPlayerFixture(...)
  return u.detect({...}, function(fixture)
    return (fixture == self.fixture) or
           (fixture == self.feet.fixture) or
           (fixture == self.head.fixture)
  end)
end

function Player:getOtherFixture(...)
  return u.detect({...}, function(fixture)
    return not ((fixture == self.fixture) or
           (fixture == self.feet.fixture) or
           (fixture == self.head.fixture))
  end)
end

function Player:destroy()
  self.body:destroy()
end

function Player:kill()
  Gamestate.switch(GameOver)
end

return Player
