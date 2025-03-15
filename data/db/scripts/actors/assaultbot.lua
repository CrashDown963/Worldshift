function AssaultBot:PrgBarrage(params)
  local pt = params.pt
  local res = this:MoveTo{pt, maxRange = this:GetVar("barrage_range") }
  this:StartActionCooldown(params.action)
  if params.sound then
    this:PlaySnd(params.sound)
  end
  this:EnterState("barrage", pt)
end

function AssaultBot:ConsiderAOE(hTarget)
  if not this:IsAI() then return nil end
  if not Actor.IsValid(hTarget) then return nil end
  local pwr = this:GetVar("barrage_cost")
  if this:GetPower() < pwr then return nil end
  local dist = this:DistTo(hTarget)
  local unit_range = this:GetVar("barrage_range")
  local barrage_min_range = this:GetVar("barrage_min_range")
  if dist > unit_range or dist < barrage_min_range then return nil end
  local a,e = this:EstimateAOE(hTarget:GetPos(), 600)
  if e < 500 then return nil end
  if e < 2 * a then return nil end
  this:EnterState("barrage", hTarget:GetPos())
  return true
end  
