function Bird:PrgIdle(params)
  --this:SetAnim("fly")
  while true do
    --local anims = { "fly", "soar", "landing", "run", "peack", "rising" }
    
    res = this:Process()
    if res ~= "PROCEED_EXIT" and res ~= "OK" then 
      this:Destroy() 
      return
    end
    
    if res == "PROCEED_EXIT" then 
      local pt = this:GetExitPoint()
      this:MoveTo{pt}
      this:Destroy() 
      return
    end

    local fSleepTime, ptDst, fMoveTime = this:GetGroundPattern()
    if ptDst and fMoveTime then 
      this:SetAnim("run")
      this:MoveTo{ptDst, timeout = fMoveTime}
    end
    
    if fSleepTime then 
      this:SetAnim("peack")
      this:Sleep(fSleepTime)
      this:SetAnim()
    end
   
  end
end
