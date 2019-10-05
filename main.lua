love.window.setTitle "LD45";
love.graphics.setDefaultFilter("nearest","nearest")
love.graphics.setNewFont("Fonts/uni05_53.ttf",25)

love.window.setFullscreen(false)
love.window.setMode(0,0,{resizable=false})
S_WIDTH, S_HEIGHT = love.graphics.getDimensions()
width, height = 0,0

if S_HEIGHT < 1080 then
  love.window.setMode(800,800,{resizable = false})
  width, height = 800,800
elseif S_HEIGHT < 1920 then
  love.window.setMode(1080, 1080,{resizable = false})
  width, height = 1080, 1080
else
  love.window.setMode(1920, 1920,{resizable = false})
  width, height = 1920, 1920
end

function sratio()
  return height/S_HEIGHT
end

require "util"
require "game"

local StartMenu = require "start"

function love.load()
  CurrentCollection = StartMenu
  CurrentCollection:load()
end

function love.update(dt)
  CurrentCollection:update(dt)
end

function love.draw()
  CurrentCollection:draw()
end

function love.keypressed(key)
  CurrentCollection:keypressed(key)
end

function love.keyreleased(key)
  CurrentCollection:keyreleased(key)
end

function love.quit()
  CurrentCollection:quit()
end
