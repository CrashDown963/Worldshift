function Turret:PrgIdle(params)
  this:SetPrimaryTarget()
  --if not this:HasWeapon() then
  --  while true do this:Idle(5) end
  --end
  
  --if this:Fight() == "NOWEAPON" then
    while true do
      this:Idle(1)
    end
  --end
  --local minRange, maxRange = this:GetAttackRanges(nil)
  --local pos = this:GetPos()
  --while 1 do
  --  local enemy = this:FindEnemy(pos, maxRange)
  --  if enemy then
  --    this:SetPrimaryTarget(nil, enemy)
  --    while not this:Fight() do end
  --  else
  --    this:Idle(1)
  --  end
  --end 
end

function Turret:PrgDespawn(params)
  this:SetVar("indestructible", 0)
  this:Die()
end
