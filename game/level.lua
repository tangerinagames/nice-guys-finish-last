local class = require "libs.class"
local Player = require "game.player"
local STI = require "libs.sti"

local Level = class{}
Level.SCALE = 30
Level.GRAVITY = 9.81 * Level.SCALE

function Level:init(filename)
  self.map = STI.new(filename)

  self:createPhysics()

  self.player = Player(360, 100, self.world)
end

function Level:update(dt)
  self.world:update(dt)
  self.player:update(dt)
end

function Level:draw()
  -- self.map:drawLayer(self.map.layers["platform"])
  self.map:draw()
  -- self.map:drawCollisionMap()

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

return Level
