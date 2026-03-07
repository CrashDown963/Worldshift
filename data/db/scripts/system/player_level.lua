-- Player Level System con Persistencia
-- Manages player level, XP, and skill points with persistence between sessions

PlayerLevel = PlayerLevel or {}

function PlayerLevel:Load()
  local data = game.LoadUserPrefs("PlayerLevel")
  if data then
    self.current_level = data.level or 1
    self.current_xp = data.xp or 0
    self.session_xp_gained = 0  -- Siempre empieza en 0 cada sesión
  else
    self.current_level = 1
    self.current_xp = 0
    self.session_xp_gained = 0
  end
  self:UpdateSkillPoints()
end

function PlayerLevel:Save()
  local data = {
    level = self.current_level,
    xp = self.current_xp,
  }
  game.SaveUserPrefs("PlayerLevel", data)
end

function PlayerLevel:AddXP(amount)
  if not amount or amount == 0 then return end
  self.current_xp = self.current_xp + amount
  self.session_xp_gained = self.session_xp_gained + amount
  self:CheckLevelUp()
  self:Save()  -- Guardar después de añadir XP
end

function PlayerLevel:CheckLevelUp()
  local leveled_up = false
  while self.current_level < 100 do
    local xp_needed = self:GetXPForNextLevel()
    if self.current_xp >= xp_needed then
      self.current_xp = self.current_xp - xp_needed
      self.current_level = self.current_level + 1
      self:UpdateSkillPoints()
      leveled_up = true
    else
      break
    end
  end
  if leveled_up then
    self:OnLevelUp()
    self:Save()
  end
end

function PlayerLevel:GetXPForNextLevel()
  return self.current_level * 100
end

function PlayerLevel:UpdateSkillPoints()
  self.skill_points = 10 + math.floor(self.current_level / 10)
end

function PlayerLevel:GetMaxSkillPoints()
  return self.skill_points
end

function PlayerLevel:GetLevel()
  return self.current_level
end

function PlayerLevel:GetCurrentXP()
  return self.current_xp
end

function PlayerLevel:GetSessionXP()
  return self.session_xp_gained
end

function PlayerLevel:OnLevelUp()
  if ui and ui.ErrText then
    ui.ErrText:ShowText("LEVEL UP! Level " .. self.current_level)
  end
end

-- Cargar datos al inicializar
PlayerLevel:Load()

