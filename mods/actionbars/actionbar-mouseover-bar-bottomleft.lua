local module = ShaguTweaks:register({
    title = "Mouseover Bottom Left",
    description = "Hide the Bottom Left ActionBar and show on mouseover. The pet/shapeshift/aura/stance bars will not be clickable if in the same position as the mouseover bar.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = nil,
})

module.enable = function(self)
    ShaguTweaks.MouseoverBottomLeft = true
    local _G = ShaguTweaks.GetGlobalEnv()

    local timer = CreateFrame("Frame", nil, UIParent)
    local mouseOverBar
    local mouseOverButton
    local _, class = UnitClass("player")

    local function hidebars()
        if (class == "HUNTER") or (class == "WARLOCK") then
            PetActionBarFrame:Hide()
        elseif (class == "DRUID") or (class == "ROGUE") or (class == "WARRIOR") or (class == "PALADIN") then
            ShapeshiftBarFrame:Hide()
        end
    end

    local function showbars()
        if (class == "HUNTER") or (class == "WARLOCK") then
            PetActionBarFrame:Show()
        elseif (class == "DRUID") or (class == "ROGUE") or (class == "WARRIOR") or (class == "PALADIN") then
            ShapeshiftBarFrame:Show()
        end
    end
        
    local function hide(bar)
        bar:Hide()
        showbars()
    end
    
    local function show(bar)
        bar:Show()    
        hidebars()
    end
    
    local function mouseover(bar)
        local function setTimer()
            timer.time = GetTime() + 2
            timer:SetScript("OnUpdate", function()
                if GetTime() >= timer.time then
                    hide(bar)
                    timer:SetScript("OnUpdate", nil)
                end
            end)
        end
    
        if (mouseOverButton or mouseOverBar) then
            timer:SetScript("OnUpdate", nil)
            show(bar)
        elseif (not mouseOverBar) and (not mouseOverButton) then
            setTimer()
        end
    end
    
    local function barEnter(frame, bar)
        frame:SetScript("OnEnter", function()
            mouseOverBar = true
            mouseover(bar)
        end)
    end
    
    local function barLeave(frame, bar)
        frame:SetScript("OnLeave", function()
            mouseOverBar = nil     
            mouseover(bar)
        end)
    end
    
    local function buttonEnter(frame, bar)
        frame:SetScript("OnEnter", function()
            mouseOverButton = true
            frame:EnableMouse(nil)
            mouseover(bar)        
        end)
    end
    
    local function buttonLeave(frame, bar)
        frame:SetScript("OnLeave", function()
            mouseOverButton = nil
            frame:EnableMouse(true)
            mouseover(bar)
        end)
    end
    
    local function mouseoverButton(button, bar)
        local frame = CreateFrame("Frame", nil, UIParent)    
        frame:SetAllPoints(button)
        frame:EnableMouse(true)
        frame:SetFrameStrata("DIALOG")    
        buttonEnter(frame, bar)
        buttonLeave(frame, bar)
    end
    
    local function mouseoverBar(bar)
        local frame = CreateFrame("Frame", nil, UIParent)
        frame:SetAllPoints(bar)
        frame:EnableMouse(true)
        barEnter(frame, bar) 
        barLeave(frame, bar)
    end
    
    local function setup(bar)
        if not bar:IsVisible() then return end        
        for i = 1, 12 do
            for _, button in pairs(
                    {
                    _G[bar:GetName()..'Button'..i],
                }
            ) do
                mouseoverButton(button, bar)
            end
        end
        mouseoverBar(bar)
        hide(bar)
    end    

    local function hideart()
        -- general function to hide textures and frames
        local function hide(frame, texture)
            if not frame then return end

            if texture and texture == 1 and frame.SetTexture then
            frame:SetTexture("")
            elseif texture and texture == 2 and frame.SetNormalTexture then
            frame:SetNormalTexture("")
            else
            frame:ClearAllPoints()
            frame.Show = function() return end
            frame:Hide()
            end
        end

        -- textures that shall be set empty
        local textures = {
            SlidingActionBarTexture0, SlidingActionBarTexture1,
            -- PetActionBarFrame
            SlidingActionBarTexture0, SlidingActionBarTexture1,
            -- ShapeshiftBarFrame
            ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
          }

        -- button textures that shall be set empty
        local normtextures = {
            ShapeshiftButton1, ShapeshiftButton2,
            ShapeshiftButton3, ShapeshiftButton4,
            ShapeshiftButton5, ShapeshiftButton6,
        }

        -- clear textures
        for id, frame in pairs(textures) do hide(frame, 1) end
        for id, frame in pairs(normtextures) do hide(frame, 2) end
    end

    local function lockframes()        
        local function lock(frame)
            frame.ClearAllPoints = function() end
            frame.SetAllPoints = function() end
            frame.SetPoint = function() end
        end

        PetActionBarFrame:ClearAllPoints()
        ShapeshiftBarFrame:ClearAllPoints()

        local h = ActionButton1:GetHeight()
        local anchor = MultiBarBottomLeft

        PetActionBarFrame:SetPoint("CENTER", anchor, "CENTER", h, 2)

        -- ShapeshiftBarFrame
        local offset = 0
        local anchor = ActionButton1
        offset = anchor == ActionButton1 and ( MainMenuExpBar:IsVisible() or ReputationWatchBar:IsVisible() ) and 6 or 0
        offset = anchor == ActionButton1 and offset + 6 or offset
        ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 8, 1 + offset)

        lock(PetActionBarFrame)
        lock(ShapeshiftBarFrame)
    end

    local function castbar()
        local function lock(frame)
            frame.ClearAllPoints = function() end
            frame.SetAllPoints = function() end
            frame.SetPoint = function() end
        end

        if MainMenuBar:GetWidth() <= 512 then
            ReducedActionbar = true
        end

        local h = ActionButton1:GetHeight()        

        CastingBarFrame:ClearAllPoints()
        if not ShaguTweaks.MouseoverBottomRight then
            if ReducedActionbar then
                CastingBarFrame:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, h*2.5)
            else
                CastingBarFrame:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, h*1.5)
            end
            lock(CastingBarFrame)
        elseif ShaguTweaks.MouseoverBottomRight then
            CastingBarFrame:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, h*1.5)
            lock(CastingBarFrame)
        end

        -- SP_SwingTimer / zUI SwingTimer / GryllsSwingTimer support
        -- if SP_ST_Frame then
            -- SP_ST_Frame:ClearAllPoints()
            -- SP_ST_Frame:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 14)
            -- lock(SP_ST_Frame)      
        -- end
    end

    local ReducedActionbar
    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        if not this.loaded then
            this.loaded = true
            lockframes()
            castbar()
            hideart()
            setup(MultiBarBottomLeft)
        end
    end)
end
