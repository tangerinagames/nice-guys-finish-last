local class = require "libs.class"
local Player = require "game.player"
local STI = require "libs.sti"

local Level = class{}
Level.SCALE = 30
Level.GRAVITY = 9.81 * Level.SCALE

function Level:init(filename)
  self.map = STI.new(filename)

  self:createPhysics()
  self:createCallbacks()

  self.player = Player(10, 400, self.world)
end

function Level:update(dt)
  self.world:update(dt)
  self.player:update(dt)
end

function Level:draw()
  -- self.map:drawLayer(self.map.layers["platform"])
  self.map:draw()
  self.map:drawCollisionMap()

  self.player:draw()
end

function Level:createPhysics()
  self.map:createCollisionMap("evil")

  love.physics.setMeter(Level.SCALE)
  self.world = love.physics.newWorld(0, Level.GRAVITY, true)
  self.body = love.physics.newBody(self.world, 0, 0, "static")

  local data = self.map.collision.data
  local width = self.map.tilewidth
  local height = self.map.tileheight

  for y = 1, self.map.height do
    for x = 1, self.map.width do
      if data[y][x] == 1 then -- collidable
        local posx = (x - 1) * width + (width / 2)
        local posy = (y - 1) * height + (height / 2)
        local shape = love.physics.newRectangleShape(posx, posy, width, height, 0)
        local fixture = love.physics.newFixture(self.body, shape)
      end
    end
  end
end

function Level:createCallbacks()
  local beginContact = function(fixA, fixB, contact)
    if fixA == self.player.fixture or fixB == self.player.fixture then
      self.player:beginContact(fixA, fixB, contact)
    end
  end

  local endContact = function(fixA, fixB, contact)
    if fixA == self.player.fixture or fixB == self.player.fixture then
      self.player:endContact(fixA, fixB, contact)
    end
  end

  self.world:setCallbacks(beginContact, endContact)
end

return Level
