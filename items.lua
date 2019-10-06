require "game"
local Pawn = require "pawn"

local Items = {}

local Backpack = Pawn:new {
  image = love.graphics.newImage("Images/pack.png"),
  x = 0, y = 0,
  storage = {},
  load = function(self)
    self.storage = {}
    self.x = 0
    self.y = 0
  end,
  update = function(self,dt)
    self.pos.x = self.x*(height/20)
    self.pos.y = self.y*(height/20)
    self.scale = {x = (height/20)/self.image:getHeight(), y = (width/20)/self.image:getWidth()}
  end,
}
table.insert(Items, Backpack)


return Items
