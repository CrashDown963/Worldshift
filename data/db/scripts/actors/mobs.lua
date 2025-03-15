function Mob:PrgIdle(params)
  local boss = this:GetVar("boss") or 0
  local guided_move

  if this:HasWeapon() then
    this.onEnemySeen = function()
      if guided_move then return end
      local chase_range = this:GetVar("chase_range")
      local enemy = this:FindEnemy(this:GetPos(), chase_range)
      if enemy then
        this:Execute("PrgCombat")
        return true
      end  
    end
  end  
  local run_speed = this:GetVar("run_speed")
  if not run_speed then
    run_speed = this:GetVar("speed")
    this:SetVar("run_speed", run_speed)
  end
  this.onPrgEnd = function()
    this:EnableMoveCollisionChecks(1);
    this:SetVar("InCombat", 1)
    if boss > 0 then
      local time = map.GetTime()
      this:SetVar("combat_start_time", time or 0)
      map.ShowBossInfo(this)
    end
    this.onEnemySeen = nil
    this:SetVar("speed", run_speed)
    this:CancelRemap()
    this:MobLeavingWaypoint()
  end

  guided_move = ((this:GetBehaviorVar("waypoint_radius") or 0) < 0)
  if this.onEnemySeen and this.onEnemySeen() then return end -- check for enemy right now
  guided_move = nil

  this:SetVar("InCombat", 0)
  if boss > 0 then
    map.ShowBossInfo(nil)
  end
  while true do
    local movable = this:GetVar("movable") or 0
    if movable < 1 then
      this:Idle(1)
    else
      break  
    end
  end

  local anti_freeze = 0
  while true do
    if this:GetAnimLength("walk") then
      if this:GetBehaviorVar("run") ~= 1 then
        local walk_speed = this:GetVar("walk_speed")
        this:SetVar("speed", walk_speed)
        this:RemapAnim("run", "walk")
      else
        this:SetVar("speed", run_speed)
        this:CancelRemap()
      end
    end
    local wpt_pos = this:GetBehaviorPointPos()
    local wpt_radius = this:GetBehaviorVar("waypoint_radius") or 0
    local bInRange = this:InRange(wpt_pos, wpt_radius)
    if not bInRange then
      anti_freeze = 0
    end
    while not bInRange do
      this:MobLeavingWaypoint()
      if this:ShouldWaitForOthers() then
        this:DbgFloatText("Wait")
        guided_move = (wpt_radius < 0)
        this:Idle(1)
        guided_move = nil
      else
        guided_move = (wpt_radius < 0)
        local res = this:MoveTo{wpt_pos, maxRange = wpt_radius, timeout = 1}
        guided_move = nil
        if "TIMEOUT" ~= res then
          break
        end  
      end  
    end
    this:CancelRemap()
    this:MobOnWaypoint()
    local time_stay = this:GetBehaviorVar("time_stay") or 0
    local wander_stay = this:GetBehaviorVar("wander_stay") or 0
    if time_stay > 0 then
      this:DbgFloatText("Wander")
      anti_freeze = 0
      local anim_idle = this:GetBehaviorVar("anim_idle", "str") or "";
      if anim_idle == "" then
        anim_idle = "idle"
      end  
      local time_start = this:GetTime()
      local wander_begin_time = time_start
      if time_start < wander_stay then -- shuffle wander starts at the beginning
        time_start = time_start - map.SRND(0, wander_stay)
      end
      while this:GetTime() < time_start + time_stay do
        if wpt_radius > 0 and this:GetTime() >= wander_begin_time + wander_stay then
          local dest = this:GetWanderDest()
          local current_speed = this:GetVar("speed")
          this:EnableMoveCollisionChecks(0);
          if this:GetAnimLength("walk") then
            local walk_speed = this:GetVar("walk_speed")
            this:SetVar("speed", walk_speed)
            this:RemapAnim("run", "walk")
            this:MoveTo{dest, maxRange = 0} --!!!
            this:CancelRemap()
          else
            this:SetVar("speed", run_speed)
            this:CancelRemap()
            this:MoveTo{dest, maxRange = 0} --!!!
          end  
          this:EnableMoveCollisionChecks(1);
          this:SetVar("speed", current_speed)
          wander_begin_time = this:GetTime()
        end  
        if anim_idle ~= "*" then
          local face = this:GetBehaviorVar("face_on_idle", "str")
          if face and face ~= "" then
            this:FaceTo(face)
          end
          this:RemapAnim("IDLE", anim_idle)
          this:Idle(1)
          this:CancelRemap()
        end  
      end
    end
    this:DbgFloatText("Next waypoint")
    
    if not this:ChooseNextBehaviorPoint() then
      anti_freeze = anti_freeze + 1
      if anti_freeze > 1 then
        print("Bad Mob Path, engaging anti-freeze")
        anti_freeze = 0
        this:Idle(10)
      end
    end
  end 
end

function Mob:PrgCombat(params)
  --print("+PrgCombat")
  local aggro_pos = this:GetPos()
  this:SetVar("aggro_pos", aggro_pos)
  this.onNoEnemiesInSight = function()
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
  this.onPrgEnd = function()
    --print("-PrgCombat")
    this.onNoEnemiesInSight = nil
  end

  --Unit.PrgIdle(this, params)
  while true do
    local chase_range = this:GetVar("chase_range")
    local enemy = this:FindEnemy(aggro_pos, chase_range)
    if not enemy then
      local roam = this:GetVar("roam") or 0
      local noEvade = this:GetVar("no_evade") or 0
      if roam > 0 or noEvade > 0 then
        local path = this:GetVar("path", "str")
        if path then this:SetVar("path", path) end
        this:Execute("PrgIdle")
      else  
        this:Execute("PrgEvade")
      end
      return
    end
    local broadcast_target = this:GetVar("broadcast_target") or 1
    if broadcast_target ~= 0 then
      this:BroadcastTarget(enemy, 1000, 2000, 5);
    end  
    this:CheckAbilities("approach")
    if this:FightEnemy(enemy) == "OUTOFRANGE" then
      local minRange, maxRange = this:GetAttackRanges(enemy)
      if this:MoveTo{enemy, maxRange = maxRange, timeout = 1} == "IMMOVABLE" then
        this:Idle(1)
      end
    end  
  end
end

function Mob:PrgEvade(params)
  this:SetVar("InCombat", 0)
  local boss = this:GetVar("boss") or 0
  if boss > 0 then
    map.ShowBossInfo(nil)
  end
  this:SetVar("invulnerable", 1)
  this.onPrgEnd = function()
    this:SetVar("InCombat", 1)
    this:SetVar("invulnerable", 0)
  end
  this:Heal(this:GetMaxHP() - this:GetHP())
  this:IncreasePower(this:GetMaxPower() - this:GetPower())
  local movable = this:GetVar("movable") or 0
  if movable >= 1 then
    local pt = this:GetVar("aggro_pos", "xpoint3") or this:GetBehaviorPointPos()
    this:MoveTo(pt);
  end  
end

function Mob:PrgSpawn(params)
  local spell = this:GetVar("spawn_cast", "str")
  if spell then
    this:CastSpell(this, spell)
  end
  local spawn = this:GetVar("spawn_spawn", "str")
  if spawn then
    map.SpawnObject(spawn, this:GetPos(), this:GetFaction())
  end
  if map.onMobSpawn then
    map.onMobSpawn(this)
  end
end

function Mob:PrgRespawn(params)
  local spell = this:GetVar("respawn_cast", "str")
  if spell then
    this:CastSpell(this, spell)
  end
  local evade = this:GetVar("evade_on_respawn") or 0
  if evade > 0 then
    this:Execute("PrgEvade");
  end  
end

--function Mob:PrgDespawn(params)
--  
--end

function Mob:PrgDie(params)
  if map.onMobDeath then
    map.onMobDeath(this)
  end
end

function Mob:CheckAbility(params)
  return true
end

function Mob:PrgCastAbility(params)
  print(params.id..":"..params.more_test)
end

function Mob:ConsiderAOE(hTarget)
  if not Actor.IsValid(hTarget) then return nil end
  local sAOEState = this:GetVar("AOE_state", "str")
  if not sAOEState then return nil end
  local pwr = this:GetVar("barrage_cost")
  if this:GetPower() < pwr then return nil end
  local dist = this:DistTo(hTarget)
  local unit_range = this:GetVar("range")
  local barrage_min_range = this:GetVar("barrage_min_range")
  if dist > unit_range or dist < barrage_min_range then return nil end
  local a,e = this:EstimateAOE(hTarget:GetPos(), 600)
  if e < 500 then return nil end
  if e < 2 * a then return nil end
  this:EnterState(sAOEState, hTarget:GetPos())
  return true
end  

function Mob:MachineHealerBehave(hPrimary, primary_heal_threshod, secondary_heal_threshold)
  local heal_range = this:GetVar("heal_range") or 1000
  local attack_range 
  if this:HasWeapon() then
    attack_range = this:GetVar("range") or 0
  else
    attack_range = 0
  end
 
  while true do
    local hDest
    hDest = this:FindMachineHealerTarget(attack_range, heal_range, hPrimary, 10, 40)
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
        if this:InRange(hDest, heal_range) then
          this:StopMoving()
          local anim = nil
          local spell = this:GetVar("heal_cast", "str") or "Heal"
          if hDest == this then 
            anim = "self" 
          end
          if this:CastSpell(hDest, spell, anim) then
            this:Sleep(1)
          end
        else
          this:FailMoveOnLoseTarget(1)
          this:KeepFollowingTarget(0)
          this:MoveTo{hDest, maxRange = heal_range, timeout = 3}
        end  
      end  
    else
      this:Idle(1)  
    end
  end
end

function Mob:PrgROMDroidIdle(params)
  this:MachineHealerBehave(nil, 10, 30)
end

function Mob:PrgYamuCharge(params)
  local oldSpeed = this:GetVar("speed")
  
  this.onPrgEnd = function()
    if oldSpeed then 
      this:SetVar("speed", oldSpeed)
    else
      this:SetVar("speed", this:GetVar("run_speed"))
    end
    this:SetAnim()
    this:RemoveAttachments("pt_foot")
  end
  
  local targetReact = params.target_react or "confusion_react"
  local chargeSpeed = params.charge_speed or 2000
  local hitRange = params.hit_range or 500
  local enemySearchRange = params.enemy_search_range or this:GetVar("chase_range") or 3000
  local enemySearchCone = params.enemy_search_cone or 150
  local prepareAnim = params.prepare_anim
  local mapLuaOnHit = params.map_lua_on_hit
  local trampleAnim = params.trample_anim or "trample"
  local footAttachment = params.foot_attachment
  local footAttachmentScale = params.foot_attachment_scale
  local growlSound = params.growl_sound
  
  local prevEnemy = this:FindNearestEnemy(this:GetPos(), enemySearchRange, enemySearchCone)
  if prevEnemy == nil then return end
  prevEnemy:CreateReact(targetReact)
  if prepareAnim then 
    this:FaceTo(prevEnemy:GetPos())
    local prepareAnimLength = this:GetAnimLength(prepareAnim)
    local startTime = this:GetTime()
    this:SetAnim(prepareAnim)
    this:Sleep(1)
    if growlSound then this:PlaySnd(growlSound) end
    this:Sleep(prepareAnimLength - (this:GetTime() - startTime))
    this:SetAnim()
  end
  
  this:SetVar("speed", chargeSpeed)
  this:FailMoveOnLoseTarget(1)
  this:KeepFollowingTarget(0)
  local moveResult = "TIMEOUT"
  local enemy = this:FindNearestEnemy(this:GetPos(), enemySearchRange, enemySearchCone)
  local trampleStartTime = nil
  local trampleLength = this:GetAnimLength(trampleAnim)
  
  while enemy ~= nil and "TIMEOUT" == moveResult do
    if enemy ~= prevEnemy then
      prevEnemy:StopReact(targetReact)
      enemy:CreateReact(targetReact)
    end
    prevEnemy = enemy
    moveResult = this:MoveTo{enemy, maxRange = 100, timeout = 0.1 }
    enemy, range = this:FindNearestEnemy(this:GetPos(), enemySearchRange, enemySearchCone)
    if enemy ~= nil and range <= hitRange then break end
    if range and trampleLength and range < 1000 and trampleLength > 0 then
      trampleStartTime = this:GetTime()
      this:SetAnim(trampleAnim)
      if footAttachment then
        this:AttachAnim("pt_foot", footAttachment, { auto_size_base = 0, scale = footAttachmentScale or 1 })
      end
    end
  end
  
  if "FAIL" ~= moveResult and enemy ~= nil then
    this:SpawnEffect("E_YamuChargeHit", enemy)
    map.ShakeCamera(this:GetPos())
    -- this:PlayAnim("trample")
    if mapLuaOnHit and map[mapLuaOnHit] then map[mapLuaOnHit]() end
    if trampleLength and trampleStartTime then
      this:Sleep(trampleLength - (this:GetTime() - trampleStartTime))
    end
  end
end

function Mob:SpiderSpawn(params)
  local id = params.id or "SpiderSpawn"
  local min = params.min or 1
  local max = params.max or 3
  local cnt = map.SIRND(min, max)
  local objects = {}
  map.SpawnObjects(id .. " = " .. cnt, this:GetPos(), this:GetFaction(), objects);
  map.AddActorsToActorGroups(this, objects)
end

function Mob:OpenGate(params)
  local gateOpenAnim = params.gate_open_anim or "open"
  local pylonOpenAnim = params.pylon_open_anim or "open"
  local pylonId = params.pylon_id
  local searchRadius = params.pylon_search_radius
  
  this:SetAnim(gateOpenAnim)
  local pylons = map.GetActorsInArea(pylonId, this:GetPos(), searchRadius);
  if pylons then
    for _, pylon in ipairs(pylons) do
      pylon:SetAnim(pylonOpenAnim)
    end
  end
  
  this:SetVar("open", 1)
  this:SetVar("passable", 1)
  this:SetVar("no_mouse_targetable", 1)
  this:SetVar("selectable", 0)
  return true
end

function Mob:CloseGate(params)
  local gateCloseAnim = params.gate_close_anim or "close"
  local pylonCloseAnim = params.pylon_close_anim or "close"
  local pylonId = params.pylon_id or "Side_Pilon"
  local searchRadius = params.pylon_search_radius or 600
  
  this:SetAnim(gateCloseAnim)
  local pylons = map.GetActorsInArea(pylonId, this:GetPos(), searchRadius);
  if pylons then
    for _, pylon in ipairs(pylons) do
      pylon:SetAnim(pylonCloseAnim)
    end
  end
  
  this:SetVar("open", 0)
  this:SetVar("passable", 0)
  this:SetVar("no_mouse_targetable", 0)
  this:SetVar("selectable", 1)
  return true
end

function Mob:LoadGate(params)
  local open = this:GetVar("open", "int") or 0
  local passable = this:GetVar("passable", "int") or 0
  if open == passable then return end
  if passable ~= 0 then 
    this:OpenGate(params) 
  else 
    this:CloseGate(params) 
  end
end

function Mob:PrgHatchEgg(params)
  --print("PrgHatchEgg Start")
  local egg = params.h
  if not egg or not Actor.IsValid(egg) then return end
  this:SetVar("force_in_ability", 1)
  --local blah = false
  
  this.onPrgEnd = function()
    --local fia = this:GetVar("force_in_ability", "int")
    --if not blah then
    --  print("PrgHatchEgg.onPrgEnd: " .. fia)
    --else
    --  print("Success")
    --end
    this:SetVar("force_in_ability", 0)
    this:SetAnim()
    if params.egg_react and Actor.IsValid(egg) then
      egg:StopReact(params.egg_react)
    end
  end
  
  local moveResult = "TIMEOUT"
  if params.egg_react then
    egg:CreateReact(params.egg_react)
  end
  
  while moveResult == "TIMEOUT" and Actor.IsValid(egg) do
    moveResult = this:MoveTo{egg, maxRange = 200, timeout = 0.2 }
  end
  
  if "FAIL" ~= moveResult and Actor.IsValid(egg) then
    this:FaceTo("reset")
    this:FaceTo(egg)
    local animLength, actionLength = this:GetAnimLength("hit_3")
    if animLength then
      this:SetAnim("hit_3")
      if actionLength then
        this:Sleep(actionLength)
      else
        this:Sleep(animLength);
      end
      if Actor.IsValid(egg)then
        egg:SetVar("infected", 1)
        egg:Damage(100000, 100)
      end
      if actionLengh and actionLength < animLength then
        this:Sleep(animLength - actionLength)
      end
    end
    this:SetAnim()
    if params.healing_perc then
      this:Heal(this:GetMaxHP() * params.healing_perc / 100)
    end
  end
  --blah = true
end

function Mob:PrgCreateEffect(params)
  local spawned = false
  for k, v in pairs(params) do
    if "default" ~= k then
      if this:GetVar(k) == 1 then
        this:SpawnEffect(v, this)
        spawned = true
      end
    end
  end
  if not spawned and params.default then
    this:SpawnEffect(params.default, this)
  end
end
