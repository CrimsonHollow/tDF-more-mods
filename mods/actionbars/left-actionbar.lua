local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Left Actionbar",
    description = "Moves the Left Actionbar to the center of the screen.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = true,
})

module.enable = function(self)
 --make MultiBarBottomLeft 4x3 grid
 -- anchor buttons 2-12 to the right of button 1

    for i = 2, 12 do
        local button = _G['MultiBarLeftButton' .. i]
        button:ClearAllPoints()
		button:SetFrameStrata("BACKGROUND")
        if mod(i - 1, 3) == 0 then
            button:SetPoint('LEFT', _G['MultiBarLeftButton' .. (i - 3)], 'RIGHT', 6, 0)
        else
            button:SetPoint('TOP', _G['MultiBarLeftButton' .. (i - 1)], 'BOTTOM', 0, -6)
        end
    end
 -- anchor button 1 so 12 buttons are centered above default bars
MultiBarLeftButton1:ClearAllPoints()
MultiBarLeftButton1:SetFrameStrata("BACKGROUND")
-- MultiBarLeftButton1:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",-250,100)
MultiBarLeftButton1:SetPoint("BOTTOMLEFT",PlayerFrame,"BOTTOM", -5,0)

--Mouseover code
function mouseoverleft()
   MultiBarLeft:EnableMouse(true)
	 MultiBarLeft:SetAlpha(0)
	 MultiBarLeft:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
	 MultiBarLeft:SetScript("OnLeave", function(self) self:SetAlpha(0) end)
	 local function hidebar2() MultiBarLeft:SetAlpha(0) end
	 local function showbar2() MultiBarLeft:SetAlpha(1) end
	 for btn=1,12 do
		 _G["MultiBarLeftButton"..btn]:SetScript("OnEnter",showbar2)
		 _G["MultiBarLeftButton"..btn]:SetScript("OnLeave",hidebar2)
	 end
	end

function barsize(MultiBarLeftButton)
for i = 1, 12 do
	local bar =_G['MultiBarLeftButton' .. i]
	bar:SetScale(0.7)
	
	
end
	end
	barsize()
	mouseoverleft()
	
	 local timer = CreateFrame("Frame")
  timer:Hide()
  timer:SetScript("OnUpdate", function()
	timer.time = GetTime() + 2
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
