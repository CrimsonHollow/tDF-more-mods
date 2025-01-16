local module = ShaguTweaks:register({
    title = "Mouseover Left ActionBar",
    description = "Hide the Left ActionBar and show on mouseover. The pet/shapeshift/aura/stance bars will not be clickable if in the same position as the mouseover bar.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = true,
})

module.enable = function(self)
    ShaguTweaks.MouseoverBottomLeft = true
    local _G = ShaguTweaks.GetGlobalEnv()

    local timer = CreateFrame("Frame", nil, UIParent)
    local mouseOverBar
    local mouseOverButton
    local _, class = UnitClass("player")

local  function mouseoverleft()
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
mouseoverleft()
end
