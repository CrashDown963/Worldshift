--
-- Mutants specific programs
--

-- Alien
function Alien:PrgIdle(params)
  if not this:IsActivated() then
    while 1 do
      this:PlayAnim("deactivated_idle")
      this:Sleep(1);
    end
  else 
    this:SetAnim()
    Unit.PrgIdle(this, params)
  end
end

function Alien:PrgCharge(params)
  local hMaster = params.h
  if this:MoveTo{hMaster} then return end
  this:CastSpell(this:GetPos(), "CastCharge")
  sleep_time = this:Charge(hMaster)
  if not sleep_time then return end
  this:Sleep(sleep_time)
  this:Destroy()
end

function Alien:PrgConsumeMinions(params)
  this:ConsumeMinions()
end

function Alien:PrgSacrificeMinion(params)
  local hMinion = params.h
 
  max_range = this:GetVar("sacrifice_max_range")
  if max_range then 
    if this:MoveTo{hMinion, maxRange = max_range} then return end
  else 
    if this:MoveTo{hMinion} then return end
  end
  
  -- get effect!
  this:CastSpell(this:GetPos(), "CastSacrifice")  
  sacrifice_effect = hMinion:GetVar("sacrifice_effect", "str")
  
  hMinion:SetSacrificeOnDeath(false)
  hMinion:Die()
  if sacrifice_effect then 
    hMinion:SpawnEffect(sacrifice_effect)
  end
end


function Alien:PrgTransferCharge(params)
  local hCharge = params.h
  
  max_range = this:GetVar("transfer_charge_max_range")
  if max_range then 
    if this:MoveTo{hCharge, maxRange = max_range} then return end
  else 
    if this:MoveTo{hCharge} then return end
  end
  
  this:CastSpell(this:GetPos(), "CastTransferCharge")
  this:TransferCharge(hCharge)
end

function Alien:PrgTwistPerception(params)
  local hFlare = params.h
  
  max_range = this:GetVar("twist_perception_max_range")
  if max_range then 
    if this:MoveTo{hFlare, maxRange = max_range} then return end
  else 
    if this:MoveTo{hFlare} then return end
  end
  
  this:CastSpell(this:GetPos(), "CastTwistPerception")
  this:TwistPerception(hFlare)
end

function Alien:PrgChangePlaces(params)
  local h = params.h
  local charges = params.charges or 0
  local range = params.range
  if this:GetCharges() < charges then return end
  if range < this:DistTo(h) then
    if this:MoveTo{h, maxRange = range} then return end
  end
  if this:GetCharges() < charges then return end
  this:FaceTo(h)
  this.onPrgEnd = function() this:SetAnim() end
  this:SetAnim("change_places_anim")
  this:Sleep(this:GetVar("change_places_cast_time"))
  local pt = h:GetPos()
  h:SetPos(this:GetPos())
  this:SetPos(pt)
  this:SetCharges(0)
end

function Alien:PrgEnergize(params)
  local charges = params.charges or 0
  local power = this:GetMaxPower() * params.power_perc / 100
  this:IncreasePower(power)
  this:SetCharges(this:GetCharges() - charges)
end


function Alien:PrgVitalitySurge(params)
  local charges = params.charges or 0
  local hp = this:GetMaxHP() * params.hp_perc / 100
  this:Heal(hp)
  this:SetCharges(this:GetCharges() - charges)
end

-- Shifter

function Shifter:PrgTwistXenolite(params)
  local hXeno = params.h
  min_range = this:GetVar("convert_twisted_xenolite_min_range")
  if min_range then 
    if this:MoveTo{hXeno, minRange = min_range} then return end
  else 
    if this:MoveTo{hXeno} then return end
  end
    
  convert_time = this:GetVar("convert_twisted_xenolite_time")
  this:SetAnim("cast_twisted_xenolite")
  this:Sleep(convert_time)
  sleep_time = this:TwistXenolite(hXeno)
  this:Sleep(sleep_time)
  this:Destroy()
end

-- Dominator

function Alien:PrgEnergyPulse(params)
  local minrange, maxrange
  local h = params.h
  local pt = params.pt

  this:SetWeapon("energy_pulse")
  this:SetPrimaryTarget(pt, h)

  this.onPrgEnd = function()
      this:SetPrimaryTarget()
      this:SetWeapon("")
    end

  minRange, maxRange = this:GetAttackRanges(h)
  
  if not Actor.IsValid(h) then
    this:MoveTo(pt, nil, nil, maxRange)
    this:onPrgEnd()  -- call manually as it seems to not be called when a function exits through return
    return;
  end

  if not this:InRange(h, maxRange) then
    this:FailMoveOnLoseTarget(0)
    this:MoveTo(nil, h, nil, minRange)
  end
  this:Fight()
end

function Alien:PrgReflect(params)
  this:ActivateController("reflect_controller", 1)
end

function Alien:PrgDominate(params)
  local h = params.h
  local org_faction
  local range = this:GetVar("dominate_range")
  local duration = this:GetVar("dominate_duration")
  
  org_faction = h:GetVar("org_faction")
  if org_faction and org_faction ~= 0 or duration < 0.05 then
    return
  end
  
  if not Actor.IsValid(h) then
    this:MoveTo(pt, nil, nil, range)
    return;
  end

  if not this:InRange(h, range) then
    this:FailMoveOnLoseTarget(0)
    this:MoveTo(nil, h, nil, range)
  end
  if not Actor.IsValid(h) or not this:InRange(h, range) then
    return;
  end

  org_faction = h:GetVar("org_faction")
  if not org_faction or org_faction == 0 then
    this.onPrgEnd = function()
      h:SetVar("faction", org_faction)
      h:SetVar("org_faction", 0)
	end
	this:SetCharges(0)
	org_faction = h:GetVar("faction")
	h:SetVar("org_faction", org_faction)
	h:SetVar("faction", this:GetVar("faction"))
	this:SetCharges(this:GetCharges() - 1)
	this:SetAnim("cast")
	this:Sleep(duration)
    h:SetVar("faction", org_faction)
    h:SetVar("org_faction", 0)
    this:PlayAnim("cast_finish")
  end
end

-- Arbiter

function Arbiter:PrgLinkHealth(params)
  local hCharge = params.h
  
  max_range = this:GetVar("link_health_max_range")
  if max_range then 
    if this:MoveTo{hCharge, maxRange = max_range} then return end
  else 
    if this:MoveTo{hCharge} then return end
  end
  
  this:CastSpell(this:GetPos(), "CastLinkHealth")
  this:LinkHealth(hCharge)
  this:SetCharges(0)
end

function Arbiter:PrgTwistedSense(params)
  this:CastSpell(this:GetPos(), "CastTwistedSense")
  this:TwistedSense()
end

-- Master

function Master:PrgWreakHavoc(params)
  this:WreakHavoc()
end

function Master:PrgPlasmaSeed(params)
  local hTarget = params.h
  local pt = params.pt
  
  max_range = this:GetVar("plasma_seed_max_range")
  
  if hTarget then 
    if max_range then 
      if this:MoveTo{hTarget, maxRange = max_range} then return end
    else 
      if this:MoveTo{hTarget} then return end
    end
  end
  
  if pt then 
    if max_range then 
      if this:MoveTo{pt, maxRange = max_range} then return end
    else 
      if this:MoveTo{pt} then return end
    end
  end
  
  this:CastSpell(this:GetPos(), "CastPlasmaSeed")
  this:PlasmaSeed(hTarget, pt)
end

function Master:PrgDrainEnemy(params)
  local hDrain = params.h
  local charges = params.charges or 0
  
  max_range = this:GetVar("drain_enemy_max_range")
  if max_range then 
    if this:MoveTo{hDrain, maxRange = max_range} then return end
  else 
    if this:MoveTo{hDrain} then return end
  end
  
  this:CastSpell(this:GetPos(), "CastDrainEnemy")
  this:DrainEnemy(hDrain)
  this:SetCharges(this:GetCharges() - charges)
end

function DarkVortex:PrgIdle(params)
  for k, v in pairs(params) do
    print(tostring(k) .. " = " .. tostring(v))
  end

  local duration = this:GetVar("duration") or 20
  local areaRadius = this:GetVar("area") or 1000
  local beam = this:GetVar("beam_name", "str") or "DarkVortexHealBeam"
  local beamDuration = this:GetVar("beam_duration") or 0.3
  local lightningPoints = { "pt_lightning01", "pt_lightning02", "pt_lightning03", "pt_lightning04" }
  local healPoints = this:GetVar("heal_hp") or 30
  local healReact = this:GetVar("heal_react", "str") or "heal"
  local minBeams = this:GetVar("min_beams") or 1
  local maxBeams = this:GetVar("max_beams") or 6
  local minInterval = this:GetVar("min_beams_interval") or 0.1
  local maxInterval = this:GetVar("max_beams_interval") or 1
  local fadeInAnim = this:GetVar("anim_fade_in", "str") or "thunder_fade_in"
  local idleAnim = this:GetVar("anim_idle", "str") or "thunder_idle"
  local fadeOutAnim = this:GetVar("anim_fade_out", "str") or "thunder_fade_out"
  local sound = this:GetVar("vortex_beam_sound", "str")

  this:PlayAnim(fadeInAnim)
  this:SetAnim(idleAnim)

  local endTime = this:GetTime() + duration
  while this:GetTime() < endTime do
    local numAllies = map.SIRND(minBeams, maxBeams)
    local allies = this:GetActorsInArea(this:GetPos(), areaRadius, false, numAllies, "organic")
    for i, ally in ipairs(allies) do
      local nearestNode = this:GetNearestNode(ally:GetPos(), lightningPoints)
      if ally then
        if nearestNode == nil then
          nearestNode = "pt_lightning0" .. tostring(map.SIRND(1, 4))
        end
        this:P2PCreate(beam, nil, this, ally, nearestNode, "pt_center", nil, nil, beamDuration)
        ally:Heal(healPoints)
        ally:CreateReact(healReact)
        if sound then
          ally:PlaySnd(sound)
        end
      end
    end
    this:Sleep(map.SRND(minInterval, maxInterval))
  end

  this:PlayAnim(fadeOutAnim)
  this:Destroy()
end

function Actor:PrgPossess(params)
  local h = params.h
  if not Actor.IsValid(h) then return end
  local time = params.time
  local res = params.res
  if res then
    map.SubRes(this:GetFaction(), res, "r")
  end
  this.onPrgEnd = function()
    if Actor.IsValid(h) then
      h:StopReact("possess")
    end
    if res then
      map.AddRes(this:GetFaction(), res, "r")
    end
  end
  if time then
    h:CreateReact("possess")
    for i=1,time,1 do
      this:Sleep(1)
      if not Actor.IsValid(h) then return end
      if (h:GetVar("construction") or 0) > 0 then
        this.onPrgEnd()
        return
      end
    end  
    h:StopReact("possess")
  end
  map.SpawnConstruction(this:GetFaction(), "Breeder", h:GetPos())
  res = nil -- all done, no refund
end

function Unit:PrgHarvesterFeed(params)
  local hp = this:GetHP()
  local max = this:GetMaxHP()
  if max - hp <= 500 then return end
  local victim = params.h
  if not Actor.IsValid(victim) then return end
  victim:Execute("PrgStun")
  this:FaceTo(victim)
  local beam = nil
  this.onPrgEnd = function()
    if beam then map.RemoveP2PBeam(beam) end
    this:SetAnim()
  end
  this:PlayAnim("cast_instant")
  this:SetAnim("Hit_2")
  if not Actor.IsValid(victim) then return end
  beam = map.CreateP2PBeam("ZulTharkFeed", victim, this, "pt_top", "pt_cast")
  local ticks = 50
  local victimDrain = victim:GetMaxHP() / ticks
  local zulFill = this:GetMaxHP() * 0.2 / ticks
  while Actor.IsValid(victim) do
    victim:Damage(victimDrain, 100)
    this:Heal(zulFill)
    this:Sleep(0.1)
  end
  this.onPrgEnd()
end

function Unit:PrgZulTharkFeed(params)
  local victim = params.h
  if not Actor.IsValid(victim) then return end
  victim:Execute("PrgStun")
  this:FaceTo(victim)
  local beam = nil
  
  this.onPrgEnd = function()
    if beam then map.RemoveP2PBeam(beam) end
    this:SetAnim()
  end
  
  this:PlayAnim("heal_start")
  this:SetAnim("heal")
  
  if not Actor.IsValid(victim) then return end
  beam = map.CreateP2PBeam("ZulTharkFeed", victim, this, "pt_top", "pt_cast")
  local ticks = 70
  local victimDrain = victim:GetMaxHP() / ticks
  local zulFill = this:GetMaxHP() * 0.1 / ticks
  
  while Actor.IsValid(victim) do
    victim:Damage(victimDrain, 100)
    this:Heal(zulFill)
    this:Sleep(0.1)
  end
  
  this.onPrgEnd()
end

function Unit:PrgZulTharkHeal(params)
  local ticks = 600
  local zulFill = this:GetMaxHP() * 0.5 / ticks
  
  this.onPrgEnd = function()
    this:SetAnim()
  end
  
  this:PlayAnim("heal_start")
  this:SetAnim("heal")
  
  while ticks ~= 0 do
    this:Heal(zulFill)
    ticks = ticks - 1
    this:Sleep(0.1)
  end
  
  while true do
    this:Sleep(1)
  end
end

function Unit:PrgErkhArulThunderStorm(params)
  this.onPrgEnd = function()
    this:SetAnim()
  end
  
  this:PlayAnim("levitation_start")
  this:SetAnim("levitation_loop")
  
  local duration = params.duration or 30
  local minBeams = params.beams_min or 1
  local maxBeams = params.beams_max or 1
  local minSleep = params.sleep_time_min or 1
  local maxSleep = params.sleep_time_max or 1
  
  local areaRadius = params.area or 3000
  local lightning = this:SplitAnimParam(params.lightnings or "")
  local effect = params.effect
  local endTime = map.GetTime() + duration
    
  while map.GetTime() < endTime do
    local numEnemies = map.SIRND(minBeams, maxBeams)
    local enemies = this:GetActorsInArea(this:GetPos(), areaRadius, true, numEnemies)
    if table.getn(enemies) == 0 then break end
    
    for _, enemy in ipairs(enemies) do
      if lightning then
        map.SpawnObject(lightning[map.SIRND(1, table.getn(lightning))], enemy:GetPos(), this:GetFaction())
      end
      if effect then this:SpawnEffect(effect, enemy) end
    end

    this:Sleep(map.SRND(minSleep, maxSleep))
  end

  this:PlayAnim("levitation_finish")
  this.onPrgEnd()
end

function Unit:PrgErkhArulShipHeal(params)
  local beam = nil
  local damageBeam = nil
  local ship = params.h
  if not ship then return end

  this.onPrgEnd = function()
    if beam then map.RemoveP2PBeam(beam) end
    if damageBeam then map.RemoveP2PBeam(damageBeam) end
  end

  this:FaceTo("reset")
  this:FaceTo(ship)

  this:PlayAnim("levitation_start")
  this:SetAnim("levitation_loop")

  local healPerc = params.heal_perc or 10
  local duration = params.duration or 10
  local ticks = duration * 10
  local erkhFill = this:GetMaxHP() * healPerc / 100 / ticks
  local shipDrain = ship:GetMaxHP() / ticks
  local damage = ship:GetVar("hacked") == 1
  
  if damage then
    damageBeam = map.CreateP2PBeam("ErkhArulDamage", ship, this, "pt_top", "pt_cast")
  else
    beam = map.CreateP2PBeam("ErkhArulHeal", ship, this, "pt_top", "pt_cast")
  end
  
  while Actor.IsValid(ship) do
    if damage then
      this:Damage(erkhFill, 100)
    else
      this:Heal(erkhFill)
    end
    ship:Damage(shipDrain, 100)
    ticks = ticks - 1
    this:Sleep(0.1)
    damage = ship:GetVar("hacked") == 1
    
    if damage and not damageBeam then
      if beam then 
        map.RemoveP2PBeam(beam)
        beam = nil
      end
      damageBeam = map.CreateP2PBeam("ErkhArulDamage", ship, this, "pt_top", "pt_cast")
    end
  end
  
  this.onPrgEnd()
  this:PlayAnim("levitation_finish")
  this:SetAnim()
end

function Unit:RenegadeEggSpawn(params)
  this.spawner:ProcessSpawnList(this)
end

function Unit:PrgDomSiege(params)
  this.onPrgEnd = function()
    this:SetAnim()
    
  end
  local siegeAnimLength = this:GetAnimLength("siege_start")
  local standLength = this:GetAnimLength("stand")
  local foot1Time = this:GetAnimKeyTime("siege_start", "Foot02_down")
  local foot2Time = this:GetAnimKeyTime("siege_start", "Foot01_down")
  local shoot1Time = this:GetAnimKeyTime("siege_shoot_1", "action")
  local shoot2Time = this:GetAnimKeyTime("siege_shoot_2", "action")
  local shoot1Length = this:GetAnimLength("siege_shoot_1")
  local shoot2Length = this:GetAnimLength("siege_shoot_2")
  local firstEnemyFaced = false
  local searchRange = this:GetVar("sight_in_combat")
  local leftHand = true
  
  while true do
    local enemy = this:FindEnemy(this:GetPos(), searchRange, 40, true)
    
    if not firstEnemyFaced and enemy then
      this:FaceTo("reset")
      this:FaceTo(enemy)
      firstEnemyFaced = true
      this:SetAnim("siege_start")
      this:SetInteractive(false)
      this:Sleep(foot1Time)
      map.SpawnObject("PuffDust", this:GetNodePos("pt_footprint02"))
      this:Sleep(foot2Time - foot1Time)
      map.SpawnObject("PuffDust", this:GetNodePos("pt_footprint01"))
      this:Sleep(siegeAnimLength - foot2Time)
      this:SetAnim("siege_shoot_idle")
      enemy = this:FindEnemy(this:GetPos(), searchRange, 40, true)
    end
    
    local nearestEnemy, range = this:FindNearestEnemy(this:GetPos(), searchRange)
    
    if range and range < 650 then
      if firstEnemyFaced then
        this:PlayAnim("stand")
        this:Sleep(standLength)
        this:SetInteractive(true)

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
        this:Sleep(standLength)
        this:SetInteractive(true)
      end
      this:SetAnim()
      return
    end
    this:Sleep(0.3)
  end
  this.onPrgEnd()
end