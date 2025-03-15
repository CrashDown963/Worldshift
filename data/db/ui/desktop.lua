--
-- DESKTOP
--

DESKTOP = uiwnd {
}

local DefErrorFunc = function(str, title)
  if MessageBox and MessageBox.Alert then
    MessageBox:Alert(str, title)
  end
end

function DESKTOP:OnLoad()
  this:RegisterEvent("APP_START")
end

function DESKTOP:OnEvent(event)
  if event == "APP_START" then
    _ERROR = DefErrorFunc
  end
end

function DESKTOP.GetLinkInfo(type, id)
  local color = colors.blue
  local rollover = colors.red
  local cursor = "hand"

  if type == "item" then
    local q = game.GetItemQuality(id)
    color = ItemColors["q"..q]
    rollover = {math.min(255,color[1]*1.2), math.min(255,color[2]*1.2), math.min(255, color[3]*1.2)}
  end
  
  if type == "player" then
    color = colors.yellow
  end
  
  if string.sub(type, 1, 5) == "chat_" then 
    return ChatGetLinkInfo(type, id)
  end

  return color, rollover, cursor
end

function DESKTOP:CreateItemLink(item)
  if not item then return end
  --local text = string.upper(TEXT{item.id .. ".name"})
  local text = TEXT{item.id .. ".name"}
  local link = "<link=item:"..item.id..">["..text.."]</>"
  if LobbyChat.TextEdit:IsHidden() == false then 
    LobbyChat.TextEdit:ReplaceSelection(link)
  elseif Chat.TextEdit:IsHidden() == false then
    Chat.TextEdit:ReplaceSelection(link)
  end
end

function DESKTOP:OnQuit()
  MessageBox:Prompt(TEXT("quit_prompt"), nil, function() game.Quit(1) end)
end
