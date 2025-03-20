function Turret:PrgIdle(params)
  this:SetPrimaryTarget()
    while true do
      this:Idle(1)
    end
end

function Turret:PrgDespawn(params)
  this:SetVar("indestructible", 0)
  this:Die()
end
