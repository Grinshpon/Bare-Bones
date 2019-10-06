require "game"
require "util"

local InventoryScreen = Collection:new()

local Controller = Entity:new {
  keypressed = function(self, key)
    if key == "escape" then
      resumecollection(LastCollectionId)
    end
  end,
  selected = 0,
  load = function(self)
    self.selected = 0
  end,
  draw = function(self)
    love.graphics.print("Equipped:",50*sratio(),120*sratio())
    love.graphics.print(player.equipped.head.id, 50*sratio(), (150+100)*sratio())
    love.graphics.print(player.equipped.body.id, 50*sratio(), (150+2*100)*sratio())
    love.graphics.print(player.equipped.legs.id, 50*sratio(), (150+3*100)*sratio())
    love.graphics.print(player.equipped.pack.id, 50*sratio(), (150+4*100)*sratio())
    love.graphics.print(player.equipped.lhand.id, 50*sratio(), (150+5*100)*sratio())
    love.graphics.print(player.equipped.rhand.id, 50*sratio(), (150+6*100)*sratio())

    love.graphics.print("Inventory:",width/2,120*sratio())
  end,
}


InventoryScreen.load = function(self)
  self:insert(Controller)
end

return InventoryScreen
