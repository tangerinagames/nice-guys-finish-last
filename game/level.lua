local class = require "libs.class"
local sti = require "libs.sti"

local Level = class{}
Level.SCALE = 30
Level.GRAVITY = 9.81 * Level.SCALE

function Level:init(filename)
  self.map = sti.new(filename)
  self.map:setDrawRange(0, 0, 2000, 2000)

  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()

  self:createPhysics()

  self.ball = {}
  self.ball.body = love.physics.newBody(self.world, 710/2, 650/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  self.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
  self.ball.fixture = love.physics.newFixture(self.ball.body, self.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
  self.ball.fixture:setRestitution(0.7) --let the ball bounce
end

function Level:update(dt)
  self.world:update(dt)
end

function Level:draw()
  self.map:drawLayer(self.map.layers["platform"])
  self.map:drawCollisionMap()

  love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
  love.graphics.circle("fill", self.ball.body:getX(), self.ball.body:getY(), self.ball.shape:getRadius())
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
