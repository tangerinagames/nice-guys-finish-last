local class = require "libs.class"
local Player = require "game.player"
local STI = require "libs.sti"

local Level = class{}
Level.SCALE = 30
Level.GRAVITY = 9.81 * Level.SCALE
Level.LENTS_VELOCITY = 2

function Level:init(filename)
  self.map = STI.new(filename)

  self:createPhysics()
  self:createCallbacks()

  self.player = Player(10, 400, self.world)
  self.canvas = love.graphics.newCanvas(2048, 2048)

  self.lents = 0
end

function Level:update(dt)
  self.world:update(dt)
  self.player:update(dt)
  if love.mouse.isDown('l') then
    self:increaseLens()
  else
    self:decreaseLens()
  end
end

function Level:draw()
  self.canvas:clear()
  self.canvas:renderTo(function()
    self.map:drawLayer(self.map.layers["platform"])

    local x, y = love.mouse.getPosition()

    love.graphics.setBlendMode("subtractive")
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", x, y, self.lents)
    love.graphics.setBlendMode("alpha")
  end)

  self.map:drawLayer(self.map.layers["evil"])
  love.graphics.draw(self.canvas, 0, 0)
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

function Level:increaseLens()
  self.lents = self.lents + Level.LENTS_VELOCITY
end

function Level:decreaseLens()
  self.lents = math.max(self.lents - 2 * Level.LENTS_VELOCITY, 0)
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
