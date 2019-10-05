require "util"

Entity = Object:new {
  id = "",
  load = function(self, ...) end,
  update = function(self, dt) end,
  draw = nil,
  pos = {x = 0, y = 0, z = 0},
  destroy = function(self) end,
  keypressed = function(self, key) end,
  keyreleased = function(self, key) end,
}

Collection = Object:new { -- name? World, Scene, Controller, Collection
  id = "",
  Entities = {},
  insert = function(self, entity, ...)
    if entity.id and entity.load and entity.update and entity.destroy then
      entity:load(...);
      table.insert(self.Entities, entity);
    else
      error "Attempt to insert non-entity, or entity is missing core components" -- should it be an error or warning?
    end
  end,
  destroy = function(self, id)
    for k,v in ipairs(self.Entities) do
      if v.id == id then
        v:destroy()
        table.remove(self.Entities, k)
      end
    end
  end,
  load = function(self) end,
  update = function(self, dt)
    for _,i in ipairs(self.Entities) do
      i:update(dt)
    end
  end,
  draw = function(self)
    local drawTable = {}
    for _,entity in ipairs(self.Entities) do
      if entity.draw and entity.pos and entity.pos.z then
        if not drawTable[entity.pos.z] then drawTable[entity.pos.z] = {} end
        table.insert(drawTable[entity.pos.z], entity)
      end
    end
    local ixs = {}
    for k,_ in pairs(drawTable) do
      table.insert(ixs, k)
    end
    table.sort(ixs)
    for _,i in ipairs(ixs) do
      for _,j in ipairs(drawTable[i]) do
        j:draw()
      end
    end
  end,
  quit = function(self)
    for k,v in pairs(self.Entities) do
      v:destroy();
      self.Entities[k] = nil
    end
    self.Entities = {}
  end,
  keypressed = function(self, key)
    for _,v in pairs(self.Entities) do
      if v.keypressed then v:keypressed(key) end
    end
  end,
  keyreleased = function(self, key)
    for _,v in pairs(self.Entities) do
      if v.keyreleased then v:keyreleased(key) end
    end
  end,
}

function Collection:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.Entities = {}
  return o
end

CurrentCollection = nil
SuspendedCollections = {}
LastCollectionId = ""

function loadcollection(c)
  CurrentCollection:quit()
  CurrentCollection = c
  CurrentCollection:load()
end

function sr_current(r) --suspend and replace current collection
  table.insert(SuspendedCollections, CurrentCollection)
  LastCollectionId = CurrentCollection.id
  CurrentCollection = r
  CurrentCollection:load()
end

function resumecollection(id)
  for k,v in ipairs(SuspendedCollections) do
    if v.id == id then
      CurrentCollection:quit()
      CurrentCollection = v
      table.remove(SuspendedCollections, k)
      return nil
    end
  end
  print ("Collection with id "..id.." not found")
end

function swapcollection(id)
  for k,v in ipairs(SuspendedCollections) do
    if v.id == id then
      LastCollectionId = CurrentCollection.id
      local temp = CurrentCollection
      CurrentCollection = v
      SuspendedCollections[k] = temp
      return nil
    end
  end
  print ("Collection with id "..id.." not found")
end
