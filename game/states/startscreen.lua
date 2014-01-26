local StartScreen = {}

function StartScreen:enter()
  self.image = love.graphics.newImage("images/start.png")
end

function StartScreen:draw()
  love.graphics.draw(self.image)
end

function StartScreen:keypressed(key, isrepeat)
  if key == " " then
    Gamestate.switch(Playing)
  end
end

return StartScreen
