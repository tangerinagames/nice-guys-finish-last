local class = require "libs.class"
local signals = require "libs.signal"
local anim8 = require "libs.anim8"
local u = require "libs.underscore"

local Entity = require "game.entity"

local Rabbit = class{}
Rabbit:include(Entity)

function Rabbit:init(posx, posy, world, object)
  self.shape = love.physics.newCircleShape(0, 10, 30)
  Entity.init(self, posx, posy, world, object, "images/enemies/bunny.png")
  self.animation = anim8.newAnimation(self.grid('1-2', 1), 0.5)
end

return Rabbit
