-- This module can be used to add your own custom code.
-- Make sure to read the comments carefully.

-- Remove the following line to activate the module:
--if true then return end

-- This table holds the meta-data of the module:
local module = ShaguTweaks:register({
  title = "Minimap Override",
  description = "Move the minimap on the bottom left. Yes im one of those people..",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = "Deli UI",
  enabled = nil,
})

-- Global code:
--   This is where you can put your most basic variable assignments.
--   Code in this scope will *always* run, no matter if the module is enabled or not.
local _G = ShaguTweaks.GetGlobalEnv()
local tTempEnchant1 = TempEnchant1

module.enable = function(self)

   local function setup()
    if MyCustomMinimap then
	MyCustomMinimap:ClearAllPoints()
	MyCustomMinimap:SetPoint("BOTTOMLEFT", 40, 40)
	MinimapZoneText:ClearAllPoints()
    MinimapZoneText:SetPoint("LEFT", MyCustomMinimap, 35, 110)
	tMinimapZoomIn:ClearAllPoints()
	tMinimapZoomOut:ClearAllPoints()
	tMinimapZoomIn:SetPoint("TOPRIGHT", MinimapZoneText, "TOPLEFT", 160, -170)
	tMinimapZoomOut:SetPoint("TOPRIGHT", MinimapZoneText, "TOPLEFT", 145, -190)
	
	 if MBB_MinimapButtonFrame then
	MBB_MinimapButtonFrame:ClearAllPoints()
    MBB_MinimapButtonFrame:SetPoint("TOPRIGHT", MyCustomMinimap, 20, -140)
	MBB_MinimapButtonFrame:SetAlpha(1)
	end
	end 
	
	if tTempEnchant1 then
        tTempEnchant1:SetParent(UIParent)
        tTempEnchant1:ClearAllPoints()
        tTempEnchant1:SetPoint("BOTTOMRIGHT", PlayerFrame, -5, -7)
		
    end
	
end
  
 




  -- create a timer
  local timer = CreateFrame("Frame")
  timer:Hide()
  timer:SetScript("OnUpdate", function()
    if GetTime() >= timer.time then
      timer.time = nil
      setup()
	  
      this:Hide()
      this:SetScript("OnUpdate", nil)
    end
  end)
  


  local events = CreateFrame("Frame", nil, UIParent)
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:SetScript("OnEvent", function()
      -- trigger the timer to go off 1 second after login
      timer.time = GetTime() + 2
      timer:Show()

    end)
	end
 
