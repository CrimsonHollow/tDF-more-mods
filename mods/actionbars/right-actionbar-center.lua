local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Right Actionbar Center",
    description = "Moves the right Actionbar to the center of the screen.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = nil,
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
MultiBarRightButton1:SetPoint("CENTER",UIParent,"CENTER",-83,-185)

function barsize(MultiBarRightButton)
for i = 1, 12 do
	local bar =_G['MultiBarRightButton' .. i]
	bar:SetScale(1.1)
	
	
end
	end
	barsize()
	end
