Gamestate = require "libs.gamestate"
StartScreen = require "game.states.startscreen"
Playing = require "game.states.playing"
GameOver = require "game.states.gameover"

function love.load()
  local fairy = love.mouse.newCursor("images/items/fairy.png", 20, 20)
  love.mouse.setCursor(fairy)

  Gamestate.registerEvents()
  Gamestate.switch(StartScreen)
end
