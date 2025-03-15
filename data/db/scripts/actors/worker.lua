--
-- Worker scripts
--

function Worker:PrgIdle(params)
  this:SetPrimaryTarget()
  if not this:IsAI() then
    Unit.PrgIdle(this, params)
  end
  local actBuild = this:FindActionByPrg("PrgMakeStructure")
  while true do 
    this:Idle(1)
    this:SetPrimaryTarget()
    if actBuild then
      local hXeno = map.FindNearestXenolite(this:GetPos(), nil, this:GetFaction())
      if hXeno then
        this:ExecuteAction(actBuild, { h = hXeno })
      end
    end
  end    
end

function Worker:PrgField(params)
  local field = params.h
  if params.search_field then
    if this:MoveTo{field} then return end
    field = this:FindField()
  end
  while true do
    if this:MoveTo{field, minRange = 400} then return end
    while true do
      if not Actor.IsValid(field) then return end
      if field:RegisterWorker(this) then break end
      this:Sleep(1)
    end
    this.onPrgEnd = function() field:UnregisterWorker() this:SetAnim() end
    this:MoveTo{field:GetRandomPos()}
    this:SetAnim("field")
    while true do
      this:Sleep(1)
      if field:IsFoodReady() then break end
    end
    this:SetAnim()
    
    local pos, id, farm
    while true do
      pos, id, farm = this:FindFarmSpot()
      if id then break end
      this:Sleep(1)
    end
    
    field:UnregisterWorker()

    this.onPrgEnd = function() this:FreeFarmSpot(farm, id) end
    if this:MoveTo{pos} then break end 
    this:FaceTo(farm)
    this:Sleep(2)
    if not Actor.IsValid(farm) then break end
    this:DeliverFood()
    this:FreeFarmSpot(farm, id)
    this.onPrgEnd = nil
  end
end

