function ProtonBlastActionThread(params)
  return function ()
    local explosionName = params.explosion_name or "ProtonBlastExplosion"
    local Beacon = SpawnObject("ProtonBlastBeacon", params.pt, params.faction)
    sleep(4)
    if Beacon then Beacon:Destroy() end
    SpawnObject(explosionName, params.pt, params.faction)
    ShakeCamera(params.pt)
    return "SUCCESS"
  end  
end

function ProtonBlastAction(params)
  CreateThread(ProtonBlastActionThread(params))
end

function SpawnActors(params)
  local obj = params.sound and {}
  SpawnObjects(params.spawn, params.pt, params.faction, obj)
  if params.sound then
    for k,v in pairs(obj) do
      v:PlaySnd(params.sound)
      break
    end
  end
end

function AirAssaultActionThread(AssaultFaction)
  local faction = AssaultFaction
  --print(faction)
  return function ()
    local duration = 30
    local tick = 3
    local min_per_tick = 3
    local max_per_tick = 3
    for cnt = 0, duration, tick do
      local xSleep = SRND(1,3) --tick
      local spawns = SIRND(min_per_tick, max_per_tick)
      local dir = SIRND(-1, 1)
      local prevdir
      for cnt2 = 1, spawns do
        local ptStart, ptBomb, hBomb, ptEnd = GetBomberPoints(faction, dir)
        local n
        if prevdir then
          n = -(prevdir + dir)
        else  
          n = dir + SIRND(0, 1) * 2 - 1
          if n < -1 then n = 1 elseif n > 1 then n = -1 end
        end
        prevdir = dir
        dir = n  
        if not ptStart then break end
        local Bomber = SpawnObject("Bomber", ptStart, faction)
        if not Bomber then break end
        local prm = {}
        prm.h = hBomb;
        prm.pt = ptBomb;
        prm.ptEnd = ptEnd
        Bomber:Execute("PrgAirAssault", prm)
        local slp = SRND(0,1)
        xSleep = xSleep - slp;
        sleep(slp)
      end  
      if xSleep < 0.5 then xSleep = 0.5 end
      sleep(xSleep)
    end
    return "SUCCESS"
  end
end

function AirAssaultAction(params)
  local AssaultFaction = params.faction
  CreateThread(AirAssaultActionThread(AssaultFaction))
end

function InfestThread(params)
  return function()
    local duration = params.infest_duration
    local faction = params.faction
    local hs = {}
    local hsAlive = 0
    local hsMax = params.max_hatchlings
    local hsTime = params.hatchlings_respawn_time
    local hsCount = params.hatchlings_respawn_count
    local eggRate = params.egg_spawn_rate
    local eggs
    local buildings = EnumActors(faction, function(actor) return actor.SetEggsRate end)
    for bi = 1, #buildings do buildings[bi]:SetEggsRate(eggRate) end
    for i = 1, duration do
      eggs = EnumActors(faction, function(actor) return actor:GetID() == "AlienEgg" end)
      for ei = 1, #eggs do
        local egg = eggs[ei]
        if not egg.nextSpawn then
          egg:SetAnim("enraged")
          egg.nextSpawn = SIRND(i + hsTime[1], i + hsTime[2]) - SIRND(1, 3)
          egg.lastSpawn = 0
        end
      end
      for k,v in ipairs(hs) do
        if not actors.Actor.IsValid(v) then
          hs[k] = nil
          hsAlive = hsAlive - 1
        end
      end
      if hsAlive < hsMax then
        table.sort(eggs, function(a, b) return a.lastSpawn < b.lastSpawn end)
        for ei = 1, #eggs do
          local egg = eggs[ei]
          if egg.nextSpawn < i and hsAlive < hsMax then
            local count = SIRND(hsCount[1], hsCount[2])
            local new = SpawnObjects("Hatchling = " .. count, egg:GetPos(), faction, hs)
            hsAlive = hsAlive + new
            egg.lastSpawn = i
          end
          if egg.nextSpawn < i then
            egg.nextSpawn = SIRND(i + hsTime[1], i + hsTime[2])
          end
        end
      end
      sleep(1)
    end
    eggs = EnumActors(faction, function(actor) return actor:GetID() == "AlienEgg" end)
    for ei = 1, #eggs do 
      egg = eggs[ei]
      egg:SetAnim() 
      egg.nextSpawn = nil
    end
    buildings = EnumActors(faction, function(actor) return actor.SetEggsRate end)
    for bi = 1, #buildings do buildings[bi]:SetEggsRate(1) end
    return "SUCCESS"
  end
end

function InfestAction(params)
  CreateThread(InfestThread(params))
end

function MutantsThunder(params)
  SpawnObject("MutantsThunder", params.pt, params.faction)
end
