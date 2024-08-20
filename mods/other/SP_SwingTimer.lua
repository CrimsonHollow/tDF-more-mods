local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "SP_SwingTimer",
    description = "Set up the addon to my preferences!.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = nil,
})

module.enable = function(self)
   --[[
            Supported Addons:
            SP_SwingTimer (Vanilla/Turtle),
           
        ]]

        local function lock(frame)
            frame.ClearAllPoints = function() end
            frame.SetAllPoints = function() end
            frame.SetPoint = function() end         
        end

	


        -- SP_SwingTimer
        if IsAddOnLoaded("SP_SwingTimer") and (not IsAddOnLoaded("GryllsSwingTimer")) then
            local w, h, b = 220, 14, 6
            -- local h, b = 14, 6
            -- set mainhand
            SP_ST_Frame:SetWidth(w)
            SP_ST_Frame:SetHeight(h)
            -- SP_ST_Frame:SetScale(1)
            -- SP_ST_Frame:SetAlpha(1)
            -- -- set oh
            SP_ST_FrameOFF:SetWidth(w)
            SP_ST_FrameOFF:SetHeight(h)
            -- SP_ST_FrameOFF:SetScale(1)
            -- SP_ST_FrameOFF:SetAlpha(1)
            -- set position
            SP_ST_Frame:ClearAllPoints()
			-- SP_ST_Frame:SetTexture("Interface\\Addons\\tDF-more-mods\\img\\Castbar\\CastingBarStandard2")
            SP_ST_FrameOFF:ClearAllPoints()

            SP_ST_Frame:SetPoint("CENTER", 0, -170)
            SP_ST_FrameOFF:SetPoint("TOP", "SP_ST_Frame", "BOTTOM", 0, 30);
			
			if SPFrame1 then 
				SP_ST_Frame:ClearAllPoints()
				SP_ST_FrameOFF:ClearAllPoints()
				SP_ST_Frame:SetPoint("CENTER", 0, -150)
				SP_ST_FrameOFF:SetPoint("TOP", "SP_ST_Frame", "BOTTOM", 0, 30)
			end
				
				
            SP_ST_FrameTime:ClearAllPoints()
	        SP_ST_FrameTime2:ClearAllPoints()            
            
            SP_ST_FrameTime:SetPoint("CENTER", "SP_ST_Frame", "CENTER")
		    SP_ST_FrameTime2:SetPoint("CENTER", "SP_ST_FrameOFF", "CENTER")
            -- set time
            -- SP_ST_FrameTime:SetWidth(w)
            SP_ST_FrameTime:SetHeight(h-b)

            -- SP_ST_FrameTime2:SetWidth(w)
            SP_ST_FrameTime2:SetHeight(h-b)
            -- hide icons
            SP_ST_mainhand:SetTexture(nil)
            SP_ST_mainhand:SetWidth(0)

            SP_ST_offhand:SetTexture(nil)
            SP_ST_offhand:SetWidth(0)

            SP_ST_mainhand:Hide()
            SP_ST_offhand:Hide()
            -- hide timers
            SP_ST_maintimer:Hide()
            SP_ST_offtimer:Hide()
            -- hide oh
            SP_ST_FrameOFF:Hide()
            SP_ST_FrameTime2:Hide()

            -- add borders
            local function border(frame)
                local x, y, e, i = 4, 2, h, 4
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
			
            
            border(SP_ST_Frame)
            border(SP_ST_FrameOFF)      
			

        end
end