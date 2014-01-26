Gamestate = require "libs.gamestate"
Playing = require "game.states.playing"
GameOver = require "game.states.gameover"

function love.load()
  local fairy = love.mouse.newCursor("images/items/fairy.png", 20, 20)
  love.mouse.setCursor(fairy)

  Gamestate.registerEvents()
  Gamestate.switch(Playing)
end
