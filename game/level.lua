local class = require "libs.class"
local Player = require "game.player"
local Enemy = require "game.enemy"
local Glass = require "game.glass"
local STI = require "libs.sti"
local u = require "libs.underscore"

local Level = class{}
Level.SCALE = 30
Level.GRAVITY = 9.81 * Level.SCALE

function Level:init(filename)
  self.enemies = {}
  self.map = STI.new(filename)

  self.bg = love.graphics.newImage("images/forest.jpg")

  self:createPhysics()
  self:createCallbacks()
  self:createEntities()
  self:createGlass()
end

function Level:update(dt)
  self.world:update(dt)
  self.player:update(dt)
  self.glass:update(dt)
  u.invoke(self.enemies, "update", dt)
end

function Level:draw()
  love.graphics.draw(self.bg)
  self.map:drawLayer(self.map.layers["evil"])
  self.glass:draw()
  self.player:draw()
  u.invoke(self.enemies, "draw")
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

function Level:createEntities()
  local layer = self.map.layers["entities"]

  for i, object in ipairs(layer.objects) do
    if object.type == "game.player" then
      self:createPlayer(object)
    elseif object.type == "game.enemy" then
      self:createEnemy(object)
    end
  end
end

function Level:createPlayer(object)
  self.player = Player(object.x, object.y, self.world)
end

function Level:createEnemy(object)
  local enemy = Enemy(object.x, object.y, self.world, object)
  enemy.signals:register('destroy', function(enemy) self:removeEnemy(enemy) end)
  table.insert(self.enemies, enemy)
end

function Level:createGlass()
  self.glass = Glass(self.map)
end

function Level:removeEnemy(enemy)
  self.enemies = u.reject(self.enemies, function(e)
    return enemy == e
  end)
end

return Level
