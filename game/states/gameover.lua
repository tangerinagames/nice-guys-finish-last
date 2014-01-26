local GameOver = {}

function GameOver:draw()
  local w, h = love.graphics.getDimensions()

  love.graphics.print("GameOver! press space to retry. ", w / 2 - 100, h / 2)
end

function GameOver:keypressed(key, isrepeat)
  if key == " " then
    Gamestate.switch(Playing)
  end
end

return GameOver
