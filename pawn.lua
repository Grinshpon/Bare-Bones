require "game"

local Pawn = Entity:new{
  id = "pawn",
  hp = 1,
  image = love.graphics.newImage("Images/select.png"),
  draw = function(self)
    love.graphics.draw(self.image, self.pos.x, self.pos.y, self.angle, self.scale.x, self.scale.y, self.offset.x, self.offset.y)
  end,
}

return Pawn
