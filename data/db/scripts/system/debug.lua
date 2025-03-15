--
-- strict.lua
-- checks uses of undeclared global variables
-- All global variables must be 'declared' through a regular assignment
-- (even assigning nil will do) in a main chunk before being used
-- anywhere or assigned to inside a function.
--

function EnableStrict()
  local mt = getmetatable(_G)
  if mt == nil then
    mt = {}
    setmetatable(_G, mt)
  end

  mt.__declared = {}

  mt.__newindex = function (t, n, v)
    if not mt.__declared[n] then
	  local w = debug.getinfo(2, "S").what
	  if w ~= "main" and w ~= "C" then
	    error("assign to undeclared variable '"..n.."'", 2)
	  end
	  mt.__declared[n] = true
    end
    rawset(t, n, v)
  end
    
  mt.__index = function (t, n)
    if not mt.__declared[n] then
	  error("variable '"..n.."' is not declared", 2)
    end
    return rawget(t, n)
  end
end

--
-- forbid float structures
--

cbl.FLOAT2 = nil
cbl.FLOAT3 = nil
cbl.FLOAT4 = nil
cbl.FPOINT2 = nil
cbl.FPOINT3 = nil
cbl.FRECT = nil

cbl.float2 = nil
cbl.float3 = nil
cbl.float4 = nil
cbl.frect = nil
cbl.fpoint2 = nil
cbl.fpoint3 = nil

--
-- debug routines
--

if not debug then
  debug = {}
end

-- dumps a table's keys
debug.dumpt = function(tbl)
  if type(tbl) ~= "table" then
    print("not a table")
    return
  end
  
  local t = {}
  local i = 1
  for k,p in pairs(tbl) do
    t[i] = tostring(k) .. " (" .. type(p) .. ")";
    i = i + 1
  end
  
  table.sort(t)
  for i,p in ipairs(t) do
    print(p)
  end
end

-- dumps the global table keys by type
-- types are 'function', 'table', 'number', 'thread', 'string', 'userdata'
debug.dumpg = function(typ)
  local t = {}
  local i = 1
  for k,p in pairs(_G) do
    if type(p) == typ then
      t[i] = tostring(k)
      i = i + 1
    end
  end
  
  table.sort(t)
  for i,p in ipairs(t) do
    print(p)
  end
end

local function find(tbl, name)
  if not tbl or #tbl < 1 then return false end
  for i,v in ipairs(tbl) do 
    if v.map == name then
      return true,i
    end 
  end
  return false
end

function UnlockMap(name)
  local info = ui.game.GetLocationInfo(name)
  if not info then print('There is not such map !') return end
  
  if info.type == 'mission' then
    local lst = ui.game.LoadUserData("Missions") if not lst then lst = {} end
    local found,idx = find(lst, name)
    if found then
      lst[idx].state = "open"
    else
      table.insert(lst, { map = name, state = "open" } )
    end
    map.SaveUserData("Missions", lst)
    print('Mission unlocked !')
  else
    local lst = ui.game.LoadUserData("SpecialLocations") if not lst then lst = {} end
    local found,idx = find(lst, name)
    if not found then
      table.insert(lst, { map = name } )
    end
    map.SaveUserData("SpecialLocations", lst)
    print('Special location unlocked !')
  end
end

function UnlockMaps()
  local lst = ui.game.LoadUserData("Missions")
  for i,v in ipairs(lst) do
    v.state = "open"
  end
  map.SaveUserData("Missions", lst)
  
  local lst = ui.game.LoadLocationsList()
  map.SaveUserData("SpecialLocations", lst)
end
