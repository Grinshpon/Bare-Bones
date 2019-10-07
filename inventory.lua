require "game"
require "util"

local InventoryScreen = Collection:new()
local selector = love.graphics.newImage("Images/select.png")

local Controller = Entity:new {
  selected = 1,
  load = function(self)
    self.selected = 1
  end,
  draw = function(self)
    love.graphics.print("Equipped:",50*sratio(),120*sratio())
    love.graphics.print(player.equipped.head.name, 50*sratio(), (150+100)*sratio())
    love.graphics.print(player.equipped.body.name, 50*sratio(), (150+2*100)*sratio())
    love.graphics.print(player.equipped.legs.name, 50*sratio(), (150+3*100)*sratio())
    love.graphics.print(player.equipped.pack.name, 50*sratio(), (150+4*100)*sratio())
    love.graphics.print(player.equipped.lhand.name, 50*sratio(), (150+5*100)*sratio())
    love.graphics.print(player.equipped.rhand.name, 50*sratio(), (150+6*100)*sratio())

    love.graphics.print("Inventory:",width/2,120*sratio())
    if player.equipped.pack ~= Nil then
      for i,v in ipairs(player.equipped.pack.storage) do
        love.graphics.print(v.name, width/2, (150+(i)*100)*sratio())
        if i == self.selected then
          love.graphics.draw(selector, width/2-130*sratio(), (140+i*100)*sratio(), 0, 5*sratio(), 5*sratio())
        end
      end
    end
  end,
  keycase = {
    ["up"] = function(self)
      if self.selected > 1 then self.selected = self.selected-1 end
    end,
    ["down"] = function(self)
      if player.equipped.pack ~= Nil and self.selected < #player.equipped.pack.storage then
        self.selected = self.selected + 1
      end
    end,
    default = function() end
  },
  keypressed = function(self, key)
    if key == "escape" then
      resumecollection(LastCollectionId)
      return nil
    end
    match({key}, self.keycase)(self)
  end
}


InventoryScreen.load = function(self)
  self:insert(Controller)
end

return InventoryScreen
