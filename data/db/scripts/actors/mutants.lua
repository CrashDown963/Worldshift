--
-- Mutants specific programs
--

function Unit:PrgStreamOfLife(params)
  this.onPrgEnd = function() 
    this:SetAnim() 
    this:RemoveAttachments("pt_hand")
  end
  
  this:SetAnim("cast_streamoflife_channeling")
  this:AttachAnim("pt_hand", "data/models/effects/magic/HealFXFinish.nif")
  this:AttachAnim("pt_hand", "data/models/effects/magic/HealHandsBandage.nif")
  
  for i = 1,5 do
    this:CastSpell(this:GetPos(), "CastStreamOfLife")
    this:Sleep(1)
  end
end

function Unit:PrgRainOfFire(params)
  local pt = params.pt
  this:FaceTo(pt)
  this:CastSpell(this:GetPos(), "CastRainOfFire")
  
  local faction = this:GetFaction();
  local actor = map.CreateObject("RainOfFire", pt, faction);
  if actor then 
    actor:SetCreator(this)
  end
end

function Unit:PrgThunder(params)
  local pt = params.pt
  this:FaceTo(pt)
  this:CastSpell(this:GetPos(), "CastThunder")
  
  local faction = this:GetFaction();
  map.CreateObject("Thunder", pt, faction);
end

function Unit:PrgHealingWave(params)
  local pt = params.pt
  if this:MoveTo(pt, nil, nil, this:GetVar("healingwave_range")) then return end
  this:CastSpell(pt, "CastHealingWave")
end

function Unit:PrgConjureFood(params)
  local food = this:GetVar("conjure_food")
  local time = this:GetVar("conjure_time")
  local focus = params.focus or 0
  this.onPrgEnd = function() this:SetAnim() end
  this:SetAnim("cast_conjure_food_prepare")
  this:Sleep(time)
  this:PlayAnim("cast_conjure_food_finish")
  map.AddRes(this:GetFaction(), food, "f")
  map.SubRes(this:GetFaction(), focus, "o")
  this:DrainPower(this:GetVar("conjure_power"))
end

function Unit:PrgLifeBloom(params)
  local minRange, maxRange = this:GetAttackRanges(nil)
  if this:MoveTo{params.h, maxRange = maxRange} then return end
  this.onPrgEnd = function() this:SetAnim() end
  this:FaceTo(params.h)
  this:PlayAnim("cast_finish")
  if not Actor.IsValid(params.h) then return end
  params.h:Heal(params.h:GetMaxHP())
  if params.h ~= this then
    params.h:IncreasePower(params.h:GetMaxPower())
  end  
  params.h:CreateReact("heal")
  this:DrainPower(this:GetVar("holyshock_power"))
  this:StartActionCooldown(params.action)
end

-- Sequence!
function Unit:PrgSequenceAction(params)

  local p2p
  local EnvChanger

  this.onPrgEnd = function() 
    this:SetAnim() 
    this:RemoveAttachments("pt_ground")
    this:RemoveAttachments("pt_sequence")
    this:RemoveAttachments("pt_chest")
    
    if p2p then
      this:P2PDestroy(p2p)
    end
    
    if EnvChanger then
      this:EnvironmentChangerDestroy(EnvChanger)
    end
    
    --print("end")
    
  end

  --print("start")
  this:SetAnim()
  while 1 do
  
    local a = this:ActionSequenceWaitFeedback()
    --print(a)
    if a == "FINISHED" or a == "FAIL" then break end
    if a == "1" then
          
      local pt = this:GetPos();
      local faction = this:GetFaction()
      
      EnvChanger = this:EnvironmentChangerCreate()
      this:EnvironmentChangerSetDark(EnvChanger)
      
      this:AttachAnim("pt_ground", "data/models/effects/actionsequence/highpriest_levitateattachment.nif")
      this:SetAnim("sequence_1")
      this:Sleep(this:GetRanged(0.5, 1.0))
    elseif a == "2" then 
      this:SetAnim("sequence_2")
      this:Sleep(this:GetRanged(0.5, 1.0))
    elseif a == "3" then 
      this:AttachAnim("pt_chest", "Data/Models/Effects/ActionSequence/Chest_LightningAttachment.nif")
      this:SetAnim("sequence_3")
      this:Sleep(this:GetRanged(0.5, 1.0))
    elseif a == "4" then 
      local pt = this:GetPos()
      this:CastSpell(pt, "HighPriest_Sequence_Finish")
      local faction = this:GetFaction();
      local actor = map.CreateObject("RainOfFireSequence", pt, faction);
      if actor then 
        actor:SetCreator(this)
      end
      
      if p2p then
        this:P2PDestroy(p2p)
      end
      this:Sleep(1.5)
    end      
    this:ActionSequenceNextAction()
  end 
  
end


-- Guardian

function Guardian:PrgAbsorbEnergy(params)
  this:PlayAnim("cast_absorb_energy_prepare")  
  this:SetAnim()
end

function Guardian:PrgPlasmaShield(params)
  this:ActivatePlasmaShield()
end

function Guardian:PrgFortify(params)
  local snd = this:GetVar("fortify_sound", "str") or nil
  local anim = this:GetVar("fortify_anim", "str") or nil
  local react = this:GetVar("fortify_react", "str") or nil
  
  this.onPrgEnd = function()
    this:ActivateController("GuardianFortifyAura", 0)
    if react then this:StopReact(react) end
    this:SetAnim()
  end

  if anim then this:SetAnim(anim) end
  this:ActivateController("GuardianFortifyAura", 1)
  if react then this:CreateReact(react) end
  if snd then this:PlaySnd(snd) end
  while true do
    this:DrainPower(0)
    this:Sleep(1)
  end
end

-- Sequence!
function Guardian:PrgSequenceAction(params)

  local p2p

  this.onPrgEnd = function() 
    this:SetAnim() 
    this:RemoveAttachments("pt_ground")
    if p2p then
      this:P2PDestroy(p2p)
    end
  end


  while 1 do
    local a = this:ActionSequenceWaitFeedback()
    if a == "FINISHED" or a == "FAIL" then break end
    if a == "1" then
      this:AttachAnim("pt_ground", "Data/Models/Effects/ActionSequence/guardian_charging.nif")
      p2p = this:P2PCreate("HighPriestSequenceBeam", nil, this, this, "pt_charge01", "pt_charge02", nil, nil)
      this:SetAnim("sequence_1")
      this:Sleep(this:GetRanged(0.0, 0.5));
    elseif a == "2" then 
      local len = this:GetAnimLength("sequence_2")
      this:SetAnim("sequence_2")
      this:Sleep(len);
      this:CastSpell(this:GetPos(), "Guardian_Sequence_Finish")
    end      
    this:ActionSequenceNextAction()
  end 
  
end


-- Rain Of Fire
function RainOfFire:PrgIdle(params)
  this:Impact()
  this:Destroy()
end

-- Thunder
function Thunder:PrgIdle(params)
  this:PlayAnim("thunder_fade_in")
  this:SetAnim("thunder_idle")
  
  local ptMove = this:GetMovePoint()
  local TimeDamage = this:GetDamageTime()
  local TimeLightning = this:GetLightningTime()
  
  while (this:IsAlive()) do  
    local timetoMove = 0
    if TimeDamage < TimeLightning then
      timeToMove = TimeDamage
    else       
      timeToMove = TimeLightning
    end      
    
    --Move
    local moveStart = this:GetTime()
    res = this:MoveTo{ptMove, timeout = timeToMove}
    local deltaTime = this:GetTime() - moveStart
    
    TimeDamage = TimeDamage - deltaTime
    TimeLightning = TimeLightning - deltaTime
    
    if TimeDamage < 0 then
      this:SpawnDamage()
      TimeDamage = this:GetDamageTime()
    end 

    if TimeLightning < 0 then
      this:SpawnLightnings()
      TimeLightning = this:GetLightningTime()
    end 
    
    if res ~= "TIMEOUT" then 
      ptMove = this:GetMovePoint()
    end
  end
  
  this:PlayAnim("thunder_fade_out")
  this:Destroy()
end


-- Shaman Drain Life Attack

function Unit:DrainLifeAttack()
  local hUnit = this:GetPrimaryTarget()
  if not hUnit then return "NOTARGET" end

  if not hUnit:IsOrganic() then 
    return Unit.Fight(this)
  end

  local range = this:GetVar("drnlife_range")
  local maxrange = this:GetVar("drnlife_max_range")
  local duration = this:GetVar("drnlife_duration") or 1
  local spawn_time = this:GetVar("drnlife_beam_spawn_time") or 1
  local beams = duration / spawn_time
  local attach = this:GetVar("drnlife_attach", "str")
  local attach_point = this:GetVar("drnlife_source", "str")
  
  this.onPrgEnd = function()
    this:SetPrimaryTarget()
    this:SetAnim()
    if attach_point and attach then 
      this:RemoveAttachments(attach_point) 
    end
    
    this:ClearBeams()
  end
  
  --Move to!  
  this:KeepFollowingTarget(0)
  this:FailMoveOnLoseTarget(1)
  if range then 
    if this:MoveTo{hUnit, maxRange = range} then return end
  else 
    if this:MoveTo{hUnit} then return end
  end

  -- Get mana!
  this:SetAnim("cast_drnlife_channeling")
  
  -- Attach!
  if attach_point and attach then 
    this:AttachAnim(attach_point, attach)
  end
  
    
  for i = 1,beams do
  
    -- face target
    this:FaceTo(hUnit)
    
    local Dist = this:DistTo(hUnit)
    if not Dist then this.onPrgEnd() return end
    
    -- bigger distance?
    if  Dist > maxrange then this.onPrgEnd() return "OUTOFRANGE" end
    
    -- restore
    if not this:DrnLifeAttack(hUnit) then this.onPrgEnd() return end
    this:Sleep(spawn_time)
  end
  
  this.onPrgEnd()
end

function Guardian:PrgIllusions(params)
  this:CreateIllusions()
end

function Guardian:PrgDespawnIllusion(params)
  this:PlayAnim("attack_3", 0.5)
  this:Destroy()
end

function DarkWind:PrgIdle(params)
  this.idle = 1
  this.onPrgEnd = function()
    this.idle = nil
  end
  local creatorHandle = this:GetVar("creator_h")
  --if creatorHandle == nil then return end
  local creator = creatorHandle and map.GetActorByHandle(creatorHandle) or nil
  local areaRadius = this:GetVar("area") or 1000
  local darkWindBeam = this:GetVar("dark_wind_beam_name", "str")
  local fireLashBeam = this:GetVar("fire_lash_beam_name", "str")
  local thunderBeam = this:GetVar("thunder_beam", "str")
  
  local darkWindSpawn = this:SplitAnimParam(this:GetVar("dark_wind_spawn", "str"))
  local fireLashSpawn = this:SplitAnimParam(this:GetVar("fire_lash_spawn", "str"))
  local thunderSpawn = this:SplitAnimParam(this:GetVar("thunder_spawn", "str"))
  
  local beamDuration = this:GetVar("beam_duration") or 0.3
  local lightningPoints = { "pt_lightning01", "pt_lightning02", "pt_lightning03", "pt_lightning04" }
  local minBeams = this:GetVar("min_beams") or 1
  local maxBeams = this:GetVar("max_beams") or 6
  local minInterval = this:GetVar("min_beams_interval") or 0.1
  local maxInterval = this:GetVar("max_beams_interval") or 1
  local fadeInAnim = this:GetVar("anim_fade_in", "str") or "thunder_fade_in"
  local idleAnim = this:GetVar("anim_idle", "str") or "thunder_idle"
  local darkWindEffect = this:GetVar("dark_wind_effect", "str")
  local fireLashEffect = this:GetVar("fire_lash_effect", "str")
  local thunderEffect = this:GetVar("thunder_effect", "str")
  local lurkArea = this:GetVar("lurk_area")
  local wander = this:GetVar("wander")
  wander = wander and wander ~= 0
  local duration = this:GetVar("duration")

  this:PlayAnim(fadeInAnim)
  this:SetAnim(idleAnim)

  local initialPos = this:GetPos()
  local currentMovePos = nil
  local endTime = duration and this:GetTime() + duration or -1

  while endTime < 0 or this:GetTime() < endTime do
    local sleepTime = map.SRND(minInterval, maxInterval)
    if lurkArea and currentMovePos == nil then
      currentMovePos = this:GetRandomPointInRange(wander and this:GetPos() or initialPos, lurkArea)
    end
    if currentMovePos and this:MoveTo{currentMovePos, maxRange = 50, timeout = sleepTime} == nil then
      currentMovePos = nil
    end
    if (creator == nil or not creator:IsValid()) and creatorHandle then
      this:Execute("PrgFade")
      return
    end
    local numEnemies = map.SIRND(minBeams, maxBeams)
    local enemies = this:GetActorsInArea(this:GetPos(), areaRadius, true, numEnemies)
    local fireLash = creator and creator:GetVar("fire_lash")
    fireLash = fireLash and fireLash ~= 0
    for i, enemy in ipairs(enemies) do
      if enemy and enemy:IsValid() then
        local beam = (fireLash and fireLashBeam or darkWindBeam) or thunderBeam
        if beam then
          local nearestNode = this:GetNearestNode(enemy:GetPos(), lightningPoints)
          if nearestNode == nil then
            nearestNode = "pt_lightning0" .. tostring(map.SIRND(1, 4))
          end
          this:P2PCreate(beam, nil, this, nil, nearestNode, nil, nil, enemy:GetPos(), beamDuration)
        end
        local spawn = (fireLash and fireLashSpawn or darkWindSpawn) or thunderSpawn
        if spawn then
          map.SpawnObject(spawn[map.SIRND(1, table.getn(spawn))], enemy:GetPos(), this:GetFaction())
        end
        local effect = (fireLash and fireLashEffect or darkWindEffect) or thunderEffect
        if effect then this:SpawnEffect(effect, enemy) end
      end
      local beamSleep = map.SRND(0.05, 0.2)
      sleepTime = sleepTime - beamSleep
      this:Sleep(beamSleep)
    end
    if endTime < 0 and sleepTime > 0 then this:Sleep(sleepTime) end
  end
  if endTime > 0 then
    this:Execute("PrgFade")
    return
  end
  this.onPrgEnd()
end

function DarkWind:PrgFade()
  local fadeOutAnim = this:GetVar("anim_fade_out", "str") or "thunder_fade_out"
  this:PlayAnim(fadeOutAnim)
  this:Destroy()
end
