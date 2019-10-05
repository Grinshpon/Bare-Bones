require "game"
require "util"

local OptionsMenu = Collection:new {id = "optionsmenu"}

local selector = love.graphics.newImage("Images/select.png")

local title = Entity:new {
  id = "title",
  title = "Options",
  draw = function(self)
    love.graphics.setNewFont("Fonts/uni05_53.ttf",100*sratio())
    local offset = 800*sratio()
    love.graphics.printf(self.title, (width-offset)/2, height/6, offset, "center")
    love.graphics.setNewFont("Fonts/uni05_53.ttf",50*sratio())
  end,
}

local menu = Entity:new {
  id = "menu",
  options = {
    "Resolution",
    "Sound",
    "Back",
    "Quit"
  },
  keycase = {
    ["up"] = function(self) if self.selected ~= 1 then self.selected = self.selected-1 end end,
    ["down"] = function(self) if self.selected ~= 4 then self.selected = self.selected + 1 end end,
    ["left"] = function(self)
      if self.selected == 1 then
        for i in ipairs(resolutions) do
          if resolutions[i] == height and i ~= 1 then
            setDims(resolutions[i-1], resolutions[i-1])
            return nil
          end
        end
      elseif self.selected == 2 then
        setVolume(volume-0.1)
      end
    end,
    ["right"] = function(self)
      if self.selected == 1 then
        for i in ipairs(resolutions) do
          if resolutions[i] == height and i ~= 3 then
            setDims(resolutions[i+1], resolutions[i+1])
            return nil
          end
        end
      elseif self.selected == 2 then
        setVolume(volume+0.1)
      end
    end,
    ["return"] = function(self)
      if self.selected == 3 then
        resumecollection(LastCollectionId)
      elseif self.selected == 4 then
        love.event.quit()
      end
    end,
    ["escape"] = function(self)
      self.selected = 3
      self.keycase["return"](self)
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
    love.graphics.print("Use arrow keys to configure", (width-offset)/2, height/3)
    for i in ipairs(self.options) do
      love.graphics.print(self.options[i], (width-offset)/2, height/2+(i-1)*100)
      if self.selected == i then
        love.graphics.draw(selector, (width-offset-8*scale*sratio())/2-100*sratio(), (height-8*scale*sratio())/2+(i-1)*100, 0, scale*sratio(), scale*sratio())
      end
    end
    love.graphics.print("<"..width.."x"..height..">", (width-offset)*(3/4),height/2)
    local vol, svol = volume*10, ""
    for i=1,vol do
      svol = svol.."-"
    end
    love.graphics.print(svol, (width-offset)*(3/4), height/2+100)
  end,
  keypressed = function(self, key)
    match({key},self.keycase)(self)
  end
}

OptionsMenu.load = function(self)
  self:insert(title)
  self:insert(menu)
end

return OptionsMenu
