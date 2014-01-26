local GameOver = {}

function GameOver:enter()
  self.image = love.graphics.newImage("images/gameover.png")
end

function GameOver:draw()
  love.graphics.draw(self.image)
end

function GameOver:keypressed(key, isrepeat)
  if key == " " then
    Gamestate.switch(Playing)
  end
end

return GameOver
