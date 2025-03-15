--
-- Transitions
--

local trans = {}
local calls = {}
local intervals = {}

Transitions = uiwnd {}

function Transitions:Cancel(wnd)
  for i, t in ipairs(trans) do
    if (t.inw and t.inw == wnd) or (t.outw and t.outw == wnd) then 
      table.remove(trans, i)
    end  
  end
end

function Transitions:CancelRepeat(i)
  table.remove(intervals, i)
end

function Transitions:CancelRepeat(i)
  table.remove(intervals, i)
end

function Transitions:CancelOnce(i)
  table.remove(calls, i)
end

function Transitions:Fade(outw, inw, func, time)
  if outw and outw:IsHidden() then outw = nil end
  if not outw and not inw or outw == inw then return end

  for i, t in ipairs(trans) do
    if (t.inw and (t.inw == inw or t.inw == outw)) or (t.outw and (t.outw == inw or t.outw == outw)) then 
      table.remove(trans, i)
    end  
  end

  --table.insert(trans, {outw = outw, inw = inw, func = func, time = time or 0.3, elapsed = 0} )
  if not time or time <= 0 then time = 0.3 end
  table.insert(trans, {outw = outw, inw = inw, func = func, time = time, elapsed = 0} )      
  this:Show()
end

function Transitions:CallOnce(func, time)
  if not time or time <= 0 then time = 0.3 end
  table.insert(calls, {func = func, time = time, elapsed = 0} )
  this:Show()
  return #calls
end

function Transitions:CallRepeat(func, interval, param)
  if not interval or interval < 0 then interval = 0 end
  table.insert(intervals, {func = func, interval = interval, elapsed = 0, param = param} )
  this:Show()
  return #intervals
end

function Transitions:OnUpdate()
  for i, c in ipairs(intervals) do
    c.elapsed = c.elapsed + argElapsed
    if c.elapsed >= c.interval then
      c.elapsed = 0
      local res,prm = c.func(c.param, argElapsed)
      if prm then c.param = prm end
      if res then
        if res == 0 then 
          table.remove(intervals, i) 
        else
          c.interval = res
        end  
      end  
    end  
  end

  for i, c in ipairs(calls) do
    c.elapsed = c.elapsed + argElapsed
    if c.elapsed >= c.time then
      table.remove(calls, i)
      if c.func then c.func() end
    end  
  end
  
  for i, t in ipairs(trans) do
    if t.done then 
      table.remove(trans, i) 
      if t.func then t.func() end
    else  
      local inw = t.inw
      local outw = t.outw
      
      t.elapsed = t.elapsed + argElapsed
      
      local alpha = t.elapsed / t.time
      local done = alpha > 1 or nil
      if alpha > 1 then alpha = 1 end
      
      if outw then outw:SetAlpha(1 - alpha) end
      
      if not outw and inw then 
        inw:SetAlpha(alpha) 
        inw:Show() 
      end
      if done then 
        if outw then 
          outw:Hide() 
          outw:SetAlpha(1) 
          if inw then 
            t.elapsed = 0
            t.outw = nil
            return
          end
        end       
        t.done = 1
      end
    end
  end
      
  if #trans == 0 and #calls == 0 and #intervals == 0 then this:Hide() end
end
