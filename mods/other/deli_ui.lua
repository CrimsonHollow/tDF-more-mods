local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Deli UI",
    description = "Moves unit frames, minimap, buffs and chat based on my preferences.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = nil,
})

module.enable = function(self)
  local resolution = GetCVar("gxResolution")
    local _, _, screenwidth, screenheight = strfind(resolution, "(.+)x(.+)")
    screenwidth = tonumber(screenwidth)
    -- screenheight = tonumber(screenheight)
    -- local res = screenwidth/screenheight
    -- local uw
    -- if res > 1.78 then uw = true end

    local function unitframes()
        -- Player
        PlayerFrame:SetClampedToScreen(true)
        PlayerFrame:ClearAllPoints()
        PlayerFrame:SetPoint("RIGHT", UIParent, "CENTER", -130, -210)

        -- Target
        TargetFrame:SetClampedToScreen(true)
        TargetFrame:ClearAllPoints()
        TargetFrame:SetPoint("LEFT", UIParent, "CENTER", 130, -210)
		
		--TargetOfTarget
		TargetFrame:SetClampedToScreen(true)
		TargetofTargetFrame:ClearAllPoints()
		TargetofTargetFrame:SetPoint("RIGHT", TargetFrame, 55, -5)
end



    local function buffs()
        -- Buffs start with TemporaryEnchantFrame
        -- Debuffs are aligned underneath the TemporaryEnchantFrame
        TemporaryEnchantFrame:ClearAllPoints()
        TemporaryEnchantFrame:SetPoint("BOTTOMRIGHT", PlayerFrame, -5, -7)
		BuffButton0:ClearAllPoints()
		BuffButton0:SetPoint("TOPRIGHT", UIParent, -20, -20)
		BuffButton8:ClearAllPoints()
		BuffButton8:SetPoint("LEFT", BuffButton7, "LEFT", -38, 0 )
		BuffButton16:ClearAllPoints()
		BuffButton16:SetPoint("TOPRIGHT", UIParent, -40, -140)
        -- prevent TemporaryEnchantFrame from moving
        TemporaryEnchantFrame.ClearAllPoints = function() end
        TemporaryEnchantFrame.SetPoint = function() end
		
    end

    local function chat()
        local _, fontsize = ChatFrame1:GetFont()
        -- local lines = 9 -- number of desired chat lines
        -- local h = (fontsize * (lines*1.1))
        local h = 120
        local w = 400
        -- local x = 32
        -- if uw then x = screenwidth/9 end
        local x = screenwidth/9
        local y = 115

        ChatFrame1:SetClampedToScreen(true)
        ChatFrame1:SetWidth(w)
        ChatFrame1:SetHeight(h)
        ChatFrame1:ClearAllPoints()
        ChatFrame1:SetPoint("BOTTOMRIGHT", "UIParent", -x/2, y)
		ChatFrameMenuButton:Hide()
        local found
        local frame




    end
	
local function durability()
DurabilityFrame:SetClampedToScreen(true)
 DurabilityFrame:ClearAllPoints()
 DurabilityFrame:SetPoint("BOTTOMLEFT", 250, 50)
 QuestTimerFrame:ClearAllPoints()
 QuestTimerFrame:SetPoint("LEFT", 0, 100)
end





--Hook QuestWatch function
function QuestWatch_Update()
	local numObjectives;
	local questWatchMaxWidth = 0;
	local tempWidth;
	local watchText;
	local text, type, finished;
	local questTitle
	local watchTextIndex = 1;
	local questIndex;
	local objectivesCompleted;

	for i=1, GetNumQuestWatches() do
		questIndex = GetQuestIndexForWatch(i);
		if ( questIndex ) then
			numObjectives = GetNumQuestLeaderBoards(questIndex);
		
			--If there are objectives set the title
			if ( numObjectives > 0 ) then
				-- Set title
				watchText = getglobal("QuestWatchLine"..watchTextIndex);
				watchText:SetText(GetQuestLogTitle(questIndex));
				tempWidth = watchText:GetWidth();
				-- Set the anchor of the title line a little lower
				if ( watchTextIndex > 1 ) then
					-- watchText:SetPoint("TOPLEFT", "QuestWatchLine"..(watchTextIndex - 1), "BOTTOMLEFT", 0, -4);
				end
				watchText:Show();
				if ( tempWidth > questWatchMaxWidth ) then
					questWatchMaxWidth = tempWidth;
				end
				watchTextIndex = watchTextIndex + 1;
				objectivesCompleted = 0;
				for j=1, numObjectives do
					text, type, finished = GetQuestLogLeaderBoard(j, questIndex);
					watchText = getglobal("QuestWatchLine"..watchTextIndex);
					-- Set Objective text
					watchText:SetText(" - "..text);
					-- Color the objectives
					if ( finished ) then
						watchText:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
						objectivesCompleted = objectivesCompleted + 1;
					else
						watchText:SetTextColor(0.8, 0.8, 0.8);
					end
					tempWidth = watchText:GetWidth();
					if ( tempWidth > questWatchMaxWidth ) then
						questWatchMaxWidth = tempWidth;
					end
					-- watchText:SetPoint("TOPLEFT", "QuestWatchLine"..(watchTextIndex - 1), "BOTTOMLEFT", 0, 0);
					watchText:Show();
					watchTextIndex = watchTextIndex + 1;
				end
				-- Brighten the quest title if all the quest objectives were met
				watchText = getglobal("QuestWatchLine"..watchTextIndex-numObjectives-1);
				if ( objectivesCompleted == numObjectives ) then
					watchText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
				else
					watchText:SetTextColor(0.75, 0.61, 0);
				end
			end
		end
	end

	-- Set tracking indicator
	if ( GetNumQuestWatches() > 0 ) then
		QuestLogTrackTracking:SetVertexColor(0, 1.0, 0);
	else
		QuestLogTrackTracking:SetVertexColor(1.0, 0, 0);
	end
	
	-- If no watch lines used then hide the frame and return
	if ( watchTextIndex == 1 ) then
		QuestWatchFrame:Hide();
		return;
	else
		QuestWatchFrame:Show();
		QuestWatchFrame:SetHeight(watchTextIndex * 13);
		QuestWatchFrame:SetWidth(questWatchMaxWidth + 10);
	end

	-- Hide unused watch lines
	for i=watchTextIndex, MAX_QUESTWATCH_LINES do
		getglobal("QuestWatchLine"..i):Hide();
	end

end



--Move QuestWatchFrame

local function questlogpos()
QuestWatchFrame:ClearAllPoints()
QuestWatchFrame:SetPoint("LEFT", 20, 0)
end

--Override the durability and questwatch positioning

local timer = CreateFrame("Frame")
  timer:Hide()
  timer:SetScript("OnUpdate", function()
    if GetTime() >= timer.time then
      timer.time = nil
      durability()
	  questlogpos()
      this:Hide()
      this:SetScript("OnUpdate", nil)
    end
  end)

  local events = CreateFrame("Frame", nil, UIParent)
  events:RegisterEvent("PLAYER_ENTERING_WORLD","QUEST_LOG_UPDATE","QUEST_WATCH_UPDATE","WORLD_MAP_UPDATE","ZONE_CHANGED_NEW_AREA")
  events:SetScript("OnEvent", function()
      -- trigger the timer to go off 1 second after login
      timer.time = GetTime() + 0.5
      timer:Show()
    end)


    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        if not this.loaded then
            this.loaded = true
            unitframes()
			--durability()
            buffs()
            chat()
        end
    end)
end

