local astar = require "astar"

function genMap(w,h)
  local map = {lvl = {}, width = w, height = h}
  local rooms = {}
  for i=1, h do
    map.lvl[i] = {}
    for j=1,w do
      map.lvl[i][j] = 0
    end
  end

  local attempts = 0
  for i=1, math.random(2,4)*2 do
    local rw,rh = math.random(3,6), math.random(3,6)
    local rx,ry = math.random(1,w-rw), math.random(1,h-rh)
    while map.lvl[ry][rx] == 1 and attempts < 10 do
      print(attempts)
      rx,ry = math.random(1,w-rw), math.random(1,h-rh)
      attempts = attempts + 1
    end
    attempts = 0
    table.insert(rooms, {rx,ry,rw,rh}) --rooms will be used to generate hallways (and doors)
    for j=ry, ry+rh do
      for k = rx, rx+rw do
        map.lvl[j][k] = 1
      end
    end
  end

  for i=1, math.random(3,6) do
    local rw,rh = math.random(1,4), math.random(1,4)
    local rx,ry = math.random(1,w-rw), math.random(1,h-rh)
    while map.lvl[ry][rx] == 1 and attempts < 10 do
      print(attempts)
      rx,ry = math.random(1,w-rw), math.random(1,h-rh)
      attempts = attempts + 1
    end
    attempts = 0
    for j=ry, ry+rh do
      for k = rx, rx+rw do
        map.lvl[j][k] = 0
      end
    end
  end

  do
    local rx,ry = math.random(1,w), math.random(1,h)
    for i=-1,1 do
      for j = -1,1 do
        if map.lvl[ry+i] then
          map.lvl[ry+i][rx+j] = 1
        end
      end
    end
    map.lvl[ry][rx] = 2 -- start
    table.insert(rooms, {rx-1,ry-1,3,3})
    rx,ry = math.random(1,w), math.random(1,h)
    for i=-1,1 do
      for j = -1,1 do
        if map.lvl[ry+i] then
          map.lvl[ry+i][rx+j] = 1
        end
      end
    end
    map.lvl[ry][rx] = 3 -- finish
    table.insert(rooms, {rx,ry,1,1})
  end

  --connecting rooms
  for _=1, #rooms do
    local c = math.random(2, #rooms)
    local d = math.random(2, #rooms)
    if #rooms == 0 then break end

    local rh = math.random(0,rooms[c][4]-1)
    local rw = 0
    if rh == 0 then
      rw = math.random(0,rooms[c][3]-1)
    end
    local th = math.random(0,rooms[1][4]-1)
    local tw = 0
    if th == 0 then
      tw = math.random(0,rooms[1][3]-1)
    end
    local dh = math.random(0,rooms[d][4]-1)
    local dw = 0
    if dh == 0 then
      dw = math.random(0,rooms[d][3]-1)
    end

    local endpoint = {x=rooms[c][1]+rw, y=rooms[c][2]+rh}
    local dendpoint = {x = rooms[d][1]+dw, y=rooms[d][2]+dh}
    local startpoint = tile(rooms[1][1]+tw, rooms[1][2]+th, endpoint)
    local path = astar.findPath(map, startpoint, endpoint)
    if not path then print "path not found" end
    while path and path.parent ~= nil do
      if map.lvl[path.y][path.x] ~= 2 and map.lvl[path.y][path.x] ~= 3 then
        map.lvl[path.y][path.x] = 1
      end
      path = path.parent
    end
    path = astar.findPath(map, startpoint, dendpoint)
    if not path then print "path not found" end
    while path and path.parent ~= nil do
      if map.lvl[path.y][path.x] ~= 2 and map.lvl[path.y][path.x] ~= 3 then
        map.lvl[path.y][path.x] = 1
      end
      path = path.parent
    end

    --print("c",c,map.lvl[rooms[c][2]][rooms[c][1]])
    table.remove(rooms, c)
    table.remove(rooms, 1)
  end

  local debug = ""
  for i=1, h do
    for j=1, w do
      debug = debug..tostring(map.lvl[i][j])
    end
    debug = debug.."\n"
  end
  print(debug)

  return map.lvl
end


function genObj(lvl, objs)
  local res = {}
  for y in ipairs(lvl) do
    for x in ipairs(lvl) do
      if lvl[y][x] == 1 then
        local chance = math.random(20)
        if chance == 1 then
          if not res[y] then
            res[y] = {}
          end
          res[y][x] = objs:rand()
        end
      end
    end
  end
end
