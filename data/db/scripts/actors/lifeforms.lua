-- Moves actor toward a target (with move min and max range) and checks actor not to get too far
function LifeForm:MoveSafe(enemy, minMoveRange, maxMoveRange, ptOrigPos, maxReachedRange)
  if not Actor.IsValid(enemy) then return "OUTOFRANGE" end 
  if this:DistTo(enemy) <= maxMoveRange then
    this:StopMoving() 
    return nil
  end

  while true do
    if not Actor.IsValid(enemy) then return "OUTOFRANGE" end 
    if not Actor.IsValid(this) then return "OUTOFRANGE" end 
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
    local res = this:MoveTo{enemy, maxRange = range, timeout = 1}
    if res ~= "TIMEOUT" then break end
  end

  return nil
end

-- Fights Enemy till enemy is a valid target, or when moves out of the Fight range!
function LifeForm:FightEnemy(enemy)
  this:SetPrimaryTarget(nil, enemy)
  
  if Actor.IsValid(enemy) then
    this:StopMoving()
  end
  
  local res

  --while true do 
  
    if (not this.ConsiderAOE) or (not this:ConsiderAOE(enemy)) then
      res = this:Fight()
    end  
  --  if res then break end
  --end

  return res
end

function LifeForm:PrgIdle(params)
  local ptOrig = params.ptOrig or this:GetPos()
  local bAI = this:IsAI()
  local fLastWanderTime = -100
  local xMinWanderRange = 200
  local fTime
  local ptWanderDest = nil
  --local sight = this:GetSight()

  this:SetPrimaryTarget()

  this.onPrgSave = function()
    params.ptOrig = ptOrig
    return params
  end

  if params.ptOrig then -- restoring a program?
    this:MoveTo(params.ptOrig)
  end
  
  if not this:HasWeapon() then
    while true do this:Idle(5) end
  end
  
  while 1 do
    local minRange, maxRange = this:GetAttackRanges(nil)
    local aggRange = this:GetVar("aggro_range") or 2000
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
--    if this:IsAI() then
--      if not bAI then
--        return
--      end 
--      LFERange = -1;
--    end  

    local enemy = this:FindEnemy(ptOrig, LFERange)
    while this:FightEnemy(enemy) == "OUTOFRANGE" do 
      local res
      if this:IsAI() then
        while true do
          minRange, maxRange = this:GetAttackRanges(enemy)
          res = this:MoveTo{enemy, maxRange = maxRange, timeout = 1}
          if res == "TIMEOUT" then 
            enemy = this:FindEnemy(ptOrig, LFERange)
            if not Actor.IsValid(enemy) then break end 
          else
            break
          end
        end  
        this:StopMoving()
      else
        minRange, maxRange = this:GetAttackRanges(enemy)
        res = this:MoveSafe(enemy, minRange, maxRange, ptOrig, aggRange)
      end  
      if res then
        enemy = nil
        break
      end        
    end

    if not enemy then
      if not ptWanderDest and fLastWanderTime + 5 < this:GetTime() then
        ptWanderDest = this:GetWanderDest(ptOrig)
      end
      if ptWanderDest then
        if this:MoveTo{ptWanderDest, timeout = 1} ~= "TIMEOUT" then
          ptWanderDest = nil
          fLastWanderTime = this:GetTime()
          this:Idle(1)
        end
      else
        this:StopMoving()
        this:Idle(1)
      end
    end  
  end 
end