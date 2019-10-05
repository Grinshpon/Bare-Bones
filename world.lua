require "game"
require "util"


local GameWorld = Collection:new {id = "world"}
local OptionsMenu = require "options"
local Pawn = require "pawn"

local skull = love.graphics.newImage("Images/skulllogo.png")

-- tilemap is 20x20 or 40x40?. bottom 2-4? rows are player stats

local map = Entity:new {
  id = "map",
  lvl = {{1,1,1,1,1,1,1,1,1,1},{1,1,1}}, -- dungeon, randomly generate
  obj = {}, -- object layer of map (items, nps, etc)
  draw = function(self)
    for y in ipairs(self.lvl) do
      for x,t in ipairs(self.lvl[y]) do
        --love.graphics.rectangle("fill", (x-1)*(height/20), (y-1)*(width/20), height/20, width/20) --PLACEHOLDER
      end
    end
  end,
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

local player = Pawn:new {
  id = "player",
  name = "playername", --random name gen
  hp = 10,
  maxhp = 10,
  image = love.graphics.newImage("Images/skeleton.png")
}
player.scale = {x = (height/20)/player.image:getHeight(), y = (height/20)/player.image:getHeight()}


local statbar = Entity:new {
  id = "stats",
  draw = function(self)
    love.graphics.setLineWidth(5)
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
