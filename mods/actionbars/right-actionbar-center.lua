local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Right Actionbar Center",
    description = "Moves the right Actionbar to the center of the screen.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = true,
})

module.enable = function(self)
 --make MultiBarBottomRight Horizontal
 -- anchor buttons 2-12 to the right of button 1

  for i = 2, 12 do
		local b = 5
        local button = _G['MultiBarRightButton' .. i]
        button:ClearAllPoints()
		button:SetFrameStrata("BACKGROUND")
         if mod(i - 1, b) == 0 then
             button:SetPoint('TOP', _G['MultiBarRightButton' .. (i - b)], 'BOTTOM', 0, -6)
         else
             button:SetPoint('LEFT', _G['MultiBarRightButton' .. (i - 1)], 'RIGHT', 6, 0)
         end
     end
 -- anchor button 1 so 12 buttons are centered above default bars
MultiBarRightButton1:ClearAllPoints()
MultiBarRightButton1:SetFrameStrata("BACKGROUND")
MultiBarRightButton1:SetPoint("CENTER",UIParent,"CENTER",-84,-185)

local function powerpos()
	if DeliPower then
	MultiBarRightButton1:SetPoint("CENTER",PlayerFrameManaBar,"CENTER",-84,-31)
	elseif DeliPower2 then
	MultiBarRightButton1:SetPoint("CENTER",PlayerFrameManaBar,"CENTER",-84,-24)
	end
end

function barsize(MultiBarRightButton)
for i = 1, 12 do
	local bar =_G['MultiBarRightButton' .. i]
	bar:SetScale(1.1)
	
	
end
	end
	barsize()
	
	
	 local timer = CreateFrame("Frame")
  timer:Hide()
  timer:SetScript("OnUpdate", function()
    if GetTime() >= timer.time then
      timer.time = nil
      powerpos()
      this:Hide()
      this:SetScript("OnUpdate", nil)
    end
  end)

  local events = CreateFrame("Frame", nil, UIParent)
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:SetScript("OnEvent", function()
      -- trigger the timer to go off 1 second after login
      timer.time = GetTime() + 1
      timer:Show()
    end)
	end
