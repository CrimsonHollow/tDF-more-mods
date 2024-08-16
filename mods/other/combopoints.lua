local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Combo Points",
    description = "Combopoints..",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = nil,
})

module.enable = function(self)

ComboFrame:ClearAllPoints()
ComboFrame:SetPoint("CENTER",UIParent,"CENTER",-83,-100)
ComboFrame:SetScale(1.5)

end
