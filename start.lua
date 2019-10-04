require "game"

local StartMenu = Collection:new()

local title = Entity:new {
  id = "title",
  title = "Bare Bones",
  draw = function(self)
    love.graphics.setNewFont("Fonts/uni05_53.ttf",110*sratio())
    offset = 800*sratio()
    love.graphics.printf(self.title, (width-offset)/2, height/4, offset, "center")
    love.graphics.setNewFont("Fonts/uni05_53.ttf",25*sratio())
  end,
}
StartMenu:insert(title)

return StartMenu
