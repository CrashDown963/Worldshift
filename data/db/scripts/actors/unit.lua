--
-- Unit specific programs
--

-- Moves actor toward a target (with move min and max range) and checks actor not to get too far
function Unit:MoveSafe(enemy, minMoveRange, maxMoveRange, ptOrigPos, maxReachedRange, callback)
  if not Actor.IsValid(enemy) then return "OUTOFRANGE" end 
  if this:DistTo(enemy) <= maxMoveRange then
    this:StopMoving() 
    return nil
  end

  while true do
    if not Actor.IsValid(this) then return "OUTOFRANGE" end 
    this:CheckAbilities("approach")
    if not Actor.IsValid(enemy) then return "OUTOFRANGE" end 
    if this:DistTo(ptOrigPos) > maxReachedRange + 200 then
      this:StopMoving() 
      return "OUTOFRANGE"
    end
    local d = enemy:DistTo(ptOrigPos)
    if d > maxReachedRange + maxMoveRange then
      this:StopMoving() 
      return "OUTOFRANGE"
    end
    local range = minMoveRange;
    if d - range > maxReachedRange then
      range = d - maxReachedRange
    end
    this:FailMoveOnLoseTarget(1)
    local res = this:MoveTo{enemy, maxRange = range, timeout = 1}
    if res == "IMMOVABLE" then return res end
    if res ~= "TIMEOUT" then break end
    if callback then
      res, res2 = callback()
      if res then return res end
      if res2 then ptOrigPos = res2 end
    end  
  end

  return nil
end  

local function Fight(this)
  local fight_method = this:GetVar("fight_method", "str")
  if fight_method then
    return this[fight_method](this, {h = enemy})
  else
    return this:Fight()
  end
end

-- Fights Enemy till enemy is a valid target, or when moves out of the Fight range!
function Unit:FightEnemy(enemy)
  this:SetPrimaryTarget(nil, enemy)
  
  if Actor.IsValid(enemy) then
    this:StopMoving()
  end
  
  local res

  --while true do 
  
    if (not this.ConsiderAOE) or (not this:ConsiderAOE(enemy)) then
      res = Fight(this)
    end  
  --  if res then break end
  --end

  return res
end  

function Unit:PrgIdle(params)
  if not this:IsValid() then
    print("PrgIdle called for invalid actor!")
    while true do this:Sleep(10) end
    return
  end
  local hOrig = params.hOrig or params.h or map.GetActorByHandle(this:GetVar("idle_follow", "int"))
  local ptOrig = hOrig and hOrig:GetPos() or params.ptOrig or params.pt or this:GetPos()
  local bAI = this:IsAI() and (this:GetFaction() < 10)
  local bPvE = (this:GetFaction() <= 3) and ((map.GetType() == "mission") or (map.GetType() == "special_location"))
  local idle_freq = this:GetVar("idle_freq") or 1
  local waypoint_radius = this:GetVar("waypoint_radius") or 0
  local wander_stay = this:GetVar("wander_stay") or 0
  if wander_stay < idle_freq then wander_stay = idle_freq end
  local wander_start_time
  local ptWander
  local enemy
  --local sight = this:GetSight()

  this:SetPrimaryTarget(params.ptOrig or params.pt, hOrig)

  this.onPrgSave = function()
    params.hOrig = hOrig
    params.ptOrig = ptOrig
    return params
  end

  --if params.ptOrig then -- restoring a program?
  --  this:MoveTo(params.hOrig or params.ptOrig)
  --end
  
  --if not this:HasWeapon() then
  --  while true do this:Idle(5) end
  --end
  
  while 1 do
    if Actor.IsValid(hOrig) then
      ptOrig = hOrig:GetPos()
    elseif hOrig then
      hOrig = nil
      ptOrig = this:GetPos()  
    end
    
    if this:HasWeapon() then
      local minRange, maxRange = this:GetAttackRanges(nil)
      local aggRange
      aggRange = this:GetVar("aggro_range") or 0
      if bPvE and aggRange > 0 and aggRange < 700 then
        aggRange = 700
      end  
      local LFERange = aggRange + maxRange;
      local fZeroAggroTime = this:GetVar("zero_aggro_range_time") -- can be nil
      if fZeroAggroTime then
        local fNow = this:GetTime();
        if fNow < fZeroAggroTime then
          LFERange = maxRange
        else
          this:SetVar("zero_aggro_range_time", nil);
        end
      end     
      if this:IsAI() and (this:GetFaction() < 10) then
        if not bAI then
          return
        end 
        LFERange = -69;
      else
        bAI = false;  
      end  

      local ptLFE
      if (params.dblclk or 0) ~= 0 then
        if hOrig then
          this:SetPrimaryTarget(params.ptOrig or params.pt, hOrig)
        end
        ptLFE = this:GetPos()
        aggRange = 3000
        LFERange = aggRange + maxRange
      else
        ptLFE = ptOrig
      end
      local oldEnemy = enemy
      enemy = this:FindEnemy(ptLFE, LFERange)
      if ((params.dblclk or 0) ~= 0) and enemy and not oldEnemy then
        this:BroadcastTarget(enemy, 1000, 2000, 5);
      end   
            
      if bAI then
        if this:AIConsiderActions(enemy) then return end
      end
    
      while this:FightEnemy(enemy) == "OUTOFRANGE" do 
        local res
        if bAI then
          while true do
            this:CheckAbilities("approach")
            if not Actor.IsValid(enemy) then break end 
            minRange, maxRange = this:GetAttackRanges(enemy)
            res = this:MoveTo{enemy, maxRange = maxRange, timeout = 1}
            if res == "TIMEOUT" then 
              enemy = this:FindEnemy(ptLFE, LFERange)
              if not Actor.IsValid(enemy) then break end 
              if this:AIConsiderActions(enemy) then return end
            else
              break
            end
          end  
          this:StopMoving()
        else
          minRange, maxRange = this:GetAttackRanges(enemy)
          res = this:MoveSafe(enemy, minRange, maxRange, ptLFE, aggRange, 
            function()
              local res2
              if (params.dblclk or 0) ~= 0 then
                if hOrig then
                  this:SetPrimaryTarget(params.ptOrig or params.pt, hOrig)
                end
                ptLFE = this:GetPos()
                res2 = ptLFE
              end
              local new_enemy = this:FindEnemy(ptLFE, LFERange)
              if not new_enemy then return nil, res2 end
              if new_enemy == enemy then return nil, res2 end
              enemy = new_enemy
              return "ENEMY_CHANGED"
            end)
        end  
        if res then
          enemy = nil
          if res == "IMMOVABLE" then
            this:Sleep(1)
          end
          break
        end        
      end
    else -- no weapon
      if (params.dblclk or 0) ~= 0 then
        local rng = this:GetSight()
        local minRange, maxRange = this:GetAttackRanges(nil)
        if maxRange > rng then 
          rng = maxRange
        end  
        enemy = this:FindSurgeonTarget(this:GetPos(), nil, 0, rng, 0, nil, 0, 0)
        if enemy then
          this:Idle(1)
        end
      else  
        enemy = nil  
      end
    end
    if not enemy then
      local pt
      local xRange
      if bAI then
        ptOrig = this:GetAIIdleDest()
        pt = ptOrig
        xRange = 2500
      elseif Actor.IsValid(hOrig) then 
        ptOrig = hOrig:GetPos()
        pt = ptOrig
        xRange = this:GetVar("guard_follow_distance") or 600
      elseif waypoint_radius > 0 then
        if (not ptWander) or (wander_start_time and this:GetTime() >= wander_start_time + wander_stay) then
          ptWander = this:GetRandomPointInRange(ptOrig, waypoint_radius)
          wander_start_time = nil
          local roam = this:GetVar("roam") or 0
          if roam > 0 then ptOrg = ptWander end
        end  
        pt = ptWander
        xRange = 0
      else
        pt = ptOrig  
        xRange = 100
      end
      if this:DistTo(pt) > xRange then
        local res = this:MoveTo{pt, maxRange = xRange - 100, timeout = 1}
        if res == "IMMOVABLE" then
          this:Idle(idle_freq)
        elseif (res ~= "TIMEOUT") and (wander_stay > 0) then
          this:Idle(idle_freq)
        end  
      elseif waypoint_radius <= 0 or wander_stay > 0 then  
        if not wander_start_time then wander_start_time = this:GetTime() end
        this:StopMoving() 
        this:Idle(idle_freq)
      else
        ptWander = nil  
        if bAI or Actor.IsValid(hOrig) then
          this:StopMoving() 
          this:Idle(idle_freq)
        end  
      end
    end  
  end 
end

function Unit:PrgMove(params)
  if (params.dblclk or 0) ~= 0 then
    this:PrgIdle(params)
  elseif params.h then
    Actor.PrgMove(this, params)
    this:PrgIdle(params)
  else
    Actor.PrgMove(this, params)
  end    
end

function Unit:PrgAttack(params)
  if (params.dblclk or 0) ~= 0 then
    this:PrgIdle(params)
    return
  end  
  local h = params.hOrig or params.h
  local pt = params.ptOrig or params.pt
  
  this:SetPrimaryTarget(pt, h)

  this.onPrgEnd = function()
    this:SetPrimaryTarget() 
    this:FailMoveOnLoseTarget(1)
    this:KeepFollowingTarget(0)
  end

  if (params.cancel_on_cc or 0) ~= 0 then
    this.onPrgSave = function()
      params.pt = this:GetPos()
      params.h = nil
      params.ptOrig = nil
      params.hOrig = nil
      return params
    end
  else  
    this.onPrgSave = function()
      params.hOrig = h
      params.ptOrig = pt
      return params
    end
  end  
  
  if not Actor.IsValid(h) then
    this:MoveTo(pt, nil, nil, this:GetSight())
    this.onPrgEnd()
    return;
  end
  
  this:FailMoveOnLoseTarget(0)
  this:KeepFollowingTarget(1)
  local range = this:GetSight()
  minRange, maxRange = this:GetAttackRanges(h)
  if range < maxRange then range = maxRange end
  local timeout = 1
  while Actor.IsValid(h) do
    pt = h:GetPos()
    if timeout > 0 and this:InRange(h, range) then
      this:FailMoveOnLoseTarget(1)
      this:KeepFollowingTarget(0)
      timeout = 0
    end
    this:CheckAbilities("approach")
    if not Actor.IsValid(h) then break end 
    minRange, maxRange = this:GetAttackRanges(h)
    local res;
    if not this:InRange(h, maxRange) then
      res = this:MoveTo{h, maxRange = maxRange, timeout = 1} --timeout = timeout
    end  
    if res ~= "TIMEOUT" then 
      if Actor.IsValid(enemy) then
        this:StopMoving()
      end
      local fres = Fight(this)
      if fres == "NOTARGET" then
        this.onPrgEnd()
        return
      end
      if fres == "NOWEAPON" then
        this:Idle(1)
      end
    end
  end

  this:FailMoveOnLoseTarget(1)
  this:KeepFollowingTarget(0)
  if timeout > 0 and not this:InRange(pt, range) then
    this:MoveTo{pt, maxRange = range}
  end  
end

function Unit:PrgBuild(params)
  local hConstruction = params.h
  local pt, ptIndex
  local res
  local anim

  this.onPrgEnd = function()
    if Actor.IsValid(hConstruction) and ptIndex then 
      this:FreeBuildSpot(hConstruction, ptIndex)
    end
    this:SetAnim()
    this:SetPrimaryTarget() 
  end
  
  while true do 
  
    this:SetPrimaryTarget(nil, hConstruction)
    while Actor.IsValid(hConstruction) do
      pt, ptIndex = this:FindBuildSpot(hConstruction)
      if not pt then return end
      
      this:SetAnim()
      --this:SetAnim("walk_tool")
      if (ptIndex < 0) then
        if this:MoveTo{hConstruction, maxRange=100} then 
        if Actor.IsValid(hConstruction) then 
          this:FreeBuildSpot(hConstruction, ptIndex)
        end
        this:SetAnim()
        this:SetPrimaryTarget()
        break
        end
      else
        if this:MoveTo(pt) then 
          if this:MoveTo{hConstruction, maxRange=100} then
        if Actor.IsValid(hConstruction) then 
          this:FreeBuildSpot(hConstruction, ptIndex)
        end
        this:SetAnim()
        this:SetPrimaryTarget()
        break
          end
        end
      end  

      anim = this:GetBuildAnim(hConstruction, ptIndex)
      if anim then
        this:SetAnim(anim)
      end  
        
      res = this:Build(hConstruction, ptIndex)
      if res == "FINISHED" then
        if Actor.IsValid(hConstruction) then 
          this:FreeBuildSpot(hConstruction, ptIndex)
        end
        this:SetAnim()
        this:SetPrimaryTarget()
        break
      end
    end
    hConstruction = this:FindBuildingToBuild()
    if not hConstruction then
      this:SetAnim()
      this:SetPrimaryTarget()
      --this:Idle(1)
      return
    end
  end
end

function Unit:PrgRepair(params)
  local hBuilding = params.h
  local res
  
  local pt, ptIndex
  
  this.onPrgEnd = function()
    if Actor.IsValid(hBuilding) then
      hBuilding:UnRegisterRepairActor(this)
    end  
    
    -- unlock Repair spot
    if ptIndex and ptIndex > 0 then 
      this:UnlockRepairSpot(hBuilding, ptIndex)
    end  
    
    this:SetAnim()
    this:SetPrimaryTarget()
  end
  
  while true do 
    this:SetPrimaryTarget(nil, hBuilding)
    
    -- Move to close distance to mine!    
    --local res = this:MoveTo{hBuilding, maxRange = 400}    
    --if res then 
    --  return 
    --end
    
    while Actor.IsValid(hBuilding) do
      if params.stop_at then
        if hBuilding:GetHP() >= params.stop_at * hBuilding:GetMaxHP() / 100 then
          break
        end
        if Actor.IsValid(params.h2) and params.h2:FindEnemy(params.h2:GetPos(), params.h2:GetSight()) then
          if this:DistTo(params.h2) > 100 then
            this:MoveTo{params.h2, maxRange = 50}
          end  
          if Actor.IsValid(hBuilding) then
            local i = hBuilding:GetVar("crew_despawned") or 0
            i = i + 1
            hBuilding:SetVar("crew_despawned", i)
          end
          this:Execute("PrgDespawn")
          return
        end
      end
      pt, ptIndex = this:FindRepairSpot(hBuilding)
      if not ptIndex or ptIndex < 1 then break end
      
      --Register repair!
      --this:SetAnim("walk_tool")
      --if this:MoveTo{hBuilding, maxRange=100} then 
      if this:DistTo(pt) > 50 then
        if this:MoveTo{pt, maxRange = 50} then       
          print("Fail")
          if Actor.IsValid(hBuilding) then
            hBuilding:UnRegisterRepairActor(this)
          end  
          this:SetAnim()
        end
      end  
      local dur = this:SetAnim("WORK")
      hBuilding:RegisterRepairActor(this)
      res = this:Repair(hBuilding, dur)
      this:UnlockRepairSpot(hBuilding, ptIndex)
      this:SetAnim()
      ptIndex = nil

      if res == "FINISHED" then 
        if Actor.IsValid(hBuilding) then
          hBuilding:UnRegisterRepairActor(this)
        end  
        break 
      end
      
      if res == "INSUFFICIENT_RESOURCES" then 
        hBuilding:UnRegisterRepairActor(this)
        ui.ErrText:OnEvent("ERR_NOTENOUGHRES")
        this:SetPrimaryTarget()
        return
      end
    end
    if params.stop_at then
      if params.h2 then
        if Actor.IsValid(params.h2) and this:DistTo(params.h2) > 100 then
          this:MoveTo{params.h2, maxRange = 50}
        end  
        if Actor.IsValid(hBuilding) then
          local i = hBuilding:GetVar("crew_despawned") or 0
          i = i + 1
          hBuilding:SetVar("crew_despawned", i)
        end
        this:Execute("PrgDespawn")
        return
      end
    end
    hBuilding = this:FindBuildingToRepair()
    if not hBuilding then
      this:SetAnim()
      this:Idle(1)
    end
  end  
end

function Unit:PrgRepairUnit(params)
  this:PrgRepair(params)
end

function Unit:PrgBeingRepaired(params)
  this:SetInteractive(false)
  this:PlayAnim("repair_down")
  this:SetAnim("repair_idle")
  this:WaitForAction()
  this:PlayAnim("repair_up")
  this:SetAnim()
  this:SetInteractive(true)
end

function Unit:PrgSupply(params)
  local pile, supply, pt = params.int
  local work_anims = { "supply_down_loop", "supply_up_loop" }
  local final_anims = { "supply_down_finish", "supply_up_finish" }

  this.onPrgEnd = function()
    this:SetPrimaryTarget()
  end

  this:SetPrimaryTarget(nil, pile)
  while(1) do
    supply, pt, level = this:FindSupply(pile)
    if not supply then break end
    if this:MoveTo(pt) then break end
    this:SetAnim(work_anims[level])
    if this:UnpackSupply(supply, pt) == "OK" then
			--this:PlayAnim("throw_up")
			this:PlayAnim(final_anims[level])
		end
  end
  this:SetPrimaryTarget()
end

function Unit:PrgSpell(params)
  local spell = params.str or params.spell
  local h = params.h
  local pt = params.pt
  local minRange, maxRange
  if params.maxRange then
    maxRange = params.maxRange
  else
    minRange, maxRange = this:GetAttackRanges(h)
  end
  --if h then print("H:"..h.h) end if pt then print("PT:"..tostring(pt)) end
  if (h or pt) and this:DistTo(h or pt) > maxRange then
    if this:MoveTo(pt, h, nil, maxRange) then return end
  end
  --this:StartActionCooldown(params.action)
  this:CastSpell(h or pt, spell, nil, params.action)
end

function Unit:PrgPickItem(params)
  local h = params.h
  local pt = params.pt
  
  this.onPrgEnd = function()
    if Actor.IsValid(h) then h:SetAnim() end
    this:SetPrimaryTarget()
    this:SetAnim()
  end
  
  this:SetPrimaryTarget(nil, h)
  
  local nCommander = this:GetVar("commander") or 0
  local range
  if nCommander <= 0 then
    range = 500 --!!! hardcoded value
  else
    range = 0
  end

  if Actor.IsValid(h) then
    if this:MoveTo{h, maxRange = range} then
      this:SetPrimaryTarget()
      return 
    end
  elseif pt then
    if this:MoveTo{pt, maxRange = range} then
      this:SetPrimaryTarget()
      return 
    end
  else
    return
  end
  
  if not Actor.IsValid(h) then
    this:SetPrimaryTarget()
    return
  end
  
  if nCommander <= 0 then
    return
  end  
  
  this:SetAnim("pick_item")
  h:SetAnim("activate")
  this:PickItem(h)
  this:SetAnim()
  this:SetPrimaryTarget()
  
  if map[params.end_func] then
    map[params.end_func](this, h)
  end
end

function Unit:PrgUseSwitch(params)
  local h = params.h
  local old_uninterruptible
  
  if (params.uninterruptible or 0) ~= 0 then
    old_uninterruptible = this:GetVar("uninterruptible", "int") or 0
    this:SetVar("uninterruptible", 1)
  end

  this.onPrgEnd = function()
    this:SetPrimaryTarget()
    this:SetAnim()
    if old_uninterruptible then
      this:SetVar("uninterruptible", old_uninterruptible)
    end  
  end

  if not Actor.IsValid(h) then  
    this:SetPrimaryTarget()
    return
  end
  
  this:SetPrimaryTarget(nil, h)
  
  local range = h:GetVar("use_dist", "int") or 0
  if not this:CanUseSwitch(h) then
    range = range + 500 --!!! hardcoded value
  end

  if this:MoveTo(nil, h, range) then 
    this:SetPrimaryTarget()
    return 
  end
  
  if not Actor.IsValid(h) then
    this:SetPrimaryTarget()
    return
  end
  
  this:OperateTarget(h, 0)
  this:SetPrimaryTarget()
  
  --if map[params.end_func] then
  --  map[params.end_func](this, h)
  --end
end

function Unit:PrgOperateTarget(params)
  local h = params.h
  local canceled

  this.onPrgEnd = function()
    if Actor.IsValid(h) then h:SetAnim() end
    this:SetPrimaryTarget()
    if canceled then
      if map[params.end_func] then
        map[params.end_func](this, "CANCELED")
      end
    end
  end
  
  this:SetPrimaryTarget(nil, h)

  if this:MoveTo(nil, h) then 
    this:SetPrimaryTarget()
    return 
  end
  
  if not Actor.IsValid(h) then
    this:SetPrimaryTarget()
    return
  end
  
  h:SetAnim("activate")
  
  local time = 10
  
  if params.time then
    time = params.time
  end
  
  if map[params.start_func] then
    map[params.start_func](this)
  end
  
  canceled = true
  local ret = this:OperateTarget(h, time)
  canceled = nil
  this:SetAnim()
  this:SetPrimaryTarget()
  
  if map[params.end_func] then
    map[params.end_func](this, ret)
  end
end

function Unit:PrgConvertOrePlatform(params)
  local h = params.h
  if this:MoveTo(nil, h, nil, maxRange) then return end
  this:ConvertOrePlatform(h)
end

function Unit:PrgMoveThroughTeleport(params)
  local ptThrough = params.ptThrough
  local ptFinal = params.ptFinal
  local ptOrig = this:GetPos()  
  
  this:MoveTo{ptThrough, timeout = 10}
  if params.h then
    this:ExecuteAction(nil, params)
  else
    this:MoveTo{ptFinal}
  end
end 

function Unit:PrgMadden(params)
  local oldSpeed = this:GetVar("speed")
  local speed = this:GetVar("run_speed") or oldSpeed
  this.onPrgEnd = function()
    this:SetVar("speed", oldSpeed)
    this:SetVar("mad", 0)
    this:CancelRemap()
  end
  if params.speed_multiplier then
    this:SetVar("speed", speed * params.speed_multiplier)
  elseif params.run_speed then
    this:SetVar("speed", run_speed)
  else
    this:SetVar("speed", speed * 2)
  end
  this:SetVar("mad", 1)
  local _, maxRange = this:GetAttackRanges(nil)
  local aggRange
  aggRange = this:GetVar("aggro_range") or 0
  local LFERange = aggRange + maxRange;
  local ptOrig = this:GetPos()
  local range = params.range or 500
  local sleepTime = params.sleep_time or 0.1
  local wander = params.wander or 0
  local attack_count = params.attack_count
  local attack_chance = params.attack_chance
  this:RemapAnim("walk", "run")
  while true do
    local startPoint = (wander ~= 0) and this:GetPos() or ptOrig
    local pt = this:GetRandomPointInRange(startPoint, range)
    if pt then this:MoveTo{pt} end
    if attack_count and this:HasWeapon() then
      local attack = attack_chance and map.SIRND(0, 100) < attack_chance
      if attack then
        enemy = this:FindNearestEnemy(ptOrig, LFERange)
        if enemy then
          this:SetPrimaryTarget(nil, enemy)
          local hits = map.SIRND(1, attack_count)
          while hits ~= 0 do
            if this:Fight(true) == "OUTOFRANGE" then
              if this:MoveTo{enemy, maxRange = maxRange, timeout = 1} == "IMMOVABLE" then
                this:Idle(1)
              end
            end
            hits = hits - 1
          end
        end
      end
    end
    this:Sleep(sleepTime)
  end
end

function Unit:PrgStun(params)
  this:FaceTo("stop");
  while true do
    this:Sleep(1)
  end
end

function Unit:PrgFreeze(params)
  this:FaceTo("stop");
  while true do
    this:Freeze(1000)
  end
end

function Unit:SurgeonBehave(pt, h, primary_heal_threshod, secondary_heal_threshold, bAggresive)
  local bandage_range = this:GetVar("bandage_range")
  local bandage_amount = this:GetVar("bandage_amount")
  local relief_psicost = this:GetVar("relief_psicost")
  local relief_amount = (this:GetVar("relief_duration") or 0) * (this:GetVar("relief_healpersec") or 0)
  local mend_power = this:GetVar("mend_power")
  local mend_heal = this:GetVar("mend_heal")
  local attack_range = this:GetVar("range")
  local giveup_range = 5000
  local arrived = false
  local follow_threshold = this:GetVar("bandage_follow_range")
  local hHealDest
  local xHealAmount 
 
  local oldPrgEnd = this.onPrgEnd
  this.onPrgEnd = function()
    if hHealDest then
      Actor.AddToVar(hHealDest, "incoming_heal", -xHealAmount)
      hHealDest = nil
      xHealAmount = 0
    end
    if oldPrgEnd then
      oldPrgEnd()
    end  
  end

  while true do
    local dist_to_target
    if this:IsAI() then
      pt = this:GetPos()
      h = this:FindSurgeonAIFollowTarget()
    end
    if Actor.IsValid(h) then
      if bAggresive then
        pt = h:GetPos()
      end
      dist_to_target = this:DistTo(h)
    else   
      if not pt then
        if not h then
          pt = this:GetPos()
        else
          this:Idle(1)
          return
        end  
      end  
      dist_to_target = this:DistTo(pt)
    end  
    if arrived and (dist_to_target > giveup_range) then
      this:Idle(1)
      return
    end  
    local bSleep = true
    if dist_to_target > follow_threshold and not bAggresive then
      this:FailMoveOnLoseTarget(1)
      this:KeepFollowingTarget(1)
      if Actor.IsValid(h) then
        bSleep = false
        this:MoveTo{h, maxRange = follow_threshold, timeout = 1}
        if not Actor.IsValid(h) then
          if not pt then
            this:Idle(1)
            return
          end  
          this:MoveTo{pt, maxRange = 0, timeout = 1}
          dist_to_target = this:DistTo(pt)
        else
          dist_to_target = this:DistTo(h)
        end  
      else
        this:MoveTo{pt, maxRange = 0, timeout = 1}
        dist_to_target = this:DistTo(pt)
      end  
    end
    if dist_to_target <= follow_threshold or bAggresive then
      bSleep = false
      if dist_to_target <= follow_threshold then
        arrived = true
        bAggresive = false
      end  
      --follow_threshold = 800 --!!! hardcoded value
      local hDest
      local CDEnd = this:GetCooldownEndTime("CastBandage")
      local now = this:GetTime()
      if Actor.IsValid(hHealDest) then
        Actor.AddToVar(hHealDest, "incoming_heal", -xHealAmount)
      end
      local canRelief = this:IsAI() and (this:GetPower() >= relief_psicost)
      local canMend = this:IsAI() and (this:GetPower() >= mend_power)
      local canBandage = (CDEnd <= 0) or (CDEnd - now <= 0.5)
      local ptSrc
      local hSrc
      if arrived then
        ptSrc = pt
        hSrc = h
      else
        ptSrc = this:GetPos()
        hSrc = nil
      end
      if canBandage or canMend or canRelief then
        hDest = this:FindSurgeonTarget(ptSrc, hSrc, follow_threshold, attack_range, bandage_range, hSrc, 10, 40)
      else
        hDest = this:FindSurgeonTarget(ptSrc, hSrc, follow_threshold, attack_range, bandage_range, hSrc, 0, 0)
        if (not hDest) and bAggresive then
          hDest = this:FindSurgeonTarget(ptSrc, hSrc, follow_threshold, attack_range, bandage_range, hSrc, 10, 40)
        end
      end  
      if Actor.IsValid(hHealDest) then
        if hDest == hHealDest then
          Actor.AddToVar(hHealDest, "incoming_heal", xHealAmount)
        else
          hHealDest = nil
          xHealAmount = 0
        end
      end
      if Actor.IsValid(hDest) then
        if this:IsEnemy(hDest) then
          if this:InRange(hDest, attack_range) then
            this:StopMoving()
            this:SetPrimaryTarget(nil, hDest)
            this:Fight()
          else
            this:FailMoveOnLoseTarget(1)
            this:KeepFollowingTarget(0)
            this:MoveTo{hDest, maxRange = attack_range, timeout = 1}
          end  
        else
          if this:InRange(hDest, bandage_range) then
            this:StopMoving()
            local anim = nil
            local spell = "CastBandage"
            local amount = bandage_amount
            if canRelief and this:ConsiderRelief(hDest) then
              spell = "relief"
              amount = relief_amount / 2
            elseif hDest == this then 
              anim = "self"
            elseif canMend then
              local hp = hDest:GetHP()
              local max = hDest:GetMaxHP()
              if (max - hp > mend_heal) or (hp <= max / 2) then
                spell = "mend"
                amount = mend_heal / 2 --!!!
              end
            end
            if not Actor.IsValid(hHealDest) then
              hHealDest = hDest
              xHealAmount = amount
              Actor.AddToVar(hHealDest, "incoming_heal", xHealAmount)
            end
            if spell == "mend" then
              local prm = { h = hDest }
              this:PrgMend(prm)
            elseif spell == "relief" then  
              local prm = { pt = hDest:GetPos() }
              this:PrgRelief(prm)
            elseif this:CastSpell(hDest, spell, anim) == "COOLDOWN" then
              this:Sleep(CDEnd - now)
            end
            if Actor.IsValid(hHealDest) then
              Actor.AddToVar(hHealDest, "incoming_heal", -xHealAmount)
              hHealDest = nil
              xHealAmount = 0
            end           
          else
            this:FailMoveOnLoseTarget(1)
            this:KeepFollowingTarget(0)
            hHealDest = hDest
            xHealAmount = bandage_amount
            Actor.AddToVar(hHealDest, "incoming_heal", xHealAmount)
            this:MoveTo{hDest, maxRange = bandage_range, timeout = 3}
          end  
        end  
      else
        this:FailMoveOnLoseTarget(1)
        this:KeepFollowingTarget(1)
        if not arrived then
          if Actor.IsValid(h) then
            this:MoveTo{h, maxRange = follow_threshold, timeout = 1}
          else
            this:MoveTo{pt, maxRange = 0, timeout = 1}
          end  
        elseif Actor.IsValid(h) then
          this:Idle(1)
        elseif CDEnd > 0 then
          this:Sleep(CDEnd - now)
        else
          this:MoveTo{pt, maxRange = 0, timeout = 1}
        end  
      end
    end  
    if bSleep then
      this:Idle(1)
    end
  end
end

function Unit:PrgResurectCommander(params)
  local pt = params.h:GetPos()
  if this:MoveTo{params.h, maxRange = 1000} then return end

  this.onPrgEnd = function()
    this:SetAnim()
  end
  
  this:FaceTo(params.h)
  this:SetAnim("cast_prepare")
  this:Sleep(this:GetVar("resurect_duration"))
  this:ResurectCommander(params.h)
  map.PlayAnim(pt, "TriadSeparate")
  this:PlayAnim("cast_finish")
  this:DrainPower(this:GetVar("resurect_psicost"))
end

function Unit:PrgMend(params)
  local range = this:GetVar("mend_range")
  local maxrange = this:GetVar("mend_max_range")
  local duration = this:GetVar("mend_duration") or 1
  local spawn_time = this:GetVar("mend_beam_spawn_time") or 1
  local beams = duration / spawn_time
  local attach = this:GetVar("mend_attach", "str")
  local attach_point = this:GetVar("mend_source", "str")
  local hUnit = params.h
  
  local oldPrgEnd = this.onPrgEnd
  this.onPrgEnd = function()
    this:SetPrimaryTarget()
    this:SetAnim()
    if attach_point and attach then 
      this:RemoveAttachments(attach_point) 
    end
    
    this:ClearBeams()
    if oldPrgEnd then
      oldPrgEnd()
    end  
  end
  
  --Move to!  
  this:KeepFollowingTarget(0)
  if range then 
    if this:MoveTo{hUnit, maxRange = range} then return end
  else 
    if this:MoveTo{hUnit} then return end
  end

  -- Get mana!
  if not this:DrainPower(this:GetVar("mend_power")) then return end
  this:StartActionCooldown(params.action)
  this:SetAnim("cast_mend_channeling")
  
  -- Attach!
  if attach_point and attach then 
    this:AttachAnim(attach_point, attach)
  end
  
    
  for i = 1,beams do
  
    -- face target
    this:FaceTo(hUnit)
    
    local Dist = this:DistTo(hUnit)
    
    -- bigger distance?
    if not Dist or Dist > maxrange then break end
    
    -- restore
    if not this:Mend(hUnit) then break end
    this:Sleep(spawn_time)
  end
  
  this.onPrgEnd()
  this.onPrgEnd = oldPrgEnd
  
end

function Unit:PrgHeal(params) -- pt - point, h - actor, dblclk - double clicked
  local pt = params.pt
  local h = params.h

  this.onPrgEnd = function()
    this:KeepFollowingTarget(0)
  end

  this:SurgeonBehave(Actor.GetPos(h), h, 10, 30, (params.dblclk or 0) ~= 0)
end

function Unit:SayTo(unit, text_key, priority, timeout)
  this:FaceTo(unit:GetPos())
  unit:FaceTo(this:GetPos())
  this:Say(text_key, sound, priority, timeout)
end

function Unit:Say(text_key, priority, timeout)
  if not Actor.IsValid(this) then
    print("Called Say(" .. tostring(text_key) .. ") on dead actor!")
    return
  end
  local _priority = priority or 2
  local sound = "data/speech/pve/" .. map.GetName()

  if map.GetType() == "special_location" and this:GetFaction() < 4 then
    local id = this:GetID()
    if id == "Commander" or id == "HighPriest" or id == "Master" then
      sound = sound .. "/" .. id
    end
  end
  
  sound = sound .. "/" .. text_key .. ".wav"
  
  local text = ui.TEXT(map.GetName() .. "." .. text_key)
  local name = ui.TEXT((this:GetVar("name_var", "str") or this:GetName()) .. ".name")
  local icon = {
    row = this:GetVar("conv_icon_row", "int") or 1,
    col = this:GetVar("conv_icon_col", "int") or 1
  }
  ui.Conversation:QueueLine(this.h, icon, name, text, _priority, sound, timeout)
end

function Unit:SayPrm(params)
  this:Say(params.text_key, params.priority, params.timeout)
end

function Unit:SpawnPrm(params)
  map.SpawnObject(params.spawn1, this:GetPos(), this:GetFaction())
  map.SpawnObject(params.spawn2, this:GetPos(), this:GetFaction())
end

function Unit:PrgConfuse(params)
  local hTarget = params.h2
  local ptOrig = this:GetPos()
  
  local effect = this:GetEffectIdByName("Confuse") 
    or this:GetEffectIdByName("E_multiconfuse") 
    or this:GetEffectIdByName("S_confuse")
  
  this.onPrgEnd = function()
    this:RemoveEffect(effect)
  end
  
  while true do 
    if not Actor.IsValid(hTarget) then
      return
    end
    
    local res = this:FightEnemy(hTarget)
    if res == "OUTOFRANGE" then 
      minRange, maxRange = this:GetAttackRanges(hTarget)
      local range = 2000 -- hardcoded value!
      if maxRange > range then range = maxRange end
      local dist = hTarget:DistTo(ptOrig)
      if dist > range then
        return
      end  
      this:CheckAbilities("approach")
      this:FailMoveOnLoseTarget(1)
      this:KeepFollowingTarget(0)
      res = this:MoveTo{hTarget, maxRange = maxRange, timeout = 1}
      if res and (res ~= "TIMEOUT") then
        return 
      end
    elseif res then
      return  
    end
  end    
  
end

function Unit:PrgUseNearestObject(params)
  params.h = map.GetNearestFromGroup(params.group, this:GetPos())
  if not Actor.IsValid(params.h) then
    print("PrgUseNearestObject: Couldn't find " .. (params.group or "nil"))
    return 
  end
  this:PrgSpell(params)
end

function Unit:PrgUseNamedSwitch(params)
  params.h = map.GetNamedObject(params.switch)
  if not Actor.IsValid(params.h) then
    print("PrgUseNamedSwitch: Couldn't find " .. (params.switch or "nil"))
    return 
  end
  this:PrgUseSwitch(params)
end

function Unit:Shift(params)
  this:SetPrimaryTarget(nil, params.h)
  this:SetPos(params.pt)
  this:FaceTo("reset")
  this:FaceTo(params.h)
end

function Unit:PrgUnholyPower(params)
  this.onPrgEnd = function()
    this:ActivateController("StoneGhostUnholyPowerAura", 0)
    this:SetAnim()
  end
  local duration = this:GetVar("unholy_power_duration")
  this:ActivateController("StoneGhostUnholyPowerAura", 1)
  this:SetAnim("cast_preparation", duration)
  for i = 1,duration do
    this:Sleep(1)
    this:DrainPower(0)
    this:CreateReact("drainpsy_small")
  end
  this.onPrgEnd()
end

function Unit:PrgRepairDrones(params)
  this.onPrgEnd = function()
    this:SetAnim()
  end
  this:RepairDrones()
  this:PlayAnim("cast_repairdrones_channeling")
end

function Unit:PrgUpgrade(params)
  local duration = params.int
  local type = params.str
  this:Upgrade(type)
end

function Unit:PrgDefaultAreaAction(params)
  if this:MoveTo{params.h} then return end
  this:DoDefaultAreaAction(params.h)
end

function Unit:CreateEffect(params)
  this:SpawnEffect(params.effect_id)
end

function Unit:PrgCreateEffect(params)
  local minRange, maxRange = this:GetAttackRanges()
  if this:MoveTo{params.pt, maxRange = maxRange} then return end
  this:StartActionCooldown(params.action)
  this:SpawnActionEffect(params.action, params.pt)
end

function Unit:PrgRejuvenation(params)
  local pt = params.pt
  if this:MoveTo(pt, nil, nil, this:GetVar("rejuvenation_range")) then return end
  this:CastSpell(pt, "CastRejuvenation", nil, params.action)
end

function Unit:PrgRelief(params)
  local minRange, maxRange = this:GetAttackRanges()
  if this:MoveTo{params.pt, maxRange = maxRange} then return end
  this:FaceTo(params.pt)
  this:PlayAnim("cast_relief")
  local o = this:FindActorByVar("relief_cell_creator", this.h)
  if o then o:Die() end
  o = map.CreateObject("ReliefCell", params.pt, this:GetFaction(), this)
  if o then o:SetVar("relief_cell_creator", this.h) end
  this:DrainPower(this:GetVar("relief_psicost"))
  this:StartActionCooldown(params.action)
end

function Unit:PrgTeleport(params)
  local h = params.h
  if h:GetTeleportGuest() then return end
  if this:MoveTo{h:GetPos(), maxRange = 200} then return end
  if h:GetTeleportGuest() then return end
  h:EnterTeleport(this)
  this.onPrgEnd = function() h:LeaveTeleport(this) end
  if this:MoveTo{h:GetPos(), maxRange = -1} then return end
  while true do
    this:Sleep(1)
  end
  this.onPrgEnd = nil
end

function Unit:PrgTeleportOfficer(params)
  this.onPrgEnd = function() this:SetAnim() end
  this:SetAnim("teleport_officer")
  if not this:TeleportOfficer(params.int, params.str) and params.sound then
    this:PlaySnd(params.sound)
  end
end

function Unit:PrgFear(params)
  local oldSpeed = this:GetVar("speed")
  if not oldSpeed then
    while true do
      this:Sleep(1)
    end
  end
  local speed = this:GetVar("run_speed") or oldSpeed
  this.onPrgEnd = function()
    this:SetVar("speed", oldSpeed)
    this:CancelRemap()
  end
  if params.speed_multiplier then
    this:SetVar("speed", speed * params.speed_multiplier)
  elseif params.run_speed then
    this:SetVar("speed", run_speed)
  else
    this:SetVar("speed", speed * 2)
  end
  local ptOrig = this:GetPos()
  local range = params.range or 500
  local sleepTime = params.sleep_time or 0.1
  local wander = params.wander or 0
  this:RemapAnim("walk", "run")
  while true do
    local startPoint = (wander ~= 0) and this:GetPos() or ptOrig
    local pt = this:GetRandomPointInRange(startPoint, range)
    if pt then this:MoveTo{pt} end
    this:Sleep(sleepTime)
  end
end

function Unit:PrgFortify(params)
  local h = params.h if not h or not h:IsValid() then return end
  local pos = h:GetPos()

  if this:MoveTo{h} then return end
  if this:EnterBuilding(h) then return end
    
  this.onPrgEnd = function()
    this:SetPrimaryTarget() 
  end
  
  while true do
    local enemy = this:FindEnemy(pos)
    this:SetPrimaryTarget(nil, enemy)
    this:Fight(true)
    this:Idle(1)
  end
end

function Unit:PrgTransportFood(params)
  local h = params.h
  if not this:MoveTo{h} then 
    this:DeployFood()
  end  
  
  this:Destroy()
end

function Unit:PrgBreed(params)
  local pt = params.pt
  if this:MoveTo(pt, nil, nil, this:GetVar("breed_range")) then return end
  this:FaceTo(pt)
  local power = this:GetVar("breed_power") or 0
  if power > 0 and not this:DrainPower(power) then return end
  if params.sound then this:PlaySnd(params.sound) end
  local faction = this:GetFaction();
  local min = this:GetVar("breed_min_count") or 1
  local max = this:GetVar("breed_max_count") or 1
  local cnt = map.SIRND(min, max)
  map.SpawnObjects("Hatchling = " .. cnt, pt, faction);
  this:StartActionCooldown(params.action)
end

function Unit:OnShifterShieldFullAbsorb(params)
  this:ActivateAllyController("shifter_shield", this:GetSight());
end

function Unit:EggSpawnHatchlings()
  local cnt = map.SIRND(1, 2)
  map.SpawnObjects("Hatchling = " .. cnt, this:GetPos(), this:GetFaction());
end

function Unit:PrgHealingWave(params)
  local pt = params.pt
  this:CastSpell(pt, "CastHealingWave")
end

function Unit:PrgHowl(params)
  local old_model = this:GetVar("model", "str")
  if not old_model then return end
  local ghost_model = params.ghost_model
  
  this.onPrgEnd = function()
    this:RemoveEffect("HowlHeal")
    this:RemoveEffect("HowlArmor")
    if ghost_model then this:SetModel(old_model) end
    this:SetAnim()
  end

  local howl_duration = params.howl_duration or 20
  local ghost_model = params.ghost_model
  local cast_anim = params.cast_anim
  local howl_anim = params.howl_anim

  if cast_anim then
    if ghost_model then this:SetModel(ghost_model) end
    local animLength, actionLength = this:GetAnimLength(cast_anim)
    if not animLength then animLength = 1 end
    this:SetAnim(cast_anim)
    if not actionLength then actionLength = animLength / 2 end
    this:Sleep(actionLength)
    this:SpawnEffect("HowlFear")
    if actionLength then this:Sleep(animLength - actionLength) end
    if howl_anim then this:SetAnim(howl_anim) end
    this:SpawnEffect("HowlHeal", this)
    this:SpawnEffect("HowlArmor", this)
  end
  this:Idle(howl_duration)
  this.onPrgEnd()
end

function Unit:PrgMakeStructure(params)
  local hXeno = params.h
  local struct = params.id
  local time = params.time or 1
  local pt = params.pt
  if Actor.IsValid(hXeno) then
    if (this:GetVar("can_build", "int") or 0) == 0 then
      this:MoveTo{hXeno, maxRange = 600}
      return
    end
    if this:MoveTo{hXeno, maxRange = 450} then return end
  elseif pt then
    if this:MoveTo{pt, maxRange = 450} then return end
  else
    return
  end
  if not Actor.IsValid(hXeno) then return end
  this:FaceTo(hXeno)
  if (hXeno:GetVar("construction") or 0) > 0 then return end
  this.onPrgEnd = function() this:SetAnim() end
  this:SetAnim("plant_structure")
  this:Sleep(time)
  if not Actor.IsValid(hXeno) then return end
  if (hXeno:GetVar("construction") or 0) > 0 then return end
  map.SpawnConstruction(this:GetFaction(), struct, hXeno:GetPos())
end

function Unit:BioCycle(params)
  local commander = this:GetCommander()
  if not commander then return end
  local _, range = commander:GetAttackRanges()
  if this:DistTo(commander) > range then return end
  local chance = this:GetVar("bio_cycle_chance") or 0
  if not chance then return end
  if map.SIRND(0, 99) > chance then return end
  map.SpawnObjects("Trisat = 1", commander:GetPos(), commander:GetFaction());
end

function Unit:BioSplit(params)
  local chance = this:GetVar("bio_split_chance") or 0
  if not chance then return end
  if map.SIRND(0, 99) > chance then return end
  local num = map.SIRND(2, 3)
  map.SpawnObjects("Hatchling = "..num, this:GetPos(), this:GetFaction());
end

function Unit:PrgAirAssault(params)
  if this:GetFaction() == map.GetPlayerFaction() then
    map.CreateMapPing(params.pt)
  end
  this:FailMoveOnLoseTarget(0)
  this:KeepFollowingTarget(1)
  this:MoveTo(params.pt, params.h)
  this:KeepFollowingTarget(0)
  this:MoveTo{params.ptEnd, maxRange = 3000 }
  this:Destroy()
end

function Unit:PrgMorphOverseer(params)
  local currentForm = this:GetVar("current_form", "str")
  if currentForm == "field" then
    local powerModel = this:GetVar("power_model", "str")
    if powerModel then
      this:SetModel(powerModel)
      this:SetVar("current_form", "power")
      this:SetVar("name_var", "power_name")
      this:SetWeapon("power_weapon")
      this:ActivateController("plasma_shield", 0)
      this:ActivateController("plasma_shield", 0)
      this:ActivateController("OverseerChargingFieldAura", 1)
      this:EnableAbility("OverseerPlasmaShieldAbi", 0)
      this:EnableAbility("OverseerChargingFieldAbi", 1)
      local power_icon = this:GetVar("power_icon", "str")
      if power_icon then this:SetVar("icon", power_icon) end
    end
  else
    local fieldModel = this:GetVar("field_model", "str")
    if fieldModel then
      this:SetModel(fieldModel)
      this:SetVar("current_form", "field")
      this:SetVar("name_var", "field_name")
      this:SetWeapon("field_weapon")
      this:ActivateController("plasma_shield", 1)
      this:ActivateController("OverseerChargingFieldAura", 0)
      this:EnableAbility("OverseerPlasmaShieldAbi", 1)
      this:EnableAbility("OverseerChargingFieldAbi", 0)
      local field_icon = this:GetVar("field_icon", "str")
      if field_icon then this:SetVar("icon", field_icon) end
    end
  end
  if this:GetFaction() == map.GetPlayerFaction() and this:IsSelected() then
    this:SelectMe(false)
    this:SelectMe(true)
  end
  
  if this:GetFaction() == map.GetPlayerFaction() then
    this:SelectMe(false)
    this:SelectMe(true)
  end
  
  if params.sound then
    this:PlaySnd(params.sound)
  end
end

function Unit:AIConsiderActions(enemy)
  local actBuild = this:FindActionByPrg("PrgMakeStructure")
  if actBuild and (this:GetVar("can_build", "int") or 0) ~= 0 then
    local hXeno = map.FindNearestXenolite(this:GetPos(), 3000)
    if hXeno then
      if this:ExecuteAction(actBuild, { h = hXeno }) then return true end
    end
  end
end

function Unit:SpiderEggAlert(params)
  this:ActivateController("auto_die", 1)
end

function Unit:SpiderEggRetreat(params)
  this:ActivateController("auto_die", 0)
end

function Unit:PrgChargeAcidGeyser(params)
  local geyser_name = this:GetVar("geyser", "str")
  if not geyser_name then
    print("Variable 'geyser_name' not defined!")
    this:PrgIdle(params)
    return
  end
  local pos = map.GetNamedObjectPos(geyser_name)
  if not pos then
    print("Object '" .. geyser_name .. "' not found!")
    this:PrgIdle(params)
    return
  end
  this:MoveTo{pos, maxRange = 200}
  map.ChargeAcidGeyser(geyser_name)
  this:Die()
end

function Unit:PrgCloneTarget(params)
  local clones = {}
  map.SpawnObjects(params.h:GetVar("id", "str") .. " = 1", params.pt, params.h2:GetFaction(), clones)
  local clone = nil
  for _, c in ipairs(clones) do
    if c ~= nil then
      clone = c
      break
    end
  end
  if clone and params.clone_react then clone:CreateReact(params.clone_react) end
  if params.creator_react then params.h2:CreateReact(params.creator_react) end
  if params.target_react then params.h:CreateReact(params.target_react) end
end

function Unit:AnimateScale(params)
  map.AnimateScale(this, params.target_scale, params.animate_time, params.duration)
end

-- Renegade dominator's siege program
function Unit:PrgSiege(params)
  local siegeAnimLength = this:GetAnimLength("siege_start")
  local foot1Time = this:GetAnimKeyTime("siege_start", "Foot02_down")
  local foot2Time = this:GetAnimKeyTime("siege_start", "Foot01_down")
  local shoot1Time = this:GetAnimKeyTime("siege_shoot_1", "action")
  local shoot2Time = this:GetAnimKeyTime("siege_shoot_2", "action")
  local shoot1Length = this:GetAnimLength("siege_shoot_1")
  local shoot2Length = this:GetAnimLength("siege_shoot_2")
  local firstEnemyFaced = false
  local searchRange = this:GetVar("sight_in_combat") or 5000
  local leftHand = true
  
  while true do
    local enemy = this:FindEnemy(this:GetPos(), searchRange, 40, true)
    
    if not firstEnemyFaced and enemy then
      this:FaceTo("reset")
      this:FaceTo(enemy)
      firstEnemyFaced = true
      this:SetAnim("siege_start")
      this:Sleep(foot1Time)
      map.SpawnObject("PuffDust", this:GetNodePos("pt_footprint02"))
      this:Sleep(foot2Time - foot1Time)
      map.SpawnObject("PuffDust", this:GetNodePos("pt_footprint01"))
      this:Sleep(siegeAnimLength - foot2Time)
      this:SetAnim("siege_shoot_idle")
      enemy = this:FindEnemy(this:GetPos(), searchRange, 40, true)
    end
    
    local nearestEnemy, range = this:FindNearestEnemy(this:GetPos(), searchRange)
    
    if range and range < 1000 then
      if firstEnemyFaced then
        this:PlayAnim("stand")
      end
      this:SetAnim()
      return
    end
    
    if enemy then
      local action = shoot1Time
      local wait = shoot1Length - shoot1Time
      local shootNode = "pt_shoot_1"
      local anim = "siege_shoot_1"
      
      if leftHand then
        action = shoot2Time
        wait = shoot2Length - shoot2Time
        shootNode = "pt_shoot_2"
        anim = "siege_shoot_2"
      end
      
      this:SetAnim(anim)
      this:Sleep(action)
      
      local projectileName = this:GetVar("siege_projectile", "str")      
      this:CreateProjectile(projectileName, enemy, shootNode)
      this:Sleep(wait)
      this:SetAnim("siege_shoot_idle")
      leftHand = not leftHand
    else
      if firstEnemyFaced then
        this:PlayAnim("stand")
      end
      this:SetAnim()
      if not nearestEnemy then
        local roam = this:GetVar("roam") or 0
        local noEvade = this:GetVar("no_evade") or 0
        if roam > 0 or noEvade > 0 then
          local path = this:GetVar("path", "str")
          if path then this:SetVar("path", path) end
          this:Execute("PrgIdle")
        else  
          this:Execute("PrgEvade")
        end
      end
      return
    end
    
    this:Sleep(0.3)
  end
end

function Unit:PrgScatterAllies(params)
  this:ScatterAlliesInRange(params.range, params.unit_id, params.sub_range, params.sub_range_unit_count)
end

function Actor:PrgDeployTurrets(params)
  local animHandle
  
  this.onPrgEnd = function()
    if animHandle then
      map.StopAnim(animHandle)
    end
  end
  
  _, _, animHandle = map.PlayAnim(this:GetPos(), this:GetVar("upgrading_anim", "str"))
  this:Sleep(this:GetVar("spawn_time"))
  map.StopAnim(animHandle)
  _, _, animHandle = map.PlayAnim(this:GetPos(), this:GetVar("upgraded_anim", "str"))
  this:Sleep(1)
  map.SpawnObject(this:GetVar("turret_to_spawn", "str"), this:GetPos(), this:GetFaction())
  this:Destroy()
end

function Unit:PrgRepairing(params)
  local hBuilding = params.h
  local res
  local pt, ptIndex
  this.onPrgEnd = function()
    this:SetAnim()
    this:SetPrimaryTarget()
  end
  
  while true do 
    this:SetPrimaryTarget(nil, hBuilding)    
    while Actor.IsValid(hBuilding) do
      if params.stop_at then
        if hBuilding:GetHP() >= params.stop_at * hBuilding:GetMaxHP() / 100 then
          break
        end
        if Actor.IsValid(params.h2) and params.h2:FindEnemy(params.h2:GetPos(), params.h2:GetSight()) then
          if this:DistTo(params.h2) > 100 then
            this:MoveTo{params.h2, maxRange = 50}
          end 
        end
      end
      pt, ptIndex = this:FindRepairSpot(hBuilding)
      if not ptIndex or ptIndex < 1 then break end
      if this:DistTo(pt) > 50 then
        if this:MoveTo{pt, maxRange = 50} then       
          print("Fail")
          if Actor.IsValid(hBuilding) then
            hBuilding:UnRegisterRepairActor(this)
          end  
          this:SetAnim()
        end
      end  
      local dur = this:SetAnim("WORK")
      hBuilding:RegisterRepairActor(this)
      res = this:Repair(hBuilding, dur)
      this:UnlockRepairSpot(hBuilding, ptIndex)
      this:SetAnim()
      ptIndex = nil

      if res == "FINISHED" then 
        if Actor.IsValid(hBuilding) then
          hBuilding:UnRegisterRepairActor(this)
        end  
        break 
      end
    end
    if params.stop_at then
      if params.h2 then
        if Actor.IsValid(params.h2) and this:DistTo(params.h2) > 100 then
          this:MoveTo{params.h2, maxRange = 50}
        end 
      end
    end
    hBuilding = this:FindBuildingToRepair()
    if not hBuilding then
      this:SetAnim()
      this:Idle(1)
    end
  end  
end