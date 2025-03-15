function Building:PrgIdle(params)
  while 1 do
    this:Idle(5)
  end
end

function Building:PrgUpgrade(params)
  local duration = params.int
  local type = params.str
  this:Upgrade(type)
end

function Building:PrgConvertToMainBuilding(params)
  this:AttachAnim(params.anim_point, params.loop_anim, { auto_size_base = 0 })
  this.onPrgEnd = function() this:RemoveAttachments(params.anim_point, params.loop_anim) end
  local res = this:Upgrade(params.str)
  if res ~= "OK" then return end
  this.onPrgEnd() this.onPrgEnd = nil
  if params.finish_type == "nif" then
    map.PlayAnim(this:GetPos(), params.finish_anim)
  elseif params.finish_anim then
    this:AttachAnim(params.anim_point, params.finish_anim, { auto_size_base = 0 })
  end
  this:Sleep(params.finish_duration or 1)
  local target = map.SpawnObject(params.id, this:GetPos(), this:GetFaction())
  if (params.target_start_anim) then
    target:ResetAnimations()
    target:SetAnim(params.target_start_anim)
  end
  local selected = this:IsSelected()
  this:Destroy()
  if selected then
    target:Select()
  end
end

function Building:PrgSpell(params)
  local spell = params.str
  local h = params.h
  local pt = params.pt
  this:CastSpell(h or pt, spell)
end

function Building:TempleAlert(params)
  local pos = this:GetGLNodePos("pt_top")
  local obj = map.SpawnObject("DarkWind", pos, this:GetFaction())
  obj:SetVar("creator_h", this.h)
  if obj then
    return tostring(obj.h)
  end
end

function Building:TempleRetreat(params)
  if not params.alert_return then return end
  local wind = map.GetActorByHandle(tonumber(params.alert_return))
  if wind and wind.idle then wind:Execute("PrgFade") end
end

function Building:SpawnWorkers(params)
  local objectId = params.object_id or "Worker"
  local count = params.count or 3
  map.DespawnWorkers(this:GetFaction())
  map.SpawnObjects(objectId .. " = " .. count, this:GetPos(), this:GetFaction());
end

