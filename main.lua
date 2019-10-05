love.window.setTitle "Bare Bones";
love.graphics.setDefaultFilter("nearest","nearest")
love.graphics.setNewFont("Fonts/uni05_53.ttf",25)

love.window.setFullscreen(false)
love.window.setMode(0,0,{resizable=false})
S_WIDTH, S_HEIGHT = love.graphics.getDimensions()

--global settings
width, height = 0,0
volume = 1

function setVolume(n)
  if n >= 0.0 and n <= 1.0 then
    love.audio.setVolume(n)
    volume = n
  end
end

function setDims(w,h)
  width = w
  height = h
  love.window.setMode(width,height,{resizable = false})
end

resolutions = {800,1080,1920}

if S_HEIGHT < 1080 then
  setDims(800,800)
elseif S_HEIGHT < 1920 then
  setDims(1080, 1080)
else
  setDims(1920, 1920)
end

function sratio()
  return height/S_HEIGHT
end

require "util"
require "game"

local StartMenu = require "start"
local music = nil

function love.load()
  CurrentCollection = StartMenu
  CurrentCollection:load()
  math.randomseed(os.time())
  love.mouse.setVisible(false)
  music = love.audio.newSource("Music/music1.wav", "stream")
  music:setLooping(true)
  music:play()
end

function love.update(dt)
  CurrentCollection:update(dt)
end

function love.draw()
  CurrentCollection:draw()
end

function love.keypressed(key)
  --print(CurrentCollection.id, key, #CurrentCollection.Entities) -- DEBUG
  CurrentCollection:keypressed(key)
end

function love.keyreleased(key)
  CurrentCollection:keyreleased(key)
end

function love.quit()
  CurrentCollection:quit()
end
