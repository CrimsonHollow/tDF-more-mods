local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
  title = "Deli Unitframes",
  description = "Bigger , retail-like Unitframes.",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = "Deli UI",
  enabled = nil,
})


local addonpath
local tocs = { "", "-master", "-tbc", "-wotlk" }
for _, name in pairs(tocs) do
  local current = string.format("ShaguTweaks%s", name)
  local _, title = GetAddOnInfo(current)
  if title then
    addonpath = "Interface\\AddOns\\" .. current
    break
  end
end

module.enable = function(self)

------------------------RESTED------------------------


-----Reskins the zzz-----
-- Create a new frame
--local overlay = CreateFrame("Frame", nil, PlayerRestIcon:GetParent())
local overlay = CreateFrame("Frame", "overlay", UIParent)
overlay:SetWidth(24)
overlay:SetHeight(24)
overlay:SetPoint("CENTER", PlayerFrame, "CENTER", -20, 30) -- Position the NEW RESTED icon

--remove the original blizzard zzz
PlayerRestIcon:SetTexture("")
PlayerRestIcon:ClearAllPoints()
PlayerRestIcon:SetPoint("TOPLEFT", PlayerFrame, -3000, 0)

-- Set the frame strata to be higher than PlayerRestIcon
--overlay:SetFrameStrata("DIALOG")

-- Set the size and position of the overlay to match PlayerRestIcon
--overlay:SetWidth(PlayerRestIcon:GetWidth())
--overlay:SetHeight(PlayerRestIcon:GetHeight())
--overlay:SetPoint("CENTER", PlayerRestIcon, "CENTER")

-- Set the texture for the overlay
overlay.texture = overlay:CreateTexture()
overlay.texture:SetAllPoints()
overlay.texture:SetTexture("Interface\\AddOns\\tDF\\img\\Unitframe\\UIUnitFrameRestingFlipbook.tga")
--overlay.texture:SetTexture("Interface\\AddOns\\tDF\\img\\Unitframe\\flipbookrested-animation.tga")
overlay.texture:SetTexCoord(0/512, 60/512, 0/512, 60/512)
-----Reskins the zzz-----

----------------ANIMATION----------------
-- Define the TexCoords for each frame of the animation
local texCoords = {
  --x changes by 60 y changes by 60
  -- (1)512 (x)    x    512 (y)      (2)512 (x)    x    512 (y)      (3)512 (x)    x    512 (y)       (4)512 (x)    x    512 (y)       (5)512 (x)    x    512 (y)       (6)512 (x)    x    512 (y)
  {0/512, 60/512, 0/512, 60/512}, {60/512, 120/512, 0/512, 60/512}, {120/512, 180/512, 0/512, 60/512}, {180/512, 240/512, 0/512, 60/512}, {240/512, 300/512, 0/512, 60/512}, {300/512, 360/512, 0/512, 60/512}, --z
  {0/512, 60/512, 60/512,120/512}, {60/512, 120/512, 60/512, 120/512}, {120/512, 180/512, 60/512, 120/512}, {180/512, 240/512, 60/512, 120/512}, {240/512, 300/512, 60/512, 120/512}, {300/512, 360/512, 60/512, 120/512}, --zz
  {0/512, 60/512, 120/512, 180/512}, {60/512, 120/512, 120/512, 180/512}, {120/512, 180/512, 120/512, 180/512}, {180/512, 240/512, 120/512, 180/512}, {240/512, 300/512, 120/512, 180/512}, {300/512, 360/512, 120/512, 180/512}, --zz
  {0/512, 60/512, 180/512, 240/512}, {60/512, 120/512, 180/512, 240/512}, {120/512, 180/512, 180/512, 240/512}, {180/512, 240/512, 180/512, 240/512}, {240/512, 300/512, 180/512, 240/512}, {300/512, 360/512, 180/512, 240/512}, --zzz
  {0/512, 60/512, 240/512, 300/512}, {60/512, 120/512, 240/512, 300/512}, {120/512, 180/512, 240/512, 300/512}, {180/512, 240/512, 240/512, 300/512}, {240/512, 300/512, 240/512, 300/512}, {300/512, 360/512, 240/512, 300/512}, --zzz
  {0/512, 60/512, 300/512, 360/512}, {60/512, 120/512, 300/512, 360/512}, {120/512, 180/512, 300/512, 360/512}, {180/512, 240/512, 300/512, 360/512}, {240/512, 300/512, 300/512, 360/512}, {300/512, 360/512, 300/512, 360/512}, --zzz
  --{0/512, 60/512, 360/512, 410/512}, {60/512, 120/512, 360/512, 410/512}, {120/512, 180/512, 360/512, 410/512}, {180/512, 240/512, 360/512, 410/512}, {240/512, 300/512, 360/512, 410/512}, {300/512, 360/512, 360/512, 410/512}, --zzz

}
--[[
-- Define the TexCoords for each frame of the animation
local texCoords = {
  -- 512 is the x, 64 is the y
  {100/512, 120/512, 34/64, 57/64}, --z
  {163/512, 200/512, 19/64, 57/64}, --zz
  {227/512, 280/512, 4/64, 57/64}, --zzz
  {302/512, 344/512, 3/64, 46/64}, --zz
  {379/512, 408/512, 3/64, 36/64}, --z

}
]]

-- Function to update the texture coordinates
local currentFrame = 1
local function UpdateTexCoords()
  local coords = texCoords[currentFrame]
  overlay.texture:SetTexCoord(unpack(coords))
  currentFrame = currentFrame + 1
  if currentFrame > table.getn(texCoords) then
      currentFrame = 1
  end
end

-- OnUpdate script to change the TexCoords every 0.1 seconds
local timeSinceLastUpdate = 0
local updateInterval = .05 -- .1 default - Adjust this to change the speed of the animation
overlay:SetScript("OnUpdate", function(self, elapsed)
  local elapsed = arg1 or 0
  timeSinceLastUpdate = timeSinceLastUpdate + elapsed
  if timeSinceLastUpdate > updateInterval then
      timeSinceLastUpdate = 0
      UpdateTexCoords()
  end
end)
----------------ANIMATION----------------

----------------SHOW/HIDE ANIMATION----------------
overlay:Hide()

-- Function to check and update the resting state
local function UpdateRestingState()
    if IsResting() then
        overlay:Show()
    else
        overlay:Hide()
    end
end

-- Register the event
overlay:RegisterEvent("PLAYER_UPDATE_RESTING")
overlay:RegisterEvent("PLAYER_ENTERING_WORLD") -- Add this event to check on login
overlay:SetScript("OnEvent", UpdateRestingState)

-- Initial check when the addon is loaded
UpdateRestingState()

----------------SHOW/HIDE ANIMATION----------------

	
--hide
PlayerFrame.name:Hide()
PlayerFrameGroupIndicator:SetAlpha(0)
    PlayerHitIndicator:SetText(nil)
    PlayerHitIndicator.SetText = function() end
    PetHitIndicator:SetText(nil)
    PetHitIndicator.SetText = function() end


  PlayerFrameHealthBar:SetStatusBarTexture[[Interface\Addons\tDF-more-mods\img\UI-StatusBar]]
  TargetFrameHealthBar:SetStatusBarTexture[[Interface\Addons\tDF-more-mods\img\UI-StatusBar]]
  PlayerFrameTexture:SetTexture[[Interface\Addons\tDF-more-mods\img\UI-TargetingFrame]]  
  PlayerStatusTexture:SetTexture[[Interface\Addons\tDF-more-mods\img\UI-Player-Status]]  
  PlayerFrameHealthBar:SetPoint("TOPLEFT", 106, -23)
  PlayerFrameTexture:SetTexture[[Interface\Addons\tDF-more-mods\img\UI-TargetingFrame]]  
  PlayerStatusTexture:SetTexture[[Interface\Addons\tDF-more-mods\img\UI-Player-Status]]  
  PlayerFrameHealthBar:SetPoint("TOPLEFT", 102, -23)
 
  PlayerPortrait:SetHeight(63)
  PlayerPortrait:SetWidth(63)
  PlayerPortrait:SetPoint("TOPLEFT", 44 , -11)
  TargetPortrait:SetPoint("TOPRIGHT", -42 , -10)
  
 
  PlayerFrameHealthBar:SetWidth(124)
  PlayerFrameHealthBar:SetHeight(30)
  PlayerFrameHealthBar:SetPoint("TOPLEFT", 102, -23)
  PlayerFrameManaBar:SetWidth(126)
  PlayerFrameManaBar:SetPoint("TOPLEFT", 102, -52)
  PlayerFrameBackground:SetWidth(122)
  -- PlayerStatusTexture:SetTexture[[Interface\Addons\ShaguTweaks-more-mods\img\UI-Player-Status]]

  -- TargetFrameTexture:SetTexture[[Interface\Addons\ShaguTweaks-more-mods\img\UI-TargetingFrame2]]  
  TargetFrameHealthBar:SetPoint("TOPRIGHT", -103, -23)
  TargetFrameHealthBar:SetHeight(30)
  TargetFrameHealthBar:SetWidth(123)
  TargetFrameManaBar:SetPoint("TOPRIGHT", -100, -52)
  TargetFrameManaBar:SetWidth(127)
  TargetFrameBackground:SetPoint("TOPRIGHT", -100, -22)
  TargetFrameBackground:SetWidth(127)
  --TargetFrame:SetWidth(120)
  -- TargetLevelText:ClearAllPoints()
  -- TargetLevelText:SetPoint("BOTTOMRIGHT",TargetFrameHealthBar, 65, -20)
  
  
  TargetofTargetFrame:ClearAllPoints()
   TargetofTargetFrame:SetPoint("BOTTOM", TargetFrame, 38, -15)
  
  
  
  PetFrame:ClearAllPoints()
  PetFrame:SetPoint("BOTTOM", PlayerFrame, -10, -30)
  PetFrameTexture:SetTexture[[Interface\Addons\tDF-more-mods\img\UI-Player-Status]] 

  

  local original = TargetFrame_CheckClassification
  function TargetFrame_CheckClassification()
    local classification = UnitClassification("target")
    if ( classification == "worldboss" ) then
      TargetFrameTexture:SetTexture[[Interface\Addons\tDF-more-mods\img\UI-TargetingFrame-Elite]]
    elseif ( classification == "rareelite"  ) then
      TargetFrameTexture:SetTexture[[Interface\Addons\tDF-more-mods\img\UI-TargetingFrame-Elite]]
    elseif ( classification == "elite"  ) then
      TargetFrameTexture:SetTexture[[Interface\Addons\tDF-more-mods\img\UI-TargetingFrame-Elite]]
    elseif ( classification == "rare"  ) then
      TargetFrameTexture:SetTexture[[Interface\Addons\tDF-more-mods\img\UI-TargetingFrame-Elite_Rare]]
    else
      TargetFrameTexture:SetTexture[[Interface\Addons\tDF-more-mods\img\UI-TargetingFrame2]]  
    end
  end


  local wait = CreateFrame("Frame")
  wait:RegisterEvent("PLAYER_ENTERING_WORLD")
  wait:SetScript("OnEvent", function()
    if ShaguTweaks.DarkMode then
      PlayerFrameTexture:SetVertexColor(.3,.3,.3,.9)
      TargetFrameTexture:SetVertexColor(.3,.3,.3,.9)
    end

    -- adjust healthbar colors to frame colors
    local original = TargetFrame_CheckFaction
    function TargetFrame_CheckFaction(self)
      original(self)

      if TargetFrameHealthBar._SetStatusBarColor then
        local r, g, b, a = TargetFrameNameBackground:GetVertexColor()
        TargetFrameHealthBar:_SetStatusBarColor(r, g, b, a)
      end
    end
  end)

  -- delay to first draw
  wait:SetScript("OnUpdate", function()
    -- move text strings a bit higher
    if PlayerFrameHealthBar.TextString then
      PlayerFrameHealthBar.TextString:SetPoint("TOP", PlayerFrameHealthBar, "BOTTOM", 0, 23)
    end

    if TargetFrameHealthBar.TextString then
      TargetFrameHealthBar.TextString:SetPoint("TOP", TargetFrameHealthBar, "BOTTOM", -2, 23)
    end

    -- use class color for player (if enabled)
    if PlayerFrameNameBackground then
      -- disable vanilla ui color restore functions
      PlayerFrameHealthBar._SetStatusBarColor = PlayerFrameHealthBar.SetStatusBarColor
      PlayerFrameHealthBar.SetStatusBarColor = function() return end

      -- set player healthbar to class color
      local r, g, b, a = PlayerFrameNameBackground:GetVertexColor()
      PlayerFrameHealthBar:_SetStatusBarColor(r, g, b, a)

      -- hide status textures
      PlayerFrameNameBackground:Hide()
      PlayerFrameNameBackground.Show = function() return end
    end

    -- use frame color for target frame
    if TargetFrameNameBackground then
      -- disable vanilla ui color restore functions
      TargetFrameHealthBar._SetStatusBarColor = TargetFrameHealthBar.SetStatusBarColor
      TargetFrameHealthBar.SetStatusBarColor = function() return end

      -- hide status textures
      TargetFrameNameBackground.Show = function() return end
      TargetFrameNameBackground:Hide()
    end

    TargetFrame_CheckFaction(PlayerFrame)
    wait:UnregisterAllEvents()
    wait:Hide()
  end)
end
