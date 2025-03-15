--
-- Actor specific programs
--

function Actor:PrgIdle(params)
  while 1 do
    this:Idle(1)
  end
end

function Actor:PrgDespawn(params)
  this.onPrgEnd = function()
    print("Despawning actor")
  end
  this:SetVar("uninterruptible", 1);
  local react = this:GetVar("despawn_react") or "respawn_react";
  if react and react ~= "" then
    this:CreateReact(react)
  end  
  this:Idle(0.2)
  this.onPrgEnd = nil
  this:Destroy()
end

function Actor:PrgMove(params) -- pt - point, h - actor, dblclk - double clicked

  local pt = params.pt
  local h = params.h
  local walk = false --(params.dblclk == 1 or nil) and this:GetAnimLength("walk")
  local origSpeed, walkSpeed

  this.onPrgEnd = function()
    if origSpeed then
      this:SetVar("speed", origSpeed)
      this:CancelRemap()
    end
    this:KeepFollowingTarget(0)
    this:FailMoveOnLoseTarget(1)
  end
  
  if (params.cancel_on_cc or 0) ~= 0 then
    this.onPrgSave = function()
      params.h = nil
      params.pt = this:GetPos()
      return params
    end
  end

  if params.speed then
    origSpeed = this:GetVar("speed")
    this:SetVar("speed", params.speed)
  elseif walk then
    origSpeed = this:GetVar("speed")
    this:SetVar("speed", this:GetVar("walk_speed"))
    this:RemapAnim("run", "walk");
  end

  if not Actor.IsValid(h) then
    this:MoveTo(pt)
    this:SetVar("zero_aggro_range_time", this:GetTime() + 10)
    -- this.onPrgEnd()
    return;
  end

  this:FailMoveOnLoseTarget(0)
  this:KeepFollowingTarget(1)
  local range = this:GetSight()
  local timeout = 1
  while Actor.IsValid(h) do
    pt = h:GetPos();
    if timeout > 0 and this:InRange(h, range) then
      this:FailMoveOnLoseTarget(1)
      this:KeepFollowingTarget(0)
      timeout = 0
    end
    local res = this:MoveTo{h, timeout = timeout}
    if res ~= "TIMEOUT" then 
      this:SetVar("zero_aggro_range_time", this:GetTime() + 10)
      -- this.onPrgEnd()
      return
    end
  end

  this:FailMoveOnLoseTarget(1)
  this:KeepFollowingTarget(0)
  this:MoveTo(pt, nil, range)
end

function Actor:PrgDoAbility(params)
  this:DoAbility(params.abi, params.h, params.pt)
end

function Actor:PrgCallMapLua(params)
  if map[params.func] then
    map[params.func](this, params)
  end
end

function Actor:CallMapLua(params)
  if not params.actor then params.actor = this end
  if not params.faction then params.faction = this:GetVar("faction") end
  if map[params.func] then
    map[params.func](params)
  end
end

function Actor:MapLuaCheckActionVisible(params)
  return map.CheckActionVisible(this, params)
end

function Actor:PrgReinforce(params)
  if params.sound then this:PlaySnd(params.sound) end
  map.RefillForces(this)
end

function Actor:PrgWSAD(params)
  this:StopMoving()
  this:WSAD()
end

function Actor:PrgPlayAnim(params)
  this:ResetAnims()
  this:PlayAnim(params.anim, true)
end

function Actor:SplitAnimParam(anims)
  if anims == nil then return nil end
  local animsArr = {}
  local ind = string.find(anims, ",")
  local prevInd = 0
  
  while ind ~= nil do
    local chunk = string.sub(anims, prevInd + 1, ind - 1)
    chunk = string.gsub(chunk, "^%s*(.-)%s*$", "%1") -- Trim :)
    table.insert(animsArr, chunk)
    prevInd = ind
    ind = string.find(anims, ",", ind + 1)
  end
  
  local last = string.sub(anims, prevInd + 1)
  last = string.gsub(last, "^%s*(.-)%s*$", "%1")
  table.insert(animsArr, last)
  return animsArr
end
