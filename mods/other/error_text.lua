local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Hide Error Text",
    description = "Turns off the annoying Out of Range/Not enough rage text.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = nil,
})

module.enable = function(self)
 UIErrorsFrame:Hide()
end