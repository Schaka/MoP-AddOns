--[[
    ArenaLive [Spectator] is an user interface for spectated arena 
	wargames in World of Warcraft.
    Copyright (C) 2015  Harald Böhm <harald@boehm.agency>
	Further contributors: Jochen Taeschner and Romina Schmidt.
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
	
	ADDITIONAL PERMISSION UNDER GNU GPL VERSION 3 SECTION 7:
	As a special exception, the copyright holder of this add-on gives you
	permission to link this add-on with independent proprietary software,
	regardless of the license terms of the independent proprietary software.
]]

local addonName, L = ...;

ArenaLiveSpectator.defaults = {
	["Broadcast"] = true,
	["FirstLogin"] = true,
	["FollowTarget"] = true,
	["HideTargetFrames"] = true,
	["PlayMode"] = 3,
	["ShowScoreBoard"] = true,
	["Version"] = "3.2.3b",
	["ImportantMessageFrame"] = {
		["NumMaxMessages"] = 2,
	},
	["TeamA"] = {
		["Name"] = "Gold Team",
		["Leader"] = "",
		["Score"] = 0,
		["Colour"] = { 1, 0.83, 0, 1 }, -- Gold Team (old blue 0, 0.5, 1, 1)
	},
	["TeamB"] = {
		["Name"] = "Green Team",
		["Leader"] = "",
		["Score"] = 0,
		["Colour"] = { 0.03, 0.71, 0, 1 }, -- Green Team (old: red 1, 0.19, 0, 1)
	},
	["MatchStatistic"] = {
	},
	["NicknameDatabase"] = {
	},
	["FrameMover"] = {
		["FrameLock"] = true,
	},
	["Cooldown"] =	{
		["ShowText"] = true,
		["StaticSize"] = false,
		["TextSize"] = 8,
	},
	["CCIndicator"] =	{
		["Priorities"] = {
			["defCD"] = 9,
			["offCD"] = 3,
			["stun"] = 8,
			["silence"] = 7,
			["crowdControl"] = 6,
			["root"] = 5,
			["disarm"] = 4,
			["usefulBuffs"] = 0,
			["usefulDebuffs"] = 0,
		},
	},
	["TargetFrame"] = {
		["UnitFrame"] = {
			["Enabled"] = true,
			["TooltipMode"] = "Never",
			["Scale"] = 1,
		},
		["HealthBar"] = {
			["ColourMode"] = "class",
			["ShowHealPrediction"] = true,
			["ShowAbsorb"] = true,
		},
		["HealthBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
			["ShowDeadOrGhost"] = true,
			["ShowDisconnect"] = true,
		},
		["PowerBar"] = {
		},
		["PowerBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
		},
		["Portrait"] = {
			["Type"] = "class",
		},
		["NameText"] = {
			["ColourMode"] = "none",
			["FontObject"] = "ArenaLiveFont_Name",
		},
		["CCIndicator"] = {
			["Enabled"] = true,
		},
		["CastBar"] = {
			["Enabled"] = true,
		},
		["CastHistory"] = {
			["Enabled"] = true,
			["Size"] = 21,
			["Direction"] = "RIGHT",
			["IconDuration"] = 10,
			["MaxIcons"] = 9,
		},
		["Aura"] = {
			["Enabled"] = true,
			["MaxShownBuffs"] = 8,
			["MaxShownDebuffs"] = 16,
			["AurasPerRow"] = 8,
			["NormalIconSize"] = 26,
			["LargeIconSize"] = 26,
			["GrowRTL"] = false,
			["GrowUpwards"] = false,
			["ShowOnlyPlayerDebuffs"] = false,
			["OnlyShowRaidBuffs"] = false,
			["OnlyShowDispellableDebuffs"] = false,
			["SpectatorFilter"] = true,
		},
	},
	["TargetTargetFrame"] = {
		["UnitFrame"] = {
			["Enabled"] = true,
			["TooltipMode"] = "Never",
			["Scale"] = 1,
		},
		["HealthBar"] = {
			["ColourMode"] = "class",
			["ShowHealPrediction"] = true,
			["ShowAbsorb"] = true,
		},
		["HealthBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
			["ShowDeadOrGhost"] = true,
			["ShowDisconnect"] = true,
		},
		["PowerBar"] = {
		},
		["PowerBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
		},
		["Portrait"] = {
			["Type"] = "class",
		},
		["NameText"] = {
			["ColourMode"] = "none",
			["FontObject"] = "ArenaLiveFont_Name",
		},
		["CCIndicator"] = {
			["Enabled"] = true,
		},
		["CastBar"] = {
			["Enabled"] = true,
		},
		["CastHistory"] = {
			["Enabled"] = true,
			["Size"] = 21,
			["Direction"] = "LEFT",
			["IconDuration"] = 10,
			["MaxIcons"] = 9,
		},
		["Aura"] = {
			["Enabled"] = true,
			["MaxShownBuffs"] = 8,
			["MaxShownDebuffs"] = 16,
			["AurasPerRow"] = 8,
			["NormalIconSize"] = 26,
			["LargeIconSize"] = 26,
			["GrowRTL"] = true,
			["GrowUpwards"] = false,
			["ShowOnlyPlayerDebuffs"] = false,
			["OnlyShowRaidBuffs"] = false,
			["OnlyShowDispellableDebuffs"] = false,
			["SpectatorFilter"] = true,
		},
	},
	["Left"] = {
		["UnitFrame"] = {
			["Enabled"] = true,
			["TooltipMode"] = "Never",
			["Scale"] = 1,
		},
		["HealthBar"] = {
			["ColourMode"] = "class",
			["ShowHealPrediction"] = true,
			["ShowAbsorb"] = true,
		},
		["HealthBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
			["ShowDeadOrGhost"] = nil,
			["ShowDisconnect"] = true,
		},
		["PowerBar"] = {
		},
		["PowerBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
		},
		["Portrait"] = {
			["Type"] = "class",
		},
		["NameText"] = {
			["ColourMode"] = "none",
			["FontObject"] = "ArenaLiveFont_Name",
		},
		["CCIndicator"] = {
			["Enabled"] = true,
		},
		["CastBar"] = {
			["Enabled"] = true,
		},
		["CooldownTracker"] = {
			["GrowingDirection"] = "RIGHT",
			["MaxShownIcons"] = 6,
			["ShowTrinket"] = true,
			["ShowRacial"] = true,
			["numMaxDefCDs"] = 3,
			["numMaxOffCDs"] = 3,
			["ShowTooltip"] = true,
			["Space"] = 3,
		},
		["CastHistory"] = {
			["Enabled"] = true,
			["Size"] = 18,
			["Direction"] = "RIGHT",
			["IconDuration"] = 7,
			["MaxIcons"] = 4,
		},
		["Aura"] = {
			["Enabled"] = true,
			["MaxShownBuffs"] = 8,
			["MaxShownDebuffs"] = 16,
			["AurasPerRow"] = 8,
			["NormalIconSize"] = 20,
			["LargeIconSize"] = 20,
			["GrowRTL"] = false,
			["GrowUpwards"] = false,
			["ShowOnlyPlayerDebuffs"] = false,
			["OnlyShowRaidBuffs"] = false,
			["OnlyShowDispellableDebuffs"] = false,
			["SpectatorFilter"] = true,
		},
	},
	["Right"] = {
		["UnitFrame"] = {
			["Enabled"] = true,
			["TooltipMode"] = "Never",
			["Scale"] = 1,
		},
		["HealthBar"] = {
			["ColourMode"] = "class",
			["ShowHealPrediction"] = true,
			["ShowAbsorb"] = true,
		},
		["HealthBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
			["ShowDeadOrGhost"] = nil,
			["ShowDisconnect"] = true,
		},
		["PowerBar"] = {
		},
		["PowerBarText"] = {
			["BarText"] = "%CURR_SHORT% (%PERCENT_SHORT%%)",
			["FontObject"] = "ArenaLiveFont_StatusBarTextSmall",
			["BarTextSize"] = 10,
		},
		["Portrait"] = {
			["Type"] = "class",
		},
		["NameText"] = {
			["ColourMode"] = "none",
			["FontObject"] = "ArenaLiveFont_Name",
		},
		["CCIndicator"] = {
			["Enabled"] = true,
		},
		["CastBar"] = {
			["Enabled"] = true,
		},		
		["CooldownTracker"] = {
			["GrowingDirection"] = "LEFT",
			["MaxShownIcons"] = 6,
			["ShowTrinket"] = true,
			["ShowRacial"] = true,
			["numMaxDefCDs"] = 3,
			["numMaxOffCDs"] = 3,
			["ShowTooltip"] = true,
			["Space"] = 3,
		},
		["CastHistory"] = {
			["Enabled"] = true,
			["Size"] = 18,
			["Direction"] = "LEFT",
			["IconDuration"] = 7,
			["MaxIcons"] = 4,
		},
		["Aura"] = {
			["Enabled"] = true,
			["MaxShownBuffs"] = 8,
			["MaxShownDebuffs"] = 16,
			["AurasPerRow"] = 8,
			["NormalIconSize"] = 20,
			["LargeIconSize"] = 20,
			["GrowRTL"] = true,
			["GrowUpwards"] = false,
			["ShowOnlyPlayerDebuffs"] = false,
			["OnlyShowRaidBuffs"] = false,
			["OnlyShowDispellableDebuffs"] = false,
			["SpectatorFilter"] = true,
		},
	},
	["NamePlate"] = {
		["CCIndicator"] = {
			["Enabled"] = true,
		},
		["HealthBar"] = {
			["ColourMode"] = "class",
			["ShowHealPrediction"] = false,
			["ShowAbsorb"] = true,
		},
	},
};

-- Tables that store player info during matches:
local unitNameToInfo = {};
-- Table to store callback functions for match start:
local onMatchStartCallbackList = {};

local slashCMDs = {
	["help"] = L["Shows this info message."],
	["menu"] = L["Shows the War Game Menu"],
	["stats"] = L["Shows the Match Statistic"],
};

-- Slash Commands:
SLASH_ARENALIVESPECTATOR1, SLASH_ARENALIVESPECTATOR2 = "/alspec", "/arenalivespectator";
function SlashCmdList.ARENALIVESPECTATOR (msg, editBox )
	if ( not msg or msg == "" or msg == "menu" ) then
		ArenaLiveSpectatorWarGameMenu:Show();
	elseif ( msg == "stats" ) then
		ArenaLiveSpectatorMatchStatistic:Open();
	elseif ( msg == "help" ) then
		ArenaLive:Message(L["Available Slash Commands for ArenaLive [Spectator] are:"], "message");
		for cmd, description in pairs(slashCMDs) do
			print(string.format(L["%s: %s"], cmd, description));
		end
	end
end

-- Custom function to check if player currently is a spectator.
--[[ 
	 From Blizzard: "You can use "C_Commentator.GetMode()" to see if you
	 are a spectator. It should return 0 if you are not a spectator,
	 and non-zero if you are some type of spectator. (I believe 1 and
	 2 are reserved for our internal commentator feature, so it should
	 return 3 for you)."
]]--
function IsSpectator()
	local _, instanceType = IsInInstance();
	if ( instanceType ~= "arena" and instanceType ~= "pvp" ) then
		instanceType = nil;
	elseif ( instanceType == "pvp" ) then
		instanceType = "battleground";
	end
	
	--return ( C_Commentator.GetMode() > 0 ), instanceType;
	return 1, instanceType;
end

function ArenaLiveSpectator:Enable(battlefieldStatusID)
	if ( self.enabled and battlefieldStatusID == self.currentStatusID ) then
		return;
	end
	
	ArenaLiveSpectatorWarGameMenu:Hide();
	UIParent:Hide();
	self:Show();
	
	self.currentStatusID = battlefieldStatusID;
	
	-- Register events:
	self:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("UNIT_PET");
	self:RegisterEvent("UNIT_AURA");
	self:RegisterEvent("WORLD_STATE_UI_TIMER_UPDATE");
	
	-- Update Leader to check for team swap:
	local leaderName, leaderRealm = ArenaLiveSpectator:RequestLeader();
	if ( leaderName and leaderRealm ) then
		ArenaLiveSpectator:SetLeader(leaderName, leaderRealm);
	end
	
	ArenaLiveSpectatorScoreBoard:UpdateTeamName("TeamA");
	ArenaLiveSpectatorScoreBoard:UpdateTeamName("TeamB");
	ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamA");
	ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamB");	
	
	local database = ArenaLive:GetDBComponent(addonName);
	self:SetNumPlayers(database.PlayMode);
	self:UpdateTeamOrder();
	ArenaLiveSpectatorHideUIButton:Show();
	ArenaLiveSpectatorMatchStatistic:SetParent("ArenaLiveSpectator");
	self:CallOnMatchStart(function() ArenaLiveSpectatorMatchStatistic:Start(); end, "ArenaLiveSpectatorMatchStatistic:Start()");
	ArenaLiveSpectatorMatchStatistic.leaveButton:Enable();

	self.enabled = true;
end

function ArenaLiveSpectator:Disable()
	self:Hide();
	ArenaLiveSpectatorHideUIButton:Hide();
	UIParent:Show();
	
	ArenaLiveSpectatorScoreBoard:Reset();
	ArenaLiveSpectatorMatchStatistic:SetParent("UIParent");
	if ( ArenaLiveSpectatorMatchStatistic:IsRecording() ) then
		ArenaLiveSpectatorMatchStatistic:Stop();
	end
	
	if ( ArenaLiveSpectatorMatchStatistic:IsShown() ) then
		ArenaLiveSpectatorMatchStatistic:Hide();
		ArenaLiveSpectatorMatchStatistic:Show();
	end
	
	-- Unregister events:
	self:UnregisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL");
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:UnregisterEvent("PLAYER_TARGET_CHANGED");
	self:UnregisterEvent("UNIT_PET");
	self:UnregisterEvent("UNIT_AURA");
	self:UnregisterEvent("WORLD_STATE_UI_TIMER_UPDATE");	
	
	-- Disable Side frames:
	local frame;
	for i = 1, 5 do
		-- Disable Side frames:
		frame = _G["ALSPEC_LeftSideFramesFrame"..i];
		frame:Disable();
		frame = _G["ALSPEC_RightSideFramesFrame"..i];
		frame:Disable();
		
		-- Disable Cooldown Trackers:
		frame = _G["ALSPEC_CDTrackersLeftTracker"..i];
		frame:Disable();
		frame = _G["ALSPEC_CDTrackersRightTracker"..i];
		frame:Disable();
	end
	
	-- Disable Target and Target of Target:
	frame = _G["ALSPEC_TargetFrame"];
	frame:Disable();
	
	frame = _G["ALSPEC_TargetTargetFrame"];
	frame:Disable();

	self.currentStatusID = nil;
	self.hasStarted = nil;
	self.leader = nil;
	self.swapTeams = false;
	self.worldStateTimerIndex = nil;
	
	self.enabled = false;
end

function ArenaLiveSpectator:IsEnabled()
	return self.enabled;
end

function ArenaLiveSpectator:HasMatchStarted()
	--ArenaLive:Message("Called ArenaLiveSpectator:HasMatchStarted(): self.hasStared = %s", "debug", tostring(self.hasStarted));
	return self.hasStarted;
end

function ArenaLiveSpectator:CallOnMatchStart(callbackFunc, funcName)
	--ArenaLive:Message(L["ArenaLiveSpectator:CallOnMatchStart(): %s: %s"], "debug", tostring(funcName), tostring(callbackFunc));
	if ( not self:HasMatchStarted() ) then
		onMatchStartCallbackList[callbackFunc] = funcName or true;
	else
		callbackFunc();
	end
end

function ArenaLiveSpectator:SetNumPlayers(numPlayers)
	ArenaLiveSpectator:SetUpSideFrames(numPlayers);
	ArenaLiveSpectator:SetUpTargetFrames(numPlayers);
	ArenaLiveSpectator:SetUpCooldownTracker(numPlayers);
end

function ArenaLiveSpectator:BroadcastLeader()
	local leader = self:GetLeader();
	if ( leader and IsInGroup() and UnitIsGroupLeader("player") ) then
		local msg = "UPDATE_TEAM_LEADER;"..leader;
		SendAddonMessage("ALSPEC", msg, "RAID");
	end
end

function ArenaLiveSpectator:GetLeader()
	return self.leader;
end

function ArenaLiveSpectator:RequestLeader()
	if ( not IsInGroup() or UnitIsGroupLeader("player") ) then
		local database = ArenaLive:GetDBComponent(addonName, nil, "TeamA");
		local battleTag = database.Leader;
		if ( battleTag ) then
			local _, _, _, _, toonID = ArenaLiveSpectatorWarGameMenu:GetPlayerDataByBattleTag(battleTag);
			if ( toonID ) then
				local _, toonName, client, toonRealm = BNGetToonInfo(toonID);
				if ( client == BNET_CLIENT_WOW and toonName and toonRealm ) then
					return toonName, toonRealm, false;
				end
			end
		end
		
		return nil, nil, false;
	else
		local msg = "REQUEST_TEAM_LEADER;nil";
		SendAddonMessage("ALSPEC", msg, "RAID");
		return nil, nil, true;
	end
end

function ArenaLiveSpectator:SetLeader(leaderName, leaderRealm)
	if ( not leaderName or not leaderRealm ) then
		return;
	end
	leaderRealm = string.gsub(leaderRealm, " ", "");
	self.leader = leaderName.."-"..leaderRealm;
	ArenaLive:Message("Set new leader %s.", "debug", self.leader);
	self:CheckForTeamSwap();
	self:BroadcastLeader();
end

function ArenaLiveSpectator:CheckForTeamSwap()
	local numTeamB = ArenaLiveSpectator.UnitCache:GetNumPlayers(2);
	if ( self.leader and not self.swapTeams ) then
		local leaderName, leaderRealm = string.match(self.leader, "(.+)-(.+)");
		local playerRealm = GetRealmName();
		for i = 1, numTeamB do
			local name, realm = UnitName("spectatedb"..i);
			if ( (name == leaderName ) and ( realm == leaderRealm or ( not realm and leaderRealm == playerRealm ) ) ) then
				ArenaLive:Message("Left team's leader is \"spectatedb\" unit type, swapping team names...", "debug", self.leader);
				self.swapTeams = true;
				ArenaLiveSpectatorScoreBoard:Update();
				if ( IsAddOnLoaded("BGLive") ) then
					BGLive.swapTeams = true;
					BGLiveScoreBoard:Update();
				end
			end
		end
	end
end



local unitSortOrder = { [1] = {}, [2] = {} };
-- Sort roughly is Melee > Tank > Caster > Healer
-- With a spec dependent sorting mechanism,
-- players will be shown in a order representing
-- most common comp names (e.g. RMP, FMP, WMP RLS, WLS, MLS etc.)
local specSortPriorities = {
		[103] = 34, -- Feral Druid
		[70] = 33,	-- Retribution Paladin
		[251] = 31,	-- Frost Deathknight
		[252] = 30,	-- Unholy Deathknight
		[259] = 29,	-- Assassination Rogue
		[260] = 28,	-- Combat Rogue
		[261] = 27,	-- Subtlety Rogue
		[71] = 26,	-- Arms Warrior
		[72] = 25,	-- Fury Warrior
		[263] = 24,	-- Enhancement Shaman
		[269] = 23,	-- Windwalker Monk
		
		[250] = 32,	-- Blood Deathknight
		[73] = 22,	-- Protection Warrior
		[66] = 21,	-- Protection Paladin
		[268] = 20,	-- Brewmaster Monk
		[104] = 19,	-- Guardian Druid
		
		[253] = 18,	-- Beast Mastery Hunter
		[254] = 17,	-- Marksmanship Hunter
		[255] = 16,	-- Survival Hunter
		[258] = 15,	-- Shadow Priest
		[62] = 14,	-- Arcane Mage
		[63] = 13,	-- Fire Mage
		[64] = 12,	-- Frost Mage	
		[265] = 11,	-- Affliction Warlock
		[266] = 10,	-- Demonology Warlock
		[267] = 9,	-- Destruction Warlock
		[262] = 8,	-- Elemental Shaman
		[102] = 7,	-- Balance Druid
		
		[105] = 6,	-- Restoration Druid
		[270] = 5,	-- Mistweaver Monk
		[65] = 4,	-- Holy Paladin
		[256] = 3,	-- Discipline Priest
		[257] = 2,	-- Holy Priest
		[264] = 1,	-- Restoration Shaman
};
local sortUnitMod;
local function unitSortFunc(numA, numB)
	local unitA = sortUnitMod..numA;
	local unitB = sortUnitMod..numB;
	
	local aSpec = ArenaLiveSpectator.UnitCache:GetUnitSpecialisation(unitA);
	local bSpec = ArenaLiveSpectator.UnitCache:GetUnitSpecialisation(unitB);
	if  ( not aSpec and bSpec ) then
		return false;
	elseif ( aSpec and not bSpec ) then
		return true;
	elseif ( not aSpec and not bSpec ) then
		return numA > numB;
	else
		local aPrio, bPrio = specSortPriorities[aSpec], specSortPriorities[bSpec];
		if ( aPrio == bPrio ) then
			return numA > numB;
		else
			return aPrio > bPrio;
		end
	end
end

function ArenaLiveSpectator:GetUnitByOrderID(teamID, sortID)
	if ( not teamID or not sortID )  then
		ArenaLive:Message(L["%s: Usage %s"], "error", "ArenaLiveSpectator:GetUnitByOrderID()", "ArenaLiveSpectator:GetUnitByOrderID(teamID, sortID)");
	elseif ( teamID > 2 or teamID < 1  )then
		return nil;
	else
		local id = unitSortOrder[teamID][sortID];
		if ( id ) then
			if ( teamID == 1 ) then
				return "spectateda"..id;
			else
				return "spectatedb"..id;
			end
		else
			return nil;
		end
	end
end

function ArenaLiveSpectator:UpdateTeamOrder()

	local numA = ArenaLiveSpectator.UnitCache:GetNumPlayers(1);
	local numB = ArenaLiveSpectator.UnitCache:GetNumPlayers(2);

	-- Reset old values:
	table.wipe(unitSortOrder[1]);
	table.wipe(unitSortOrder[2]);
	
	for i = 1, 5 do
		if ( i > numA and i > numB ) then
			break;
		end
		
		if ( i <= numA ) then
			table.insert(unitSortOrder[1], i);
		end
		
		if ( i <= numB ) then
			table.insert(unitSortOrder[2], i);
		end
	end
	
	sortUnitMod = "spectateda";
	table.sort(unitSortOrder[1], unitSortFunc);
	
	sortUnitMod = "spectatedb";
	table.sort(unitSortOrder[2], unitSortFunc);
	
	local database = ArenaLive:GetDBComponent(addonName);
	for i = 1, database.PlayMode do
		local unit = ArenaLiveSpectator:GetUnitByOrderID(1, i);
		
		local frame = _G["ALSPEC_LeftSideFramesFrame"..i];
		frame:UpdateUnit(unit);
		
		frame = _G["ALSPEC_CDTrackersLeftTracker"..i];
		frame:UpdateUnit(unit);
		
		unit = ArenaLiveSpectator:GetUnitByOrderID(2, i);
		
		frame = _G["ALSPEC_RightSideFramesFrame"..i];
		frame:UpdateUnit(unit);
		
		frame = _G["ALSPEC_CDTrackersRightTracker"..i];
		frame:UpdateUnit(unit);
	end
	
end



function ArenaLiveSpectator:OnEvent(event, ...)
	local filter = ...;
	if ( event == "ADDON_LOADED" and filter == addonName ) then
		-- Initialise Nickname Database:
		self.NicknameDatabase:Initialise()
		
		-- Initialise frames:
		self:InitialiseSideFrames();
		self:InitialiseTargetFrames();
		self:InitialiseCooldownTracker();
		ArenaLiveSpectatorScoreBoard:Initialise();
		ArenaLiveSpectatorMatchStatistic:Initialise();
		ArenaLiveSpectatorWarGameMenu:Initialise();
		ArenaLiveSpectatorPlayerInfoFrame:Initialise();
		ArenaLive:ConstructHandlerObject(ArenaLiveSpectatorMessageFrame, "ImportantMessageFrame", addonName, nil);
		
		-- Set up hide normal UI button, it shows up if UIParent is somehow shown during a match:
		ArenaLiveSpectatorHideUIButtonText:SetText(L["Hide normal UI"]);
		local width = ArenaLiveSpectatorHideUIButtonText:GetWidth();
		width = width + 30;
		ArenaLiveSpectatorHideUIButton:SetWidth(width);
		ArenaLiveSpectatorHideUIButton:SetScript("OnClick", ArenaLiveSpectatorHideUIButton.OnClick);
		
		-- Register addon prefix for receiving team data broadcasts:
		local success = RegisterAddonMessagePrefix("ALSPEC");
		if ( not success ) then
			ArenaLive:Message(L["WARNING! Couldn't register addon message prefix for ArenaLive [Spectator]. You won't be able to receive broadcast data during this session."], "message");
		end
		
		self:Disable();
		ArenaLive:Message(L["Spectator addon has been loaded successfully! Type /alspec to open the spectator war game menu or /alspec help for a list of available commands."], "message");
	elseif ( event == "AL_SPEC_MATCH_START" ) then
		-- Iterate through all callback functions that have registered for match start:
		ArenaLive:Message("Match begins, iterating through callbacks:", "debug");
		for callbackFunc, funcName in pairs(onMatchStartCallbackList) do
			ArenaLive:Message(L["%s: %s"], "debug", funcName, tostring(callbackFunc));
			callbackFunc();
			onMatchStartCallbackList[callbackFunc] = nil;
		end
	elseif ( event == "AL_SPEC_PLAYER_UPDATE" ) then
		local unit, state = ...;
		ArenaLiveSpectator:UpdateSideFrameByUnit(unit, state);
		if ( not self.swapTeams ) then
			self:CheckForTeamSwap();
		end
	elseif ( event == "AL_SPEC_PLAYER_SPECIALIZATION_UPDATE" ) then
		ArenaLiveSpectator:UpdateTeamOrder();
		ArenaLiveSpectatorPlayerInfoFrame:OnPlayerSpecialisationUpdate(...);
	elseif ( event == "BN_FRIEND_TOON_ONLINE" or event == "BN_TOON_NAME_UPDATED" or event == "BN_FRIEND_TOON_OFFLINE" or event == "BN_FRIEND_LIST_SIZE_CHANGED" ) then
		-- BN_TOON_NAME_UPDATED: Args seem to be: toonID, toonName, unknown(boolean)
		ArenaLiveSpectatorWarGameMenu:BNFriendEvent();
	elseif ( event == "CHAT_MSG_ADDON" and filter == "ALSPEC" ) then
		local _, message, channel, sender = ...;
		local playerName = UnitName("player");
		local realmName = GetRealmName();
		realmName = string.gsub(realmName, " ", "");
		playerName = playerName.."-"..realmName;
		
		if ( sender == playerName ) then
			return;
		end

		local command = string.split(";", message); 
		if ( command == "TEAM_UPDATE" ) then
			local _, leftTeamName, leftTeamScore, rightTeamName, rightTeamScore, bracket = string.split(";", message);
			ArenaLive:Message(L["Received team data from group leader (%s). Updating team entries... (%s)"], "normal", sender, bracket);
			local database = ArenaLive:GetDBComponent(addonName);
			database.TeamA.Name = leftTeamName;
			database.TeamA.Score = tonumber(leftTeamScore);
			database.TeamB.Name = rightTeamName;
			database.TeamB.Score = tonumber(rightTeamScore);
			database.PlayMode = tonumber(bracket);
			
			-- Update option frames:
			ArenaLiveSpectatorWarGameMenuWarGamesLeftTeamName:UpdateShownValue();
			ArenaLiveSpectatorWarGameMenuWarGamesLeftTeamScore:UpdateShownValue();
			ArenaLiveSpectatorWarGameMenuWarGamesRightTeamName:UpdateShownValue();
			ArenaLiveSpectatorWarGameMenuWarGamesRightTeamScore:UpdateShownValue();
			ArenaLiveSpectatorWarGameMenuWarGamesPlayModeDropDown:UpdateShownValue();
			ArenaLiveSpectatorWarGameMenuWarGamesPlayModeDropDown:postUpdate();
			
			ArenaLiveSpectatorScoreBoard:Update();
			if ( IsAddOnLoaded("BGLive") ) then
				BGLiveScoreBoard:Update();
			end
		elseif ( command == "REQUEST_TEAM_LEADER" and UnitIsGroupLeader("player") ) then
			self:BroadcastLeader();
		elseif ( command == "UPDATE_TEAM_LEADER" ) then
			local _, leader = string.split(";", message);
			local name, realm = string.match(leader, "(.+)-(.+)");
			ArenaLive:Message("Received team leader information: %s, %s.", "debug", tostring(name), tostring(realm));
			ArenaLiveSpectator:SetLeader(name, realm);
		end
	elseif ( event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" and self.enabled ) then
		local seconds = string.match(filter, L["(.+) seconds until the Arena battle begins!"]);
		if ( seconds ) then
			local numSeconds; 
			if ( seconds == L["Thirty"] ) then
				numSeconds = 30;
			elseif ( seconds == L["Fifteen"] ) then
				numSeconds = 15;
			end
			
			if ( numSeconds ) then
				ArenaLiveSpectatorCountDown:SetTimer(numSeconds, 60);
			end
		elseif ( filter == L["One minute until the Arena battle begins!"] ) then
			ArenaLiveSpectatorCountDown:SetTimer(60, 60);
		elseif ( filter == L["The Arena battle has begun!"] ) then
			ArenaLiveSpectatorCountDown:SetTimer(0, 60);
		end
	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED" ) then
		ArenaLiveSpectatorMatchStatistic:OnEvent(event, ...)
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		if ( BNFeaturesEnabled() and BNConnected() ) then
			ArenaLiveSpectatorWarGameMenu:UpdateNumPlayers();
			self:UnregisterEvent("PLAYER_ENTERING_WORLD");
		end
	elseif ( event == "PLAYER_TARGET_CHANGED" and self.enabled ) then
		local database = ArenaLive:GetDBComponent(addonName);
		if ( database.FollowTarget ) then
			--C_Commentator.FollowUnit("target");
			FollowUnit("target");
		end
		if ( database.HideTargetFrames or database.PlayMode > 3 ) then
			for i = 1, database.PlayMode do
				local frame = _G["ALSPEC_LeftSideFramesFrame"..i];
				ArenaLiveSpectator:UpdateSideFrameAppearance(frame);
				frame = _G["ALSPEC_RightSideFramesFrame"..i];
				ArenaLiveSpectator:UpdateSideFrameAppearance(frame);
			end
		end
	elseif ( event == "UI_SCALE_CHANGED" or event == "DISPLAY_SIZE_CHANGED" ) then
		local screenHeight = math.ceil(GetScreenHeight());
		local scale = 786 / screenHeight;
		ArenaLiveSpectatorTooltip:SetScale(scale);
		ArenaLiveSpectatorPlayerInfoFrame:SetScale(scale);
	elseif ( event == "UNIT_PET" or event == "UNIT_AURA" ) then
		ArenaLiveSpectatorMatchStatistic:OnEvent(event, ...);
	elseif ( event == "UPDATE_BATTLEFIELD_STATUS" ) then
		local status = GetBattlefieldStatus(filter);
		local winner = GetBattlefieldWinner();
		local isSpectator, gameType  = IsSpectator();
		
		--ArenaLive:Message("%s: GetBattlefieldWinner(): %s, status: %s, teamSize = %d, self:HasMatchStarted() = %s, ", "debug", event, tostring(winner), tostring(status), teamSize, tostring(ArenaLiveSpectator:HasMatchStarted()));
		
		-- Note: Since teamSize doesn't return
		-- the "correct" value in Wargames
		-- (i.e. 0 for BG and 2,3,5 for Arenas),
		-- I need to use ArenaLive's PlayMode value.		
		local database = ArenaLive:GetDBComponent(addonName);
		if ( status == "active" and filter == self.currentStatusID and winner ) then
			-- Update team scores according to winner:
			local database = ArenaLive:GetDBComponent(addonName);
			if ( ( not self.swapTeams and winner == 1 ) or ( self.swapTeams and winner == 0 ) ) then
				database.TeamA.Score = database.TeamA.Score + 1;
			elseif ( ( not self.swapTeams and winner == 0 ) or ( self.swapTeams and winner == 1 ) ) then
				database.TeamB.Score = database.TeamB.Score + 1;
			elseif ( winner == 255 ) then
				database.TeamA.Score = database.TeamA.Score + 1;
				database.TeamB.Score = database.TeamB.Score + 1;
			end
				
			ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamA");
			ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamB");
			ArenaLiveSpectatorWarGameMenuWarGamesLeftTeamScore:UpdateShownValue();
			ArenaLiveSpectatorWarGameMenuWarGamesRightTeamScore:UpdateShownValue();
				
			-- Stop Recording Match Statistic and Show it:
			ArenaLiveSpectatorMatchStatistic:Stop();
			ArenaLiveSpectatorMatchStatistic:Open(true);
		elseif ( status == "active" and isSpectator and gameType == "arena" ) then
			ArenaLiveSpectator:Enable(filter);
		elseif ( status == "active" and isSpectator and gameType == "battleground" and not IsAddOnLoaded("BGLive") ) then
				ArenaLive:Message(L["Joined a spectated battleground. Displaying a spectator UI in spectated battlegrounds requires BGLive."]);
		elseif ( status == "none" and filter == self.currentStatusID ) then
			ArenaLiveSpectator:Disable();
		end
	elseif ( event == "WORLD_STATE_UI_TIMER_UPDATE" ) then
		if ( not self.worldStateTimerIndex ) then
			for index = 1, GetNumWorldStateUI() do
				local uiType = GetWorldStateUIInfo(index);
				if ( uiType == 3 ) then -- 3 seems to be the identifier for timers.
					self.worldStateTimerIndex = index;
					break;
				end
			end
		end
			
		if ( self.worldStateTimerIndex ) then
			local uiType, state, _, text = GetWorldStateUIInfo(self.worldStateTimerIndex);
			local minutes, seconds = string.match(text,("([0-9]+):([0-9]+)$"));
				
			local minNum, secNum = tonumber(minutes), tonumber(seconds);
			if ( minNum + secNum > 0 and not self.hasStarted ) then
				self.hasStarted = true;
				ArenaLive:TriggerEvent("AL_SPEC_MATCH_START");
			end
			
			if ( ArenaLiveSpectatorScoreBoard.enabled ) then
				if ( state ) then
					ArenaLiveSpectatorScoreBoard:UpdateTimer(minutes, seconds)
				else
					ArenaLiveSpectatorScoreBoard:UpdateTimer("00", "00")
				end
			end
		end
	end
end

function ArenaLiveSpectator:UpdateDB()
	
	local database = ArenaLive:GetDBComponent(addonName);
	if ( not database.Version ) then
		database.version = nil;
		
		for frameGroup, frameGroupOptions in pairs(database) do
			if ( type(frameGroupOptions) == "table" ) then
				if ( type(frameGroupOptions.NameText) == "table" ) then
					database[frameGroup].NameText.Size = nil;
					database[frameGroup].NameText.FontObject = "ArenaLiveFont_Name";
				end
				
				if ( type(frameGroupOptions.HealthBarText) == "table" ) then
					database[frameGroup].HealthBarText.BarTextSize = nil;
					database[frameGroup].HealthBarText.FontObject = "ArenaLiveFont_StatusBarTextSmall";
				end
				
				if ( type(frameGroupOptions.PowerBarText) == "table" ) then
					database[frameGroup].PowerBarText.BarTextSize = nil;
					database[frameGroup].PowerBarText.FontObject = "ArenaLiveFont_StatusBarTextSmall";
				end
			end
		end
		
		database.Version = "3.0.0b";
	end

	if ( database.Version == "3.0.0b" or 
	database.Version == "3.1.0b" or
	database.Version == "3.1.1b" or
	database.Version == "3.1.2b" or
	database.Version == "3.1.3b" or 
	database.Version == "3.1.4b" or 
	database.Version == "3.1.5b" or 
	database.Version == "3.1.6b" or 
	database.Version == "3.1.7b" or 
	database.Version == "3.1.8b" ) then
		database.Version = "3.1.9b";
	end
	
	if ( database.Version == "3.1.9b" ) then
		-- Create empty table to remove
		-- old battleTag based entries:
		database.NicknameDatabase = {};
		database.Version = "3.1.10b";
	end
	
	if ( database.Version == "3.1.10b" ) then
		database.Left.CooldownTracker.MaxShownIcons = 6;
		database.Right.CooldownTracker.MaxShownIcons = 6;
		database.Version = "3.1.11b";
	end
	
	if ( database.Version == "3.1.11b" ) then
		database.TeamB.Colour = { 0.39, 0.71, 0, 1 }; -- Green team's colour will be more saturated this way.
		database.Version = "3.2.1b";
	end
	
	if ( database.Version == "3.2.1b" ) then
		database.Version = "3.2.2b";
	end
	
	if ( database.Version == "3.2.2b" ) then
		database.TeamB.Colour = { 0.03, 0.71, 0, 1 };
		database.Version = "3.2.3b";
	end

end

function ArenaLiveSpectatorHideUIButton:OnClick(button, down)
	if( button == "LeftButton" ) then
		UIParent:Hide();
	end
end

ArenaLive:ConstructAddon(ArenaLiveSpectator, addonName, true, ArenaLiveSpectator.defaults, false, "ALSPEC_Database");
ArenaLiveSpectator:RegisterEvent("AL_SPEC_PLAYER_UPDATE"); -- Custom Event triggered by UnitCache handler.
ArenaLiveSpectator:RegisterEvent("AL_SPEC_PLAYER_SPECIALIZATION_UPDATE"); -- Custom Event triggered by UnitCache handler.
ArenaLiveSpectator:RegisterEvent("AL_SPEC_MATCH_START"); -- Custom Event triggered by ArenaLiveSpectator:OnEvent() WORLD_STATE_UI_TIMER_UPDATE
ArenaLiveSpectator:RegisterEvent("ADDON_LOADED");
ArenaLiveSpectator:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED");
ArenaLiveSpectator:RegisterEvent("BN_FRIEND_TOON_ONLINE");
ArenaLiveSpectator:RegisterEvent("BN_TOON_NAME_UPDATED");
ArenaLiveSpectator:RegisterEvent("BN_FRIEND_TOON_OFFLINE");
ArenaLiveSpectator:RegisterEvent("CHAT_MSG_ADDON");
ArenaLiveSpectator:RegisterEvent("DISPLAY_SIZE_CHANGED");
ArenaLiveSpectator:RegisterEvent("PLAYER_ENTERING_WORLD");
ArenaLiveSpectator:RegisterEvent("UI_SCALE_CHANGED");
ArenaLiveSpectator:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");