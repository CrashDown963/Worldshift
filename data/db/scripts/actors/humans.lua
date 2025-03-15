--
-- Humans specific programs
--


function RepairDrone:PrgIdle(params)
  this:SetAnim("spin_around")
  this:RepairUnits()
  this:PlayAnim("die")
  local time = this:Disappear()
end

function Constructor:PrgNanoRestore(params)

  local range = this:GetVar("nano_restore_range")
  local maxrange = this:GetVar("nano_restore_max_range")
  local duration = this:GetVar("nano_restore_duration") or 1
  local spawn_time = this:GetVar("nano_restore_beam_spawn_time") or 1
  local beams = duration / spawn_time
  local attach = this:GetVar("nano_restore_attach", "str")
  local attach_point = this:GetVar("nano_restore_source", "str")
  local hUnit = params.h
  
  this.onPrgEnd = function()
    this:SetPrimaryTarget()
    this:SetAnim()
    if attach_point and attach then 
      this:RemoveAttachments(attach_point) 
    end
    
    this:ClearBeams()
  end
  
  --Move to!  
  if range then 
    if this:MoveTo{hUnit, maxRange = range} then return end
  else 
    if this:MoveTo{hUnit} then return end
  end

  -- Get mana!
  if not this:DrainPower(this:GetVar("nano_restore_power")) then return end
  this:SetAnim("cast_nano_restore_channeling")
  
  -- Attach!
  if attach_point and attach then 
    this:AttachAnim(attach_point, attach)
  end
  
    
  for i = 1,beams do
  
    -- face target
    this:FaceTo(hUnit)
    
    local Dist = this:DistTo(hUnit)
    
    if not Dist then return end
    -- bigger distance?
    if  Dist > maxrange then return end
    
    -- restore
    if not this:NanoRestore(hUnit) then return end
    this:Sleep(spawn_time)
  end
  
end


function Constructor:PrgNanoFix(params)
  local range = this:GetVar("nano_fix_range")
  local hUnit = params.h
  local spawn_time = this:GetVar("nano_fix_beam_timelife") or 1
  
  this.onPrgEnd = function()
    this:SetPrimaryTarget()
    this:SetAnim()
    this:ClearBeams()
  end
  
  --Move to!  
  if range then 
    if this:MoveTo{hUnit, maxRange = range} then return end
  else 
    if this:MoveTo{hUnit} then return end
  end

  -- Get mana!
  if not this:DrainPower(this:GetVar("nano_fix_power")) then return end
  
  -- face target
  this:FaceTo(hUnit)
  this:CastSpell(this:GetPos(), "CastNanoFix")  
 
  -- fix
  this:NanoFix(hUnit)
  
  local react = this:GetVar("nano_fix_react", "str") or "nanofix"
  hUnit:CreateReact(react);
  
  this:Sleep(spawn_time);
end

-- Sequence!
function Trooper:PrgSequenceAction(params)

  this.onPrgEnd = function() 
    this:SetAnim() 
  end


  while 1 do
    local a = this:ActionSequenceWaitFeedback()
    if a == "FINISHED" or a == "FAIL" then break end
    if a == "1" then
      this:SetAnim("sequence_1")
      this:Sleep(this:GetRanged(0.0, 0.5))
    elseif a == "2" then 
      this:CastSpell(this:GetPos(), "Trooper_Sequence_Finish")
    end      
    this:ActionSequenceNextAction()
  end 
  
end


