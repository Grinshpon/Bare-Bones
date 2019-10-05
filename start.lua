require "game"
require "util"

local StartMenu = Collection:new {id = "startmenu"}
local OptionsMenu = require "options"

local skull = love.graphics.newImage("Images/skulllogo.png")
local selector = love.graphics.newImage("Images/select.png")

local title = Entity:new {
  id = "title",
  title = "Bare Bones",
  draw = function(self)
    love.graphics.setNewFont("Fonts/uni05_53.ttf",125*sratio())
    local offset = 800*sratio()
    love.graphics.printf(self.title, (width-offset)/2, height/6, offset, "center")
    love.graphics.setNewFont("Fonts/uni05_53.ttf",50*sratio())
    local scale = 15
    love.graphics.draw(skull, (width-16*scale*sratio())/2,(height)/4, 0, scale*sratio(), scale*sratio())
  end,
}

local menu = Entity:new {
  id = "menu",
  options = {
    "Start with nothing...",
    "Options",
    "Quit"
  },
  keycase = {
    ["up"] = function(self) if self.selected ~= 1 then self.selected = self.selected-1 end end,
    ["down"] = function(self) if self.selected ~= 3 then self.selected = self.selected + 1 end end,
    ["return"] = function(self)
      if self.selected == 3 then
        love.event.quit()
      elseif self.selected == 2 then
        sr_current(OptionsMenu)
        --loadcollection(OptionsMenu)
      end
    end,
    default = function() end,
  },
  selected = 1,
  load = function(self)
    self.selected = 1
  end,
  draw = function(self)
    local offset = 400*sratio()
    local scale = 5
    for i in ipairs(self.options) do
      love.graphics.print(self.options[i], (width-offset)/2, height/2+(i-1)*100)
      if self.selected == i then
        love.graphics.draw(selector, (width-offset-8*scale*sratio())/2-100*sratio(), (height-8*scale*sratio())/2+(i-1)*100, 0, scale*sratio(), scale*sratio())
      end
    end
  end,
  keypressed = function(self, key)
    match({key},self.keycase)(self)
  end
}

StartMenu.load = function(self)
  self:insert(title)
  self:insert(menu)
end

return StartMenu
