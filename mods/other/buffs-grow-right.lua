local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Buffs Right",
    description = "Puts the buffs to the left and makes them grow the the right!.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Deli UI",
    enabled = true,
})

module.enable = function(self)

    local function buffs()
        -- Buffs start with TemporaryEnchantFrame
        -- Debuffs are aligned underneath the TemporaryEnchantFrame
        TemporaryEnchantFrame:ClearAllPoints()
        TemporaryEnchantFrame:SetPoint("BOTTOMRIGHT", PlayerFrame, -5, -7)
		BuffButton0:ClearAllPoints()
		BuffButton0:SetPoint("TOPLEFT", UIParent, 20, -20)
		BuffButton8:ClearAllPoints()
		BuffButton8:SetPoint("RIGHT", BuffButton7, "RIGHT", 38, 0 )
		BuffButton16:ClearAllPoints()
		BuffButton16:SetPoint("BOTTOMLEFT", BuffButton0, 0, -140 )
		BuffButton17:ClearAllPoints()
		BuffButton17:SetPoint("LEFT",BuffButton16,"RIGHT",5,0)
		BuffButton18:ClearAllPoints()
		BuffButton18:SetPoint("LEFT",BuffButton17,"RIGHT",5,0)
		BuffButton19:ClearAllPoints()
		BuffButton19:SetPoint("LEFT",BuffButton18,"RIGHT",5,0)
		BuffButton20:ClearAllPoints()
		BuffButton20:SetPoint("LEFT",BuffButton19,"RIGHT",5,0)
		BuffButton21:ClearAllPoints()
		BuffButton21:SetPoint("LEFT",BuffButton20,"RIGHT",5,0)
		BuffButton22:ClearAllPoints()
		BuffButton22:SetPoint("LEFT",BuffButton21,"RIGHT",5,0)
		BuffButton23:ClearAllPoints()
		BuffButton23:SetPoint("LEFT",BuffButton22,"RIGHT",5,0)
		
        -- prevent TemporaryEnchantFrame from moving
        -- TemporaryEnchantFrame.ClearAllPoints = function() end
        -- TemporaryEnchantFrame.SetPoint = function() end
		
    end

buffs()

-- Override the default BuffFrame_UpdateAllBuffAnchors function
function BuffFrame_UpdateAllBuffAnchors()
    local buff, previousBuff, aboveBuff, aboveDeBuff, previousDeBuff, DeBuff;
    local numBuffs = 0;
	local numDeBuffs = 15;
    for i = 1, 15 do
        buff = _G["BuffButton"..i];
        if buff and buff:IsShown() then
            numBuffs = numBuffs + 1;
            buff:ClearAllPoints();
            if numBuffs == 1 then
                buff:SetPoint("TOPLEFT", BuffButton0, "TOPRIGHT", 5, 0);
                aboveBuff = buff;
            else
                buff:SetPoint("LEFT", previousBuff, "RIGHT", 5, 0);
            end
            previousBuff = buff;
        end
    end

end


-- Call the function once to set initial positions
BuffFrame_UpdateAllBuffAnchors()

-- Override the default BuffFrame_UpdateAllBuffAnchors function

 function BuffButton_OnUpdate()
	local buffDuration = getglobal(this:GetName().."Duration");
	if ( this.untilCancelled == 1 ) then
		buffDuration:Hide();
		return;
	end

	local buffIndex = this.buffIndex;
	local timeLeft = GetPlayerBuffTimeLeft(buffIndex);
	if ( timeLeft < BUFF_WARNING_TIME ) then
		this:SetAlpha(BUFF_ALPHA_VALUE);
	else
		this:SetAlpha(1.0);
	end

	-- Update duration
	BuffFrame_UpdateDuration(this, timeLeft);

	if ( BuffFrameUpdateTime > 0 ) then
		return;
	end
	if ( GameTooltip:IsOwned(this) ) then
		GameTooltip:SetPlayerBuff(buffIndex);
	end
	BuffFrame_UpdateAllBuffAnchors()
end
end