local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Powerbar",
    description = "Moves your mana/energy/rage bar in the middle!.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = nil,
})

module.enable = function(self)
local h = 20
	PlayerFrameManaBar:ClearAllPoints()
	PlayerFrameManaBar:SetPoint("CENTER",UIParent,0,-193)
	PlayerFrameManaBar:SetStatusBarTexture[[Interface\Addons\tDF-more-mods\img\UI-StatusBar]]
	PlayerFrameManaBar:SetHeight(h)
	PlayerFrameManaBar:SetWidth(223)
	PlayerFrameManaBar.TextString:SetPoint("CENTER",PlayerFrameManaBar,0,0)
	PlayerFrameHealthBar:SetHeight(40)
	PlayerFrameTexture:SetTexture[[Interface\Addons\tDF-more-mods\img\UI-TargetingFrame3]] 
	PlayerStatusTexture:SetTexture[[Interface\Addons\tDF-more-mods\img\UI-Player-Status3]]  
	
local DeliPower = CreateFrame("Frame", "DeliPower", UIParent)
	-- DeliPower:SetWidth(1)
	-- DeliPower:SetHeight(1)
	
	-- DeliPower.bg = DeliPower:CreateTexture(nil, "BACKGROUND")
	-- DeliPower.bg:SetTexture("Interface\Addons\tDF-more-mods\img\UI-StatusBar")
	-- DeliPower.bg:SetVertexColor(.1, .1, 0, .8)
	-- DeliPower.bg:SetWidth(225)
	-- DeliPower.bg:SetHeight(20)
	-- DeliPower.bg:SetPoint("CENTER",UIParent,0,-193)
	
	local function border(frame)
                local x, y, e, i = 4, 4, h -2, 4
                f = CreateFrame("Frame", nil, frame)
                f:SetPoint("TOPLEFT", f:GetParent(), "TOPLEFT", -x, y)
                f:SetPoint("BOTTOMRIGHT", f:GetParent(), "BOTTOMRIGHT", x, -y)
                
                f:SetBackdrop({
                    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                    -- edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
                    edgeSize = e,
                    insets = { left = i, right = i, top = i, bottom = i },
                })

                local r, g, b, a = .7, .7, .7, .9
                f:SetBackdropBorderColor(r, g, b, a)
				if ShaguTweaks.DarkMode then
				f:SetBackdropBorderColor( .3, .3, .3, .9)
				end
            end           
	local function AddSpecialBackground(frame, w, h, x, y)
  frame.Material = frame.Material or frame:CreateTexture(nil, "BACKGROUND")
  frame.Material:SetTexture("Interface\\Addons\\tDF-more-mods\\img\\UI-StatusBar")
  frame.Material:SetWidth(w)
  frame.Material:SetHeight(h)
  frame.Material:SetPoint("TOPLEFT", frame, x, y)
  frame.Material:SetVertexColor(0, 0, 0, .5)
	end
		border(PlayerFrameManaBar)
		AddSpecialBackground(PlayerFrameManaBar, 223, 20, -1, -1)
end