local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Vignette",
    description = "Puts a stylish Vignette in your screen!.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = nil,
})

module.enable = function(self)
function vignette()                                                                                                                                                   
  --[[ module code ]]--
  local vignette = CreateFrame("Frame", nil, WorldFrame)
  vignette:SetAllPoints()
  vignette.tex = vignette:CreateTexture()
  vignette.tex:SetTexture([[Interface\Addons\tDF-more-mods\img\vignetting]])
  vignette.tex:SetPoint("TOPLEFT", WorldFrame, "TOPLEFT", -50, 15)
  vignette.tex:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", 50, -15)
end

vignette()
end