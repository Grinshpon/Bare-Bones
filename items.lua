require "game"
local Pawn = require "pawn"

local Items = {}

local Backpack = Entity:new {
  id = "backpack",
  image = love.graphics.newImage("Images/pack.png"),
  --x = 0, y = 0,
  storage = {},
  limit = 0,
  load = function(self)
    self.storage = {}
    --self.x = 0
    --self.y = 0
  end,
  update = function(self,dt)
    --self.pos.x = self.x*(height/20)
    --self.pos.y = self.y*(height/20)
    --self.scale = {x = (height/20)/self.image:getHeight(), y = (width/20)/self.image:getWidth()}
  end,
}
table.insert(Items, Backpack:new {name = "Backpack (3)", limit = 3, storage = {}})

local Sword = Entity:new {
  id = "sword",
  image = love.graphics.newImage("Images/sword.png"),
  dmg = 0,
}
table.insert(Items, Sword:new {name = "Sword (3)", dmg = 3})

local Helmet = Entity:new {
  id = "helmet",
  image = love.graphics.newImage("Images/helmet.png"),
  def = 0
}
table.insert(Items, Helmet:new {name = "Helmet (1)", def = 1})

local Chest = Entity:new {
  id = "chest",
  image = love.graphics.newImage("Images/chest.png"),
  def = 0
}
table.insert(Items, Chest:new {name = "Cuirass (2)", def = 2})

local Pants = Entity:new {
  id = "pants",
  image = love.graphics.newImage("Images/pants.png"),
  def = 0
}
table.insert(Items, Chest:new {name = "Pants (1)", def = 1})

local Token = Entity:new {
  id = "token",
  image = love.graphics.newImage("Images/token.png"),
  effect = "",
  val = 0
}
table.insert(Items, Token:new {name = "Token of Health", effect = "hp", val = 3})

return Items
