require "game"
require "util"

local Objs = Object:new {
  objs = {},
  rand = function(self)
    if #self.objs > 0 then
      return self.objs[math.random(1,#self.objs)]
    end
  end,
}

return Objs
