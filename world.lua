require "game"
require "util"
require "genmap"

local GameWorld = Collection:new {id = "world"}
local OptionsMenu = require "options"
local Pawn = require "pawn"

local wall = love.graphics.newImage("Images/wall.png")
local exit = love.graphics.newImage("Images/exit.png")

local objs = require "objs"

-- tilemap is 20x20 or 40x40?. bottom 2-4? rows are player stats

local messages = Entity:new {
  id = "messages",
  queue = {},
  add = function(self, msg)
    table.insert(self.queue, msg)
  end,
  load = function(self)
    self:add("You awaken with nothing. No clothes, no weapons, and no skin. You've been dead a while...")
    self:add("You are not safe in this dungeon. The creatures can sense the magic that resurrected you.")
    self:add("You must escape. But will an undead being even be accepted outside?")
  end,
  draw = function(self)
    local msg = ""
    if #self.queue > 0 then
      msg = msg..self.queue[1]
      --table.remove(self.queue, 1)
      if #self.queue > 1 then
        msg = msg.." -more- "
      end
    end
    love.graphics.printf(msg, width/2+20*sratio(), height/20*17+20*sratio(), width/2-40, "left")
  end,
  keypressed = function(self, key)
    if key ~= "escape" then
      if self.queue[1] then
        table.remove(self.queue, 1)
      end
    end
  end,
}

local map = Entity:new {
  id = "map",
  lvl = {}, -- dungeon, randomly generate
  obj = {}, -- object layer of map (items, nps, etc)
  depth = 0,
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
  load = function(self) --v (30,30)
    self.depth = 0
    self.lvl = genMap(20,17) -- maps can be bigger than tilescreen size, will need to implement scrolling
    self.obj = genObj(self.lvl, objs)
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
    if math.random(60) == 1 then
      return name
    end
  end
  return "John"
end

local function moveOrAtk(dx,dy)
  return function(self)
    if map.lvl[dy+self.y+1] and map.lvl[dy+self.y+1][dx+self.x+1] and map.lvl[dy+self.y+1][dx+self.x+1] ~= 0 then --TODO add object collision and combat code
      self.x = self.x+dx
      self.y = self.y+dy
    else
      messages:add("That way is blocked")
    end
  end
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
  keycase = {
    ["k"] = moveOrAtk(0,-1), --up
    ["j"] = moveOrAtk(0,1), --down
    ["h"] = moveOrAtk(-1,0), --left
    ["l"] = moveOrAtk(1,0), --right
    ["y"] = moveOrAtk(-1,-1), --up-left
    ["u"] = moveOrAtk(1,-1), --up-right
    ["b"] = moveOrAtk(-1,1), --down-left
    ["n"] = moveOrAtk(1,1), --down-right
    default = function() end,
  },
  keypressed = function(self, key)
    if #messages.queue == 0 then
      match({key},self.keycase)(self)
    end
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
  self:insert(statbar)
  self:insert(messages)
  self:insert(player)
end

return GameWorld
