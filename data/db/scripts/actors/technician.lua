--
-- Technician scripts
--

function Technician:PrgIdle(params)
  this:SetPrimaryTarget()
  if not this:IsAI() then
    Unit.PrgIdle(this, params)
  end
  this:Idle(1)
  while true do 
    this:SetPrimaryTarget()
    local pile = this:FindSupplyPile(3000,1)
    if pile then
      this:MoveSupplies(pile)
      this:Idle(1)
    else  
      local bldg = this:FindBuildingToBuild(3000,1)
      if bldg then
        local prm = {}; prm.h = bldg
        this:PrgBuild(prm)
        this:Idle(1)
      else
        local mine, silo, sbuilt = this:FindMine(0)
        if mine then
          if mine:GetAmount() > 0 then
            if silo then
              if sbuilt then
                local prm = {}; prm.h = mine
                this:PrgMine(prm)
                this:Idle(1)
              else
                local prm = {}; prm.h = silo
                this:PrgBuild(prm)
                this:Idle(1)
              end
            else  
              local pt = map.FindBuildSpot(this:GetFaction(), "Silo", mine:GetPos(), 2000)
              if pt then
                local prm = {}; prm.h = map.SpawnConstruction(this:GetFaction(), "Silo", pt);
                if prm.h then
                  this:PrgBuild(prm)
                  this:Idle(1)
                else  
                  this:Idle(1)
                end  
              else
                this:Idle(1)
              end
            end
          else
            local xtor = mine:GetExtractor()
            if xtor then
              local prm = {}; prm.h = xtor
              this:PrgBuild(prm)
            end
            this:Idle(1)
          end  
        else
          this:Idle(1)
        end  
      end
    end  
  end  
end

function Technician:MoveSupplies(pile)
  local crate, pt, silo
  local pile_pos = pile:GetPos()

  local oldPrgEnd = this.onPrgEnd
  this.onPrgEnd = function()
    this:SetAnim()
    this:SetPrimaryTarget()
    if oldPrgEnd then
      oldPrgEnd()
    end  
  end

  this:SetPrimaryTarget(nil, pile)
  
  while true do
    crate, pt = this:FindCrate(pile)
    if not crate then 
      this:MoveTo{pile_pos}
      break
    end
    
    if this:MoveTo{pt} then break end
    if this:PickCrate(crate) then
      while true do
        while true do
          silo = this:FindSilo()
          if silo then break else this:Idle(1) end
        end
        
        this:SetAnim("mine_carry")
        if not this:MoveTo{silo} then break end
      end
            
      this:SetAnim()
      
      this:DeploySupplies(silo)
    end
  end
  this.onPrgEnd = oldPrgEnd
  this:SetPrimaryTarget()
end

function Technician:PrgOrderSupplies(params)
  local pt = params.pt
  local id, boss = this:RequestSupplies(pt)
  local pile
  
  if not id then return end
  
  if this == boss then
    this.onPrgEnd = function() this:CancelSupplies(id) this:SetAnim() end
  end
  
  local res = this:MoveTo{pt, maxRange = 50}
  if res then
    return
  end

  if this == boss then
    this:SetAnim("supply_down_loop")
  end
  
  while true do
    pile = this:WaitForSupplies(id)
    if pile then break end
    this:Idle(1) 
  end

  this:SetAnim()
  this.onPrgEnd = nil
  
  this:MoveSupplies(pile)
end
  
function Technician:PrgMoveSupplies(params)
  local pile = params.h
  this:MoveSupplies(pile)
end

function Technician:PrgMine(params)
  local hOre = params.h
  local ptOre = hOre:GetPos()
  local pt, ptIndex, silo
  
  local attach = this:GetVar("mine_loop_attach", "str")
  local attach_point = this:GetVar("mine_loop_source", "str")
  

  this.onPrgEnd = function()
  
    -- unlock Ore
    if ptIndex and ptIndex > 0 then 
      this:UnlockOreSpot(hOre, ptIndex)
    end  
    
    this:SetAnim()
    this:SetPrimaryTarget()
    
    if attach_point and attach then 
      this:RemoveAttachments(attach_point) 
    end
    
  end
  
  this:SetPrimaryTarget(nil, hOre)  
  
  while true do
    this:SetAnim()

    -- Move to close distance to mine!    
    local res = this:MoveTo{hOre, maxRange = 400}    
    if res then 
      this:SetPrimaryTarget()
      return 
    end
    
    pt, ptIndex = this:FindOreSpot(hOre)
    if not pt then break end
     
    -- Found point
    if ptIndex > 0 then 
      local res = this:MoveTo{pt, maxRange = 50}
      if res then 
        this:SetPrimaryTarget()
        return 
      end  
      
      this:SetAnim("mine_loop")
      
      -- Attach!
      if attach_point and attach then 
        this:AttachAnim(attach_point, attach)
      end
      
      res = this:Mine(ptIndex, hOre)
      this:UnlockOreSpot(hOre, ptIndex)
      ptIndex = 0
      
      -- Remove attach 
      if attach_point and attach then 
        this:RemoveAttachments(attach_point) 
      end
            
      if res == "OK" then
        this:SetAnim()
        while true do
          silo = this:FindSilo() 
          if silo then break else this:Idle(1) end
        end
        
        this:SetAnim("mine_carry")
        this:MoveTo{silo}
        this:SetAnim()
        this:DeployOre(silo)
      end
      if this:IsAI() then
        this:SetAnim()
        this:SetPrimaryTarget()
        return
      end
      
    -- Not avail at this moment!
    else
      this:FaceTo(hOre);
      this:Idle(0.5)
    end      
  end
  
  this:SetPrimaryTarget()
  if not this:IsAI() then
    this:MoveTo{ptOre}
  end  
end

