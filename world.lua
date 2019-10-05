require "game"
require "util"
require "genmap"

local GameWorld = Collection:new {id = "world"}
local OptionsMenu = require "options"
local Pawn = require "pawn"

local wall = love.graphics.newImage("Images/wall.png")
local exit = love.graphics.newImage("Images/exit.png")

-- tilemap is 20x20 or 40x40?. bottom 2-4? rows are player stats

local map = Entity:new {
  id = "map",
  lvl = {}, -- dungeon, randomly generate
  obj = {}, -- object layer of map (items, nps, etc)
  draw = function(self)
    local todraw = nil
    for y in ipairs(self.lvl) do
      for x,t in ipairs(self.lvl[y]) do
        if t == 0 then
          todraw = wall
        elseif t == 3 then
          todraw = exit
        else
          todraw = nil
        end
        if todraw then
          love.graphics.draw(todraw, (x-1)*(height/20), (y-1)*(width/20), 0, (height/20)/wall:getHeight(), (width/20)/wall:getWidth())
        end
      end
    end
  end,
  load = function(self)
    self.lvl = genMap(30,30) -- maps can be bigger than tilescreen size, will need to implement scrolling
    --self.obj = self:genObj()
  end
}

local inputs = Entity:new {
  id = "inputs",
  keycase = {
    ["escape"] = function(self)
      sr_current(OptionsMenu)
    end,
    default = function() end,
  },
  keypressed = function(self, key)
    match({key},self.keycase)(self)
  end
}


local function genName()
  local file = love.filesystem.newFile("Names/names.txt")
  local n = 0
  for name in file:lines() do
    if math.random(20) == 1 then
      return name
    end
  end
  return "John"
end

local player = Pawn:new {
  id = "player",
  name = "playername", --random name gen
  x=0,y=0,
  hp = 10,
  maxhp = 10,
  equiped = {
    head,
    body,
    legs,
    pack,
    lhand,
    rhand,
  },
  inventorySize = 0,
  inventory = {},
  image = love.graphics.newImage("Images/skeleton.png"),
  load = function(self)
    self.name = genName()
    self.hp = 10
    self.inventorySize = 0
    self.inventory = {}
    for _,v in pairs(self.equiped) do
      v = nil
    end
    self.scale = {x = (height/20)/self.image:getHeight(), y = (width/20)/self.image:getWidth()}
    for y in ipairs(map.lvl) do
      for x in ipairs(map.lvl[y]) do
        if map.lvl[y][x] == 2 then
          self.x = x
          self.y = y
          break
        end
      end
    end
  end,
  update = function(self,dt)
    self.pos.x = self.x*(height/20)
    self.pos.y = self.y*(height/20)
    self.scale = {x = (height/20)/self.image:getHeight(), y = (width/20)/self.image:getWidth()}
  end,
  equip = function(self,item)
  end,
}


local statbar = Entity:new {
  id = "stats",
  draw = function(self)
    love.graphics.setLineWidth(5)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", 0, height/20*17, width, height/20*3)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", 0,height/20*17, width/2, height/20*3) -- stats
    love.graphics.rectangle("line", width/2, height/20*17, width/2, height/20*3) -- console (you awaken..., you move..., you find..., etc)
    love.graphics.print(player.name, 20*sratio(), height/20*17+20*sratio())
    love.graphics.print("Hp: "..player.hp, 20*sratio(), height/20*18+20*sratio())
  end,
}

GameWorld.load = function(self)
  self:insert(inputs)
  self:insert(map)
  self:insert(player)
  self:insert(statbar)
end

return GameWorld
