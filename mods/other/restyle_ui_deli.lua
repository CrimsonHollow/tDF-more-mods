local module = ShaguTweaks:register({
    title = "Restyle-Delirium",
    description = "Restyles the ui based on my (Delirium/Ark) preferences",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = true,
})

module.enable = function(self)
    local _G = ShaguTweaks.GetGlobalEnv()
    local restyle = CreateFrame("Frame", nil, UIParent)
    local addonpath = "Interface\\AddOns\\tDF-more-mods"
	local customfont = addonpath .. "\\fonts\\PROTOTYPE.TTF"

local sections  = {
        'TOPLEFT', 'TOPRIGHT', 'BOTTOMLEFT', 'BOTTOMRIGHT', 'TOP', 'BOTTOM', 'LEFT', 'RIGHT'
    }

    local function skin(f, offset, x, y)
        local t = {}
        offset = offset or 0
        x = x or 0
        y = y or 0
            
        for i = 1, 8 do
            local section = sections[i]
            local x = f:CreateTexture(nil, 'OVERLAY', nil, 1)
            x:SetTexture(addonpath..'\\img\\borders\\'..'border-'..section..'.tga')
            t[sections[i]] = x
        end

        t.TOPLEFT:SetWidth(8)
        t.TOPLEFT:SetHeight(8)
        t.TOPLEFT:SetPoint('BOTTOMRIGHT', f, 'TOPLEFT', 4 + offset + x, -4 - offset + y)

        t.TOPRIGHT:SetWidth(8)
        t.TOPRIGHT:SetHeight(8)
        t.TOPRIGHT:SetPoint('BOTTOMLEFT', f, 'TOPRIGHT', -4 - offset + x, -4 - offset + y)

        t.BOTTOMLEFT:SetWidth(8)
        t.BOTTOMLEFT:SetHeight(8)
        t.BOTTOMLEFT:SetPoint('TOPRIGHT', f, 'BOTTOMLEFT', 4 + offset + x, 4 + offset + y)

        t.BOTTOMRIGHT:SetWidth(8)
        t.BOTTOMRIGHT:SetHeight(8)
        t.BOTTOMRIGHT:SetPoint('TOPLEFT', f, 'BOTTOMRIGHT', -4 - offset + x, 4 + offset + y)

        t.TOP:SetHeight(8)
        t.TOP:SetPoint('TOPLEFT', t.TOPLEFT, 'TOPRIGHT')
        t.TOP:SetPoint('TOPRIGHT', t.TOPRIGHT, 'TOPLEFT')

        t.BOTTOM:SetHeight(8)
        t.BOTTOM:SetPoint('BOTTOMLEFT', t.BOTTOMLEFT, 'BOTTOMRIGHT')
        t.BOTTOM:SetPoint('BOTTOMRIGHT', t.BOTTOMRIGHT, 'BOTTOMLEFT')

        t.LEFT:SetWidth(8)
        t.LEFT:SetPoint('TOPLEFT', t.TOPLEFT, 'BOTTOMLEFT')
        t.LEFT:SetPoint('BOTTOMLEFT', t.BOTTOMLEFT, 'TOPLEFT')

        t.RIGHT:SetWidth(8)
        t.RIGHT:SetPoint('TOPRIGHT', t.TOPRIGHT, 'BOTTOMRIGHT')
        t.RIGHT:SetPoint('BOTTOMRIGHT', t.BOTTOMRIGHT, 'TOPRIGHT')

        f.borderTextures = t
        f.SetBorderColor = SetBorderColor
        f.GetBorderColor = GetBorderColor
    end

    local function skinColor(f, r, g, b, a)
        if ShaguTweaks.DarkMode then
            r,g,b = .3, .3, .3
        end

        local t = f.borderTextures
        if not  t then return end
        for  _, v in pairs(t) do
            v:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
        end
    end
	

    function restyle:addons()
        --[[
            Supported Addons:
            SP_SwingTimer (Vanilla/Turtle),
            MinimapButtonBag (Vanilla/Turtle)
        ]]

        -- local function lock(frame)
            -- frame.ClearAllPoints = function() end
            -- frame.SetAllPoints = function() end
            -- frame.SetPoint = function() end         
        -- end

	


     

        -- MinimapButtonFrame    
        if MBB_MinimapButtonFrame then
            -- reposition MBB to the bottom of the styleFrame (under the minimap)
            -- show the button OnEnter and hide when OnLeave
            
            if IsAddOnLoaded("MinimapButtonBag-TurtleWoW") then
                MBB_MinimapButtonFrame_Texture:SetTexture("Interface\\Icons\\Inv_misc_bag_10_green")
            else
                MBB_MinimapButtonFrame_Texture:SetTexture("Interface\\Icons\\Inv_misc_bag_10")
            end            

            MBB_MinimapButtonFrame:ClearAllPoints()
            MBB_MinimapButtonFrame:SetPoint("CENTER", Minimap, "TOPRIGHT", 30, 30)
               
            
            local function showButton(button)
                button:SetAlpha(1)
            end

            local function hideButton(button)
                button:SetAlpha(0)  
            end            

            hideButton(MBB_MinimapButtonFrame)
            local hide = CreateFrame("BUTTON", nil, MBB_MinimapButtonFrame)
            hide:SetAllPoints(hide:GetParent())

            hide:SetScript("OnEnter", function()
                showButton(MBB_MinimapButtonFrame)
            end)

            hide:SetScript("OnLeave", function()
                hide.timer = GetTime() + 6
                hide:SetScript("OnUpdate", function()            
                    if (GetTime() > hide.timer) then
                        MBB_HideButtons() -- MBB function to hide buttons
                        hideButton(MBB_MinimapButtonFrame)
                        hide:SetScript("OnUpdate", nil)
                    end
                end)
            end)
            
            hide:RegisterForClicks("LeftButtonDown","RightButtonDown")
            hide:SetScript("OnClick", function()
                MBB_OnClick(arg1)
            end)
        end
    end

    function restyle:buffs()
        local font, size, outline = customfont, 9, "OUTLINE"
        local yoffset = 7
        local f = CreateFrame("Frame", nil, GryllsMinimap)
        f:SetFrameStrata("HIGH")

        local function buffText(buffButton)
            -- remove spaces from buff durations
            local duration = getglobal(buffButton:GetName().."Duration");
            local durationtext = duration:GetText()
            if durationtext ~= nil then
                local timer = string.gsub(durationtext, "%s+", "")
                duration:SetText(timer)
            end
        end

        for i = 0, 2 do
            for _, v in pairs(
                    {
                    _G['TempEnchant'..i..'Duration'],
                }
            ) do
                local b = _G['TempEnchant'..i]
                v:SetFont(font, size, outline)
                v:ClearAllPoints()
                v:SetPoint("CENTER", b, "BOTTOM", 0, yoffset)
                v:SetParent(f)            

                local f = CreateFrame("Frame", nil, b)
                f:SetScript("OnUpdate", function()
                    buffText(b)
                end)
            end
        end

        for i = 0, 16 do
            for _, v in pairs(
                    {
                    _G['BuffButton'..i..'Duration'],
                }
            ) do
                local b = _G['BuffButton'..i]
                v:SetFont(font, size, outline)
                v:ClearAllPoints()
                v:SetPoint("CENTER", b, "BOTTOM", 0, yoffset)
                v:SetParent(f)            

                local f = CreateFrame("Frame", nil, b)
                f:SetScript("OnUpdate", function()
                    buffText(b)
                end)
            end
        end
		
		for i = 0, 16 do
             for _, v in pairs(
                     {
                     _G['BuffButton'..i],
                     _G['BuffButton'..i..'Border'],
                }
            ) do
                local s = 35
                v:SetWidth(s)
                v:SetHeight(s)
            end
         end
		
		for i = 16, 23 do
            for _, v in pairs(
                    {
                    _G['BuffButton'..i..'Duration'],
                }
            ) do
                local b = _G['BuffButton'..i]
                v:SetFont(font, size, outline)
                v:ClearAllPoints()
                v:SetPoint("CENTER", b, "BOTTOM", 0, yoffset)
                v:SetParent(f)            
	
                local f = CreateFrame("Frame", nil, b)
                f:SetScript("OnUpdate", function()
                    buffText(b)
                end)
            end
        end
		
		    for i = 16, 23 do
            for _, v in pairs(
                    {
                    _G['BuffButton'..i],
                    _G['BuffButton'..i..'Border'],
                }
            ) do
                local s = 45
                v:SetWidth(s)
                v:SetHeight(s)
            end
        end
		
		
    end

    function restyle:buttons()
        local function style(button)
            if not button then return end        

            local hotkey = _G[button:GetName().."HotKey"]
            if hotkey then
                local font, size, outline = customfont, 12, "OUTLINE"
                hotkey:SetFont(font, size, outline)
            end

            local macro = _G[button:GetName().."Name"]  
            if macro then
                local font, size, outline = customfont, 12, "OUTLINE"
                macro:SetFont(font, size, outline)   
            end

            local count = _G[button:GetName()..'Count']
            if count then
                local font, size, outline = customfont, 14, "OUTLINE"
                count:SetFont(font, size, outline)   
            end
        end
        
        for i = 1, 24 do
            local button = _G['BonusActionButton'..i]
            if button then
                style(button)
            end
        end

        for i = 1, 12 do
            for _, button in pairs(
                    {
                    _G['ActionButton'..i],
                    _G['MultiBarRightButton'..i],
                    _G['MultiBarLeftButton'..i],
                    _G['MultiBarBottomLeftButton'..i],
                    _G['MultiBarBottomRightButton'..i],
                }
            ) do
                style(button)
            end        
        end 

        for i = 1, 10 do
            for _, button in pairs(
                {
                    _G['ShapeshiftButton'..i],
                    _G['PetActionButton'..i]
                }
            ) do
                style(button)
            end
        end
    end

    function restyle:reducedactionbar()
        -- if not reduced action bar end
        if MainMenuExpBar:GetWidth() > 512 then return end

        local move = { 
            MainMenuBar, MultiBarBottomLeft, MultiBarBottomRight, 
            MainMenuExpBar, ReputationWatchBar,
            MainMenuBarLeftEndCap, MainMenuBarRightEndCap
        }

        for id, frame in pairs(move) do 
            frame:ClearAllPoints()
        end

        local hide = { 
            MainMenuBarTexture0, MainMenuBarTexture1,
            MainMenuXPBarTexture0, MainMenuXPBarTexture1,
            ReputationXPBarTexture0, ReputationXPBarTexture1, ReputationXPBarTexture2, ReputationXPBarTexture3,
            ReputationWatchBarTexture0, ReputationWatchBarTexture1,
        }

        for id, frame in pairs(hide) do 
            frame:Hide()
            frame.Show = function() end         
        end

        -- action bar (bottom)
        MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 45)        

        -- MultiBarBottomLeft (middle)
        MultiBarBottomLeft:SetPoint("BOTTOM", MainMenuBar, "TOP", 2, -1)

        -- MultiBarBottomRight (top)
        MultiBarBottomRight:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 5)

        -- experience bar
        MainMenuExpBar:SetPoint("TOPLEFT", ActionButton1, "BOTTOMLEFT", -5, -12)
        MainMenuExpBar:SetPoint("TOPRIGHT", ActionButton12, "BOTTOMRIGHT", 5, -12)
        
        -- reputation bar
        ReputationWatchBar:SetPoint("TOP", MainMenuExpBar, "BOTTOM", 0, -6)  

        -- gryphon textures
        local x, y = 22, 8
        if ShaguTweaks.dfgryphons then
            x, y = 33, 30
        elseif ShaguTweaks.dfwyverns then
            x, y = 33, 22      
        end
        local c = .7
        MainMenuBarLeftEndCap:SetVertexColor(c,c,c)
        MainMenuBarRightEndCap:SetVertexColor(c,c,c)
        MainMenuBarLeftEndCap:SetPoint("BOTTOMRIGHT", ActionButton1, "BOTTOMLEFT", x, -y)
        MainMenuBarRightEndCap:SetPoint("BOTTOMLEFT", ActionButton12, "BOTTOMRIGHT", -x, -y)

        -- action bar bg
        local mmbg = CreateFrame("Frame", nil, MainMenuBar)
        mmbg:SetFrameStrata("LOW")
        local i = 10
        mmbg:SetPoint("TOPLEFT", ActionButton1, "TOPLEFT", -i, i)
        mmbg:SetPoint("BOTTOMRIGHT", ActionButton12, "BOTTOMRIGHT", i, -i-1)
        -- mmbg:Hide()

        -- action bar empty buttons
        for i = 1, 12 do            
            for _, button in pairs(
                    {
                    _G['ActionButton'..i],
                }
            ) do
                local t = MainMenuBar:CreateTexture(nil, "OVERLAY", nil, 1)
                local i = 12
                t:SetPoint("TOPLEFT", button, "TOPLEFT", -i, i-1)
                t:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", i, -i-1)
                t:SetTexture("Interface\\Buttons\\UI-EmptySlot-White")
                t:SetVertexColor(.5,.5,.5,1)
            end        
        end        

        -- skin
        local function bg(frame, i, c, a)
            frame:SetBackdrop({
                bgFile = "Interface\\TabardFrame\\TabardFrameBackground",
                -- edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
                -- tile = true, tileSize = 12, edgeSize = 22, 
                insets = { left = i, right = i, top = i, bottom = i }
            })
            frame:SetBackdropColor(c,c,c,a)
        end
        
        bg(mmbg, 4, 1, .7)
        skin(mmbg, 5)
        skinColor(mmbg, .7, .7, .7)
        
        skin(MainMenuExpBar, 0)
        skinColor(MainMenuExpBar, .7, .7, .7)

        skin(ReputationWatchBar, 1, 0, 1)
        skinColor(ReputationWatchBar, .7, .7, .7)  

     
    end
 


    function restyle:minimap()
        -- Change Texture
        if MinimapBorder:GetTexture() then
            -- not minimap-square
            MinimapBorder:SetTexture(addonpath .. "\\img\\UI-MINIMAP-BORDER")
        end

        -- Move minimap elements
        local styleFrame = CreateFrame("Frame", nil, MinimapCluster)        
        styleFrame:SetFrameStrata("HIGH")    
        styleFrame:SetPoint("CENTER", Minimap, "BOTTOM")
        styleFrame:SetHeight(16)
        styleFrame:SetWidth(Minimap:GetWidth())

        -- -- Zone Text
        -- MinimapZoneTextButton:ClearAllPoints()
        -- MinimapZoneTextButton:SetPoint("TOP", Minimap, 0, 13)
        -- MinimapZoneText:SetFont(customfont, 14, "OUTLINE")
        -- MinimapZoneText:SetDrawLayer("OVERLAY", 7)   
        -- MinimapZoneText:SetParent(styleFrame)
        -- MinimapZoneText:Hide()

        -- Minimap:SetScript("OnEnter", function()
        --     MinimapZoneText:Show()
        -- end)

        -- Minimap:SetScript("OnLeave", function()
        --     MinimapZoneText:Hide()
        -- end)

        -- ShaguTweaks clock
        if MinimapClock then
            MinimapClock:ClearAllPoints()
			MinimapClock.text:SetFont(customfont, 14, "OUTLINE")
            MinimapClock:SetPoint("CENTER", styleFrame, "CENTER", 0, -20)
        end

        -- ShaguTweaks-Mods fps
        if MinimapFPS then
            MinimapFPS:ClearAllPoints()
            MinimapFPS:SetPoint("LEFT", styleFrame, "LEFT")
        end

        -- ShaguTweaks-Mods ms
        if MinimapMS then
            MinimapMS:ClearAllPoints()
            MinimapMS:SetPoint("RIGHT", styleFrame, "RIGHT")
        end

        if Minimap.border then -- if using square minimap
            -- Tracking
            MiniMapTrackingFrame:ClearAllPoints()
            MiniMapTrackingFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -2, 1)
            MiniMapTrackingFrame:SetScale(0.9)
            MiniMapTrackingBorder:SetTexture(nil)
			Minimap:SetMaskTexture[[Interface\Addons\tDF-more-mods\img\MinimapMask]]
			Minimap:SetWidth(192.6)
			Minimap:SetHeight(172.6)
			

            -- -- Mail
            -- MiniMapMailFrame:ClearAllPoints()
            -- MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 4, 2)
            -- MiniMapMailFrame:SetScale(1.2)
            -- MiniMapMailBorder:SetTexture(nil)

            -- -- PVP
            -- MiniMapBattlefieldFrame:ClearAllPoints()
            -- MiniMapBattlefieldFrame:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 2, 8)
        end        
    end

    function restyle:unitnames()
        local names = {
            PlayerFrame.name,
			PlayerLevelText,
			TargetLevelText,
			PlayerFrameHealthBar.TextString,
			PlayerFrameManaBar.TextString,
			TargetFrameHealthBar.TextString,
			TargetFrameManaBar.TextString,
			PetName,
			PetFrameHealthBar.TextString,
			PetFrameManaBar.TextString,
            TargetFrame.name,
            TargetofTargetName,
			TargetofTargetHealthBar.TextString,
			TargetDeadText,
			TargetofTargetManaBar.TextString,
            --PartyMemberFrame1.name,
            --PartyMemberFrame2.name,
            --PartyMemberFrame3.name,
            --PartyMemberFrame4.name,
            --PartyMemberFrame1PetFrame.name,
            --PartyMemberFrame2PetFrame.name,
            --PartyMemberFrame3PetFrame.name,
            --PartyMemberFrame4PetFrame.name
        }
		
		
		PetName:Hide()
		PlayerFrame.name:Hide()
		PlayerFrameHealthBar.TextString:SetPoint("TOP", PlayerFrameHealthBar, "BOTTOM", 0, 30)
		TargetFrameHealthBar.TextString:SetPoint("TOP", TargetFrameHealthBar, "BOTTOM", -2, 30)
		PlayerFrameHealthBar.TextString:SetPoint("TOP", PlayerFrame, "TOP", 50, -15)
		PlayerFrame.name:SetPoint("TOP", PlayerFrame, "TOP", 50, -15)
		TargetFrame.name:SetPoint("TOP", TargetFrame, "TOP", -50, -15)
		
        local font, size, outline = customfont, 12, "OUTLINE"
        for _, name in pairs(names) do
            name:SetFont(font, size, outline)
        end
		if  DeliPower or DeliPower2 then
		PlayerFrameManaBar.TextString:SetFont(font, size +4, outline)
		end
		combat = customfont
		DAMAGE_TEXT_FONT = combat
		CombatTextFont:SetFont(combat, 25)
		PlayerFrameHealthBar.TextString:SetFont(font, size +2, outline)
		TargetFrameHealthBar.TextString:SetFont(font, size +2, outline)
    end

    function restyle:chatframes()
        local frames = {
            ChatFrame1,
            ChatFrame2,
            ChatFrame3
        }

        local font = customfont
        for _, frame in pairs(frames) do            
            local _, size, outline = frame:GetFont()
            frame:SetFont(font, size, outline)
        end
    end

    function restyle:nameplates()
        if ShaguPlates then return end

        local font, size, outline = customfont, 16, "OUTLINE"
        table.insert(ShaguTweaks.libnameplate.OnUpdate, function()            
            this.name:SetFont(font, size, outline)
            this.level:SetFont(font, size, outline)
        end)
    end
	
	
    
    restyle:RegisterEvent("PLAYER_ENTERING_WORLD")
    restyle:SetScript("OnEvent", function()
        if not this.loaded then
            this.loaded = true
			
            restyle:addons()           
            restyle:buffs()
            restyle:buttons()
            restyle:minimap()
            restyle:unitnames()
            restyle:chatframes()
            restyle:nameplates()
			        end           
    end)
end
