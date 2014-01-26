local class = require "libs.class"
local Camera = require "libs.camera"
local STI = require "libs.sti"
local u = require "libs.underscore"

local Player = require "game.player"
local Enemy = require "game.enemy"
local Glass = require "game.glass"
local Hud = require "game.hud"

local Level = class{}
Level.SCALE = 30
Level.GRAVITY = 9.81 * Level.SCALE
Level.CAMERA_X_OFFSET = 400

function Level:init(filename)
  self.enemies = {}
  self.camera = Camera()
  self.map = STI.new(filename)

  self.bg = love.graphics.newImage("images/forest.jpg")

  self:createPhysics()
  self:createCallbacks()
  self:createEntities()
  self:createGlass()
  self:createHud()
end

function Level:update(dt)
  self.world:update(dt)
  self.glass:update(dt)
  u.invoke(self.enemies, "update", dt)
  self.camera:lookAt(
    math.max(self.player.body:getX() + Level.CAMERA_X_OFFSET, love.graphics.getWidth() / 2),
    math.min(self.player.body:getY(), love.graphics.getHeight() / 2)
  )
  self.player:update(dt)
end

function Level:draw()
  love.graphics.draw(self.bg)

  self.camera:draw(self.map.drawLayer, self.map, self.map.layers["evil"])
  self.glass:draw(self.camera)
  self.hud:draw()

  self.camera:draw(function()
    u.invoke(self.enemies, "draw")
  end)

  -- self.camera:draw(self.map.drawCollisionMap, self.map)
  self.camera:draw(self.player.draw, self.player)
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
    self.player:beginContact(fixA, fixB, contact)
  end

  local endContact = function(fixA, fixB, contact)
    self.player:endContact(fixA, fixB, contact)
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

function Level:createHud()
  self.hud = Hud(self.player, self.glass)
end

function Level:removeEnemy(enemy)
  self.enemies = u.reject(self.enemies, function(e)
    return enemy == e
  end)
end

function Level:destroy()
  self.player:destroy()
  u.invoke(self.enemies, "destroy")
  self.world:destroy()
end

return Level
