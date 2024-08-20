local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "StylePoints",
    description = "Sets the addon to my preferences.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = nil,
})

module.enable = function(self)
if SPFrame1 then 
	SPFrame1:ClearAllPoints
	SPFrame1:SetPoint("CENTER", -100, -180)
end
end