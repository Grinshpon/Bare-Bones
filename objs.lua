require "game"
require "util"

local Objs = Object:new {
  items = {},
  rand = function(self)
    if #self.items > 0 then
      return self.items[math.random(1,#self.items)]
    end
  end,
}

return Objs
