function Surgeon:PrgIdle(params)
  local fStartTime = this:GetTime()
  local hOrig = params.hOrig or params.h or map.GetActorByHandle(this:GetVar("idle_follow", "int"))
  local ptOrig = hOrig and hOrig:GetPos() or params.ptOrig or params.pt or this:GetPos()

  this.onPrgSave = function()
    params.hOrig = hOrig
    params.ptOrig = ptOrig
    return params
  end

  if params.ptOrig then -- restoring a program?
    ptOrig = params.ptOrig
  end
  
  this:SurgeonBehave(ptOrig, hOrig, 0, 30, (params.dblclk or 0) ~= 0)
end

function Surgeon:PrgAttack(params)
  local h = params.h
  local pt = params.pt
  local minRange, maxRange = this:GetAttackRanges(h)
  
  if not Actor.IsValid(h) then
    this:MoveTo(pt, nil, nil, maxRange)
    return;
  end

  this:SurgeonBehave(nil, h, 0, 60, (params.dblclk or 0) ~= 0)
end
