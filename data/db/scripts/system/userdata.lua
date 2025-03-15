function InitMissions()
  if not map then return end
  local lst = game.LoadUserData("Missions")
  if not lst or #lst == 0 then 
    local lst = game.LoadMissionsList()
    map.SaveUserData("Missions", lst)
  end
  local loc = game.LoadUserData("SpecialLocations")
  if not loc or #loc == 0 then
    loc = {}
    local mapn = "missions/safari"
    local info = game.GetLocationInfo(mapn)
    table.insert(loc, { map = mapn })
    map.SaveUserData("SpecialLocations", loc)
  end
  if ui.Login.demo then
    local mapn = "missions/dtb"
    local info = game.GetLocationInfo(mapn)
    table.insert(loc, { map = mapn })
    map.SaveUserData("SpecialLocations", loc)
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

function UpdateMisLocTables()
  local this = ui.Victory
  local mapname = game.GetMapName()
  this.map = mapname
  this.next = nil
  this.unlocked_location = nil

  local info = game.GetLocationInfo(mapname) if not info then return end
  this.next = info.next
  
  local saveloc = false
  local loc = game.LoadUserData("SpecialLocations")
  local mis = game.LoadUserData("Missions")
  if not mis then mis = {} end
  
  if info.type == "mission" then
    local found,idx = find(mis, mapname)
    if found then
      mis[idx].state = "done"
    else
      table.insert(mis, { map = mapname, state = "done" })
    end
  end
  if info.open then
    for mapn,state in pairs(info.open) do
      local info1 = game.GetLocationInfo(mapn)
      if info1.type == "mission" then
        found,idx = find(mis, mapn)

        if state == "open" then
          if not found then
            table.insert(mis, { map = mapn, state = "open" })
          else
            if mis[idx].state ~= "done" then
              mis[idx].state = "open"
            end
          end  
        end
        
        if state == "reopen" then
          if not found then
            table.insert(mis, { map = mapn, state = "open" })
          elseif mis[idx].state == "done" then
            mis[idx].state = "reopen"
          end  
        end
      else
        found = find(loc, mapn)
        if not found then
          if not loc then loc = {} end
          table.insert(loc, { map = mapn })
          saveloc = true
          this.unlocked_location = mapn
        end
      end
    end
  end
  map.SaveUserData("Missions", mis)
  if saveloc then
    map.SaveUserData("SpecialLocations", loc)
  end  
end
