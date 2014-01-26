Gamestate = require "libs.gamestate"
Playing = require "game.states.playing"
GameOver = require "game.states.gameover"

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(Playing)
end
