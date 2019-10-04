require "util"

Entity = Object:new {
  id = "",
  load = function(self, ...) end,
  update = function(self, dt) end,
  draw = nil,
  pos = {x = 0, y = 0, z = 0},
  destroy = function(self) end,
}

Collection = Object:new { -- name? World, Scene, Controller, Collection
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
}

CurrentCollection = nil
