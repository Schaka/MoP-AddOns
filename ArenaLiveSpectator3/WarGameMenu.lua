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

local WARGAME_MENU_PLAYER_BUTTON_HEIGHT = 32;
local panels = {
	{ name="ArenaLiveSpectatorWarGameMenuWarGames", tabTitle = L["Spectated War Games"] },
	{ name="ArenaLiveSpectatorWarGameMenuSettings", tabTitle = L["Settings"], },
	{ name="ArenaLiveSpectatorWarGameMenuNicknameDatabase", tabTitle = L["Nickname Database"], },
};

local function updateMapDropDown (playModeDD, newValue, oldValue)
	local database = ArenaLive:GetDBComponent(addonName);
	if ( not newValue ) then
		newValue = database.PlayMode;
	end
	
	local mapDD = _G["ArenaLiveSpectatorWarGameMenuWarGamesMapDropDown"];
	for i = 1, 20 do
		if ( ( newValue > 0 and i < 8 ) or ( newValue == 0 and i > 7 ) ) then
			mapDD.ignoreKey[i] = nil;
		else
			if ( database.Map == mapDD.info[i].value ) then
				database.Map = nil;
			end
			mapDD.ignoreKey[i] = true;
		end
	end
			
	mapDD:Refresh();
	mapDD:UpdateShownValue();
			
	if ( newValue > 0 ) then
		ArenaLiveSpectator:SetNumPlayers(newValue);
	end
end

local availablePlayerInfo = { count = 0 };
local CURRENT_CURSOR_SELECT;
local battleTagToFriendID = {};
local OPTION_ITEMS_SETTINGS = {
	["Map"] = {
		["type"] = "DropDownLargeTitle",
		["name"] = "ArenaLiveSpectatorWarGameMenuWarGamesMapDropDown",
		["parent"] = "ArenaLiveSpectatorWarGameMenuWarGames",
		["width"] = 150,
		["point"] = "TOPRIGHT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuWarGames",
		["relativePoint"] = "TOPRIGHT",
		["xOffset"] = 5,
		["yOffset"] = 0,
		["title"] = L["Map:"],
		["tooltip"] = L["Choose the map the war game will take place on."],
		["emptyText"] = L["All Arenas"],
		["infoTable"] = {
			[1] = {
				["text"] = L["Blade's Edge Arena"],
				["value"] = L["Blade's Edge Arena"],
			},
			[2] = {
				["text"] = L["Dalaran Sewers"],
				["value"] = L["Dalaran Sewers"],
			},
			[3] = {
				["text"] = L["Nagrand Arena"],
				["value"] = L["Nagrand Arena"],
			},
			[4] = {
				["text"] = L["Ruins of Lordaeron"],
				["value"] = L["Ruins of Lordaeron"],
			},
			[5] = {
				["text"] = L["The Tiger's Peak"],
				["value"] = L["The Tiger's Peak"],
			},
			[6] = {
				["text"] = L["Tol'Viron Arena"],
				["value"] = L["Tol'Viron Arena"],
			},
			[7] = {
				["text"] = L["All Arenas"],
				["value"] = nil,
			},
			[8] = {
				["text"] = L["Alterac Valley"],
				["value"] = L["Alterac Valley"],
			},
			[9] = {
				["text"] = L["Warsong Gulch"],
				["value"] = L["Warsong Gulch"],
			},
			[10] = {
				["text"] = L["Twin Peaks"],
				["value"] = L["Twin Peaks"],
			},
			[11] = {
				["text"] = L["The Battle for Gilneas"],
				["value"] = L["The Battle for Gilneas"],
			},
			[12] = {
				["text"] = L["Temple of Kotmogu"],
				["value"] = L["Temple of Kotmogu"],
			},
			[13] = {
				["text"] = L["Silvershard Mines"],
				["value"] = L["Silvershard Mines"],
			},
			[14] = {
				["text"] = L["Arathi Basin"],
				["value"] = L["Arathi Basin"],
			},
			[15] = {
				["text"] = L["Eye of the Storm"],
				["value"] = "rated",
			},
			[16] = {
				["text"] = L["Strand of the Ancients"],
				["value"] = L["Strand of the Ancients"],
			},
			[17] = {
				["text"] = L["Isle of Conquest"],
				["value"] = L["Isle of Conquest"],
			},
			[18] = {
				["text"] = L["Deepwind Gorge"],
				["value"] = L["Deepwind Gorge"],
			},
			[19] = {
				["text"] = L["Southshore vs Tarren Mill"],
				["value"] = L["Southshore vs Tarren Mill"],
			},
			[20] = {
				["text"] = L["Random Battleground"],
				["value"] = nil,
			},
		},
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon); return database.Map; end,
		["SetDBValue"] = function (frame, newValue) if ( newValue == L["All Arenas"] ) then newValue = nil; end local database = ArenaLive:GetDBComponent(frame.addon); database.Map = newValue; end,
	},
	["PlayMode"] = {
		["type"] = "DropDownLargeTitle",
		["name"] = "ArenaLiveSpectatorWarGameMenuWarGamesPlayModeDropDown",
		["parent"] = "ArenaLiveSpectatorWarGameMenuWarGames",
		["width"] = 100,
		["point"] = "TOPLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuWarGames",
		["relativePoint"] = "TOPLEFT",
		["xOffset"] = 243,
		["yOffset"] = 0,
		["title"] = L["Bracket:"],
		["tooltip"] = L["Choose the number of players per team."],
		["infoTable"] = {
			[1] = {
				["text"] = L["Battleground"],
				["value"] = 0,
			},
			[2] = {
				["text"] = L["2v2"],
				["value"] = 2,
			},
			[3] = {
				["text"] = L["3v3"],
				["value"] = 3,
			},
			[4] = {
				["text"] = L["5v5"],
				["value"] = 5,
			},
		},
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon); return database.PlayMode; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon); database.PlayMode = newValue; end,
		["postUpdate"] = updateMapDropDown,
	},
	["TournamentRules"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuWarGamesTournamentRulesCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuWarGames",
		["point"] = "BOTTOMLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuWarGames",
		["relativePoint"] = "BOTTOMLEFT",
		["xOffset"] = 180,
		["yOffset"] = 2,
		["title"] = L["Tournament Rules"],
		["tooltip"] = L["If checked, participants will only be allowed to use Tournament Gear. Other equipment will be disabled."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon); return database.TournamentRules; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon); database.TournamentRules = newValue; end,
	},
	["LeftTeamName"] = {
		["type"] = "EditBox",
		["name"] = "ArenaLiveSpectatorWarGameMenuWarGamesLeftTeamName",
		["parent"] = "ArenaLiveSpectatorWarGameMenuWarGames",
		["width"] = 182,
		["height"] = 24,
		["point"] = "TOPLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuWarGames",
		["relativePoint"] = "TOPLEFT",
		["xOffset"] = 198,
		["yOffset"] = -50,
		["maxLetters"] = 19,
		["title"] = L["Team Name:"],
		["tooltip"] = L["Enter the name of the team. The name will be shown on the scoreboard and on the match statistic."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, nil, frame.group); return database.Name; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, nil, frame.group); database.Name = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue)
			ArenaLiveSpectatorScoreBoard:UpdateTeamName("TeamA");
		
			if ( IsAddOnLoaded("BGLive") ) then
				BGLiveScoreBoard:UpdateTeamName("TeamA");
			end		
		end,
	},
	["RightTeamName"] = {
		["type"] = "EditBox",
		["name"] = "ArenaLiveSpectatorWarGameMenuWarGamesRightTeamName",
		["parent"] = "ArenaLiveSpectatorWarGameMenuWarGames",
		["width"] = 182,
		["height"] = 24,
		["point"] = "TOPRIGHT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuWarGames",
		["relativePoint"] = "TOPRIGHT",
		["xOffset"] = -20,
		["yOffset"] = -50,
		["maxLetters"] = 19,
		["title"] = L["Team Name:"],
		["tooltip"] = L["Enter the name of the team. The name will be shown on the scoreboard and on the match statistic."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, nil, frame.group); return database.Name; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, nil, frame.group); database.Name = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue)
			ArenaLiveSpectatorScoreBoard:UpdateTeamName("TeamB");

			if ( IsAddOnLoaded("BGLive") ) then
				BGLiveScoreBoard:UpdateTeamName("TeamB");
			end			
		end,
	},
	["LeftTeamScore"] = {
		["type"] = "EditBox",
		["name"] = "ArenaLiveSpectatorWarGameMenuWarGamesLeftTeamScore",
		["parent"] = "ArenaLiveSpectatorWarGameMenuWarGames",
		["width"] = 40,
		["height"] = 24,
		["point"] = "TOPLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuWarGamesLeftTeamName",
		["relativePoint"] = "TOPRIGHT",
		["xOffset"] = 5,
		["yOffset"] = 0,
		["inputType"] = "NUMERIC",
		["maxLetters"] = 3,
		["title"] = L["Score:"],
		["tooltip"] = L["Enter the score of the team. It will be shown on the scoreboard."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, nil, frame.group); return database.Score; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, nil, frame.group); database.Score = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue)
			ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamA");
			
			if ( IsAddOnLoaded("BGLive") ) then
				BGLiveScoreBoard:UpdateTeamScore("TeamA");
			end
		end,
	},
	["RightTeamScore"] = {
		["type"] = "EditBox",
		["name"] = "ArenaLiveSpectatorWarGameMenuWarGamesRightTeamScore",
		["parent"] = "ArenaLiveSpectatorWarGameMenuWarGames",
		["width"] = 40,
		["height"] = 24,
		["point"] = "TOPRIGHT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuWarGamesRightTeamName",
		["relativePoint"] = "TOPLEFT",
		["xOffset"] = -5,
		["yOffset"] = 0,
		["inputType"] = "NUMERIC",
		["maxLetters"] = 3,
		["title"] = L["Score:"],
		["tooltip"] = L["Enter the score of the team. It will be shown on the scoreboard."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, nil, frame.group); return database.Score; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, nil, frame.group); database.Score = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue)
			ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamB");
			
			if ( IsAddOnLoaded("BGLive") ) then
				BGLiveScoreBoard:UpdateTeamScore("TeamB");
			end
		end,
	},
	["Broadcast"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsBroadcastCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "TOPLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsGeneralTitle",
		["relativePoint"] = "BOTTOMLEFT",
		["xOffset"] = 5,
		["yOffset"] = -5,
		["title"] = L["Broadcast Team Data"],
		["tooltip"] = L["If checked, team names and scores will be broadcast to the spectator group, when queuing for a war game."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon); return database.Broadcast; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon); database.Broadcast = newValue; end,
	},
	["ShowScoreBoard"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsShowScoreBoardCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "LEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsBroadcastCheckButtonText",
		["relativePoint"] = "RIGHT",
		["xOffset"] = 10,
		["yOffset"] = -2,
		["title"] = L["Enable Scoreboard"],
		["tooltip"] = L["If checked, a scoreboard with match timer, team name, team score and dampening tracker will be shown during matches."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon); return database.ShowScoreBoard; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon); database.ShowScoreBoard = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue) ArenaLiveSpectatorScoreBoard:Toggle(); end
	},
	["FollowTarget"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsFollowTargetCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "LEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsShowScoreBoardCheckButtonText",
		["relativePoint"] = "RIGHT",
		["xOffset"] = 10,
		["yOffset"] = -2,
		["title"] = L["Follow Target"],
		["tooltip"] = L["If checked, ArenaLive will fixate the camera on your current target. Note: When following a player, nameplates are disabled by the WoW client."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon); return database.FollowTarget; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon); database.FollowTarget = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue) if ( newValue ) then C_Commentator.FollowUnit("target"); else C_Commentator.FollowUnit(); end end,
	},
	["TournamentIcon"] = {
		["type"] = "EditBox",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsTournamentIconEditBox",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["width"] = 150,
		["height"] = 24,
		["point"] = "TOPLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsBroadcastCheckButton",
		["relativePoint"] = "BOTTOMLEFT",
		["xOffset"] = 3,
		["yOffset"] = -15,
		["title"] = L["SET_CUSTOM_TOURNAMENT_ICON_TITLE"],
		["tooltip"] = L["SET_CUSTOM_TOURNAMENT_ICON_TOOLTIP"],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.TournamentIcon; end,
		["SetDBValue"] = function (frame, newValue) if ( newValue == "" ) then newValue = nil; end local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.TournamentIcon = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue) ArenaLiveSpectatorScoreBoardDampeningIndicator:UpdateTournamentIcon(); end,
	},
	["DisableTargetFrames"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsDisableTargetFramesCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "TOPLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsTargetFramesTitle",
		["relativePoint"] = "BOTTOMLEFT",
		["xOffset"] = 5,
		["yOffset"] = -5,
		["title"] = L["Disable"],
		["tooltip"] = L["If checked, target and target-of-target frames will be disabled and the width of the current target's side frame will be increased dynamically instead."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon); return database.HideTargetFrames; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon); database.HideTargetFrames = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValues) local database = ArenaLive:GetDBComponent(frame.addon); ArenaLiveSpectator:SetNumPlayers(database.PlayMode); end,
	},
	["EnableTargetFrameCastBar"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsEnableTargetFrameCastBarCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "LEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsDisableTargetFramesCheckButtonText",
		["relativePoint"] = "RIGHT",
		["xOffset"] = 5,
		["yOffset"] = -2,
		["title"] = L["Enable Castbar"],
		["postUpdate"] = function (frame, newValue, oldValues) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, "TargetTargetFrame"); database.Enabled = newValue; ArenaLiveSpectator:UpdateTargetFrameConstituents(ALSPEC_TargetFrame); ArenaLiveSpectator:UpdateTargetFrameConstituents(ALSPEC_TargetTargetFrame); end,
	},
	["EnableTargetFrameCastHistory"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsEnableTargetFrameCastHistoryCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "LEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsEnableTargetFrameCastBarCheckButtonText",
		["relativePoint"] = "RIGHT",
		["xOffset"] = 5,
		["yOffset"] = -2,
		["title"] = L["Enable Casthistory"],
		["postUpdate"] = function (frame, newValue, oldValues) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, "TargetTargetFrame"); database.Enabled = newValue; ArenaLiveSpectator:UpdateTargetFrameConstituents(ALSPEC_TargetFrame); ArenaLiveSpectator:UpdateTargetFrameConstituents(ALSPEC_TargetTargetFrame); end,
	},
	["EnableSideFrameCastBar"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsEnableSideFrameCastBarCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "TOPLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsSideFramesTitle",
		["relativePoint"] = "BOTTOMLEFT",
		["xOffset"] = 5,
		["yOffset"] = -5,
		["title"] = L["Enable Castbar"],
		["postUpdate"] = function (frame, newValue, oldValues) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, "Right"); database.Enabled = newValue; ArenaLiveSpectator:UpdateAllSideFrameConstituents() end,
	},
	["EnableSideFrameCastHistory"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsEnableSideFrameCastHistoryCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "LEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsEnableSideFrameCastBarCheckButtonText",
		["relativePoint"] = "RIGHT",
		["xOffset"] = 5,
		["yOffset"] = -2,
		["title"] = L["Enable Casthistory"],
		["postUpdate"] = function (frame, newValue, oldValues) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, "Right"); database.Enabled = newValue; ArenaLiveSpectator:UpdateAllSideFrameConstituents() end,
	},
	["ShowCDTrackerTooltip"] = {
		["type"] = "CheckButton",
		["name"] = "ArenaLiveSpectatorWarGameMenuSettingsShowCDTrackerTooltipCheckButton",
		["parent"] = "ArenaLiveSpectatorWarGameMenuSettings",
		["point"] = "TOPLEFT",
		["relativeTo"] = "ArenaLiveSpectatorWarGameMenuSettingsCooldownTrackerTitle",
		["relativePoint"] = "BOTTOMLEFT",
		["xOffset"] = 5,
		["yOffset"] = -5,
		["title"] = L["Show Tooltip"],
		["tooltip"] = L["If enabled, spell tooltips will be shown when moving the mouse over a cooldown button."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.ShowTooltip; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.ShowTooltip = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValues) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, "Right"); database.ShowTooltip = newValue; end,
	},
};

function ArenaLiveSpectatorWarGameMenu:Initialise()
	local database = ArenaLive:GetDBComponent(addonName);
	
	-- Setup frame appearance:
	ArenaLiveSpectatorWarGameMenuTitleText:SetText(string.format(L["ArenaLive [Spectator] %s"], database.Version));
	self.portrait:SetTexture("Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\WarGameMenuPortrait");
	
	-- Setup drop down menus:
	local frame = ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["Map"], addonName);
	frame.ignoreKey = {};
	frame = ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["PlayMode"], addonName);
	updateMapDropDown(frame);
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["TournamentRules"], addonName);
	
	-- Setup player (friend) list:
	self.warGames.playerScrollFrame.scrollBar.doNotHide = true;
	HybridScrollFrame_CreateButtons(self.warGames.playerScrollFrame, "ArenaLiveSpectatorWarGamePlayerButtonTemplate", 0, -2);
	
	-- Setup Team Name Editboxes:
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["LeftTeamName"], addonName, nil, "TeamA");
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["RightTeamName"], addonName, nil, "TeamB");
		ArenaLiveSpectatorWarGameMenuWarGamesRightTeamNameTitle:ClearAllPoints();
		ArenaLiveSpectatorWarGameMenuWarGamesRightTeamNameTitle:SetPoint("BOTTOMRIGHT", ArenaLiveSpectatorWarGameMenuRightTeamName, "TOPRIGHT", -5, 0);
		ArenaLiveSpectatorWarGameMenuWarGamesRightTeamName:SetJustifyH("RIGHT");

	-- Setup Score Editboxes:
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["LeftTeamScore"], addonName, nil, "TeamA");
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["RightTeamScore"], addonName, nil, "TeamB");
	
	-- Setup Team Leader Buttons:
	self:InitialiseTeamLeaderButton(ArenaLiveSpectatorWarGameMenuWarGamesLeftLeaderButton, "TeamA");
	self:InitialiseTeamLeaderButton(ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButton, "TeamB");
	
		-- Update appearance of right leader button to mirror the left one:
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonButtonBackground:ClearAllPoints();
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonButtonBackground:SetPoint("RIGHT", 0, -4);
		
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonBackground:ClearAllPoints();
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonBackground:SetPoint("TOPRIGHT", -48, -17);	
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonBackground:SetPoint("BOTTOMLEFT", 0, 9);	
		
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonIcon:ClearAllPoints();
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonIcon:SetPoint("TOPRIGHT", -10, -17);
		
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonTitle:ClearAllPoints();
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonTitle:SetPoint("TOPRIGHT", -10, 0);
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonTitle:SetJustifyH("RIGHT");
		
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonName:ClearAllPoints();
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonName:SetPoint("TOPRIGHT", ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonIcon, "TOPLEFT", -5, -5);
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonName:SetJustifyH("RIGHT");
		
		ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButtonInfo:SetJustifyH("RIGHT");
	
	-- Setup Start Wargame Button:
	ArenaLiveSpectatorWarGameMenu:InitialiseButton(self.warGames.startButton, L["Start Spectated War Game"]);
	
	-- Setup General Option Frames:
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["Broadcast"], addonName);
	ArenaLiveSpectatorWarGameMenuSettingsBroadcastCheckButtonText:SetTextColor(1,1,1);
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["ShowScoreBoard"], addonName);
	ArenaLiveSpectatorWarGameMenuSettingsShowScoreBoardCheckButtonText:SetTextColor(1,1,1);
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["FollowTarget"], addonName);
	ArenaLiveSpectatorWarGameMenuSettingsFollowTargetCheckButtonText:SetTextColor(1,1,1);	
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["TournamentIcon"], addonName);
	
	-- Setup Target Frames' Option Frames:
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["DisableTargetFrames"], addonName);
	ArenaLiveSpectatorWarGameMenuSettingsDisableTargetFramesCheckButtonText:SetTextColor(1,1,1);	
	ArenaLive:ConstructOptionFrameByHandler(OPTION_ITEMS_SETTINGS["EnableTargetFrameCastBar"], addonName, "CastBar", "Enable", "TargetFrame");
	ArenaLiveSpectatorWarGameMenuSettingsEnableTargetFrameCastBarCheckButtonText:SetTextColor(1,1,1);
	ArenaLive:ConstructOptionFrameByHandler(OPTION_ITEMS_SETTINGS["EnableTargetFrameCastHistory"], addonName, "CastHistory", "Enable", "TargetFrame");
	ArenaLiveSpectatorWarGameMenuSettingsEnableTargetFrameCastHistoryCheckButtonText:SetTextColor(1,1,1);	
	
	-- Setup Side Frames'  Option Frames:
	ArenaLive:ConstructOptionFrameByHandler(OPTION_ITEMS_SETTINGS["EnableSideFrameCastBar"], addonName, "CastBar", "Enable", "TargetFrame");
	ArenaLiveSpectatorWarGameMenuSettingsEnableSideFrameCastBarCheckButtonText:SetTextColor(1,1,1);
	ArenaLive:ConstructOptionFrameByHandler(OPTION_ITEMS_SETTINGS["EnableSideFrameCastHistory"], addonName, "CastHistory", "Enable", "TargetFrame");
	ArenaLiveSpectatorWarGameMenuSettingsEnableSideFrameCastHistoryCheckButtonText:SetTextColor(1,1,1);
	
	-- Setup Cooldown Tracker Option Frames:
	ArenaLive:ConstructOptionFrame(OPTION_ITEMS_SETTINGS["ShowCDTrackerTooltip"], addonName, "CooldownTracker", "Left");
	ArenaLiveSpectatorWarGameMenuSettingsShowCDTrackerTooltipCheckButtonText:SetTextColor(1,1,1);
	
	-- Setup tabs:
	PanelTemplates_SetNumTabs(self, #panels);
	self.maxTabWidth = (self:GetWidth() - 19) / #panels;
	for index, data in ipairs(panels) do
		local tab = self["tab"..index];
		tab:SetText(data.tabTitle);
		tab:SetScript("OnClick", self.TabOnClick);
	end
	
	-- Set Scripts:
	self:RegisterForClicks("LeftButtonUp");
	self:SetScript("OnShow", self.OnShow);
	self:SetScript("OnHide", self.OnHide);
	self:SetScript("OnClick", self.OnClick);
	ArenaLiveSpectatorWarGamePlayerCursorButton:SetScript("OnUpdate", ArenaLiveSpectatorWarGamePlayerCursorButton.OnUpdate);
end

function ArenaLiveSpectatorWarGameMenu:InitialiseButton(button, text, onClick)
	button:SetText(text);
	
	local prefix = button:GetName();
	local buttonText = _G[prefix.."Text"];
	if ( buttonText ) then
		local width = buttonText:GetWidth() + 40;
		button:SetWidth(width);
	end
	
	button:RegisterForClicks("LeftButtonUp");
	button:SetScript("OnClick", onClick or button.OnClick);
end

function ArenaLiveSpectatorWarGameMenu:OnShow()

	-- Close Match Statistic:
	if ( ArenaLiveSpectatorMatchStatistic:IsShown() ) then
		ArenaLiveSpectatorMatchStatistic:Hide();
	end

	PlaySound("igCharacterInfoOpen");
	self:BNFriendEvent();
	self:ShowTab();
end

function ArenaLiveSpectatorWarGameMenu:OnHide()
	PlaySound("igCharacterInfoClose");
end

function ArenaLiveSpectatorWarGameMenu:OnClick(button, down)
	if ( CURRENT_CURSOR_SELECT ) then
		ArenaLiveSpectatorWarGamePlayerCursorButton:Reset();
	end
end

function ArenaLiveSpectatorWarGameMenu:BNFriendEvent()
	if ( self:IsShown() ) then
		self:UpdateNumPlayers();
		self:UpdateTeamLeaderButton(self.warGames.teamInset.leftLeaderButton);
		self:UpdateTeamLeaderButton(self.warGames.teamInset.rightLeaderButton);
	end
end

function ArenaLiveSpectatorWarGameMenu:UpdateNumPlayers()
	local totalFriends, onlineFriends = BNGetNumFriends();
	local numPlayers = 0;

	for i = 1, totalFriends do
		local presenceID, presenceName, battleTag, isBattleTagPresence, _, toonID, client, isOnline = BNGetFriendInfo(i);
		local clientTexture = BNet_GetClientTexture(client);
		if ( battleTag ) then
			local name, realm, infoText;
			if ( toonID ) then
				_, name, _, realm = BNGetToonInfo(toonID);
				if ( client == BNET_CLIENT_WOW ) then
					infoText = name.."-"..realm;
				else
					infoText = name;
				end
			elseif ( not isOnline ) then
				infoText = L["Offline"];
				clientTexture = "Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\Battlenet-Offlineicon";
			end
			
			numPlayers = numPlayers + 1;
				
			if ( not availablePlayerInfo[numPlayers] ) then
				availablePlayerInfo[numPlayers] = {};
			end

			availablePlayerInfo[numPlayers].presenceID = presenceID;
			availablePlayerInfo[numPlayers].name = presenceName;
			availablePlayerInfo[numPlayers].battleTag = battleTag;
			availablePlayerInfo[numPlayers].infoText = infoText;
			availablePlayerInfo[numPlayers].toonID = toonID;
			availablePlayerInfo[numPlayers].client = client;
			availablePlayerInfo[numPlayers].clientTexture = clientTexture;
			availablePlayerInfo[numPlayers].isOnline = isOnline;	
			battleTagToFriendID[battleTag] = numPlayers;
		end
	end
	
	availablePlayerInfo.count = numPlayers;
	self.warGames.playerScrollFrame:update();
end

function ArenaLiveSpectatorWarGameMenu:GetPlayerDataByBattleTag(battleTag)
	local id = battleTagToFriendID[battleTag];
	if ( id and availablePlayerInfo[id] ) then
		return 	availablePlayerInfo[id].presenceID, 
				availablePlayerInfo[id].name,
				availablePlayerInfo[id].battleTag, 
				availablePlayerInfo[id].infoText,
				availablePlayerInfo[id].toonID,
				availablePlayerInfo[id].client,
				availablePlayerInfo[id].clientTexture,
				availablePlayerInfo[id].isOnline;
	else
		return nil;
	end
end

function ArenaLiveSpectatorWarGameMenu:GetPlayerDataByID(id)
	if ( availablePlayerInfo[id] ) then
		return 	availablePlayerInfo[id].presenceID, 
				availablePlayerInfo[id].name,
				availablePlayerInfo[id].battleTag, 
				availablePlayerInfo[id].infoText,
				availablePlayerInfo[id].toonID,
				availablePlayerInfo[id].client,
				availablePlayerInfo[id].clientTexture,
				availablePlayerInfo[id].isOnline;
	else
		return nil;
	end
end



--[[
		TAB HANDLING:
]]--
function ArenaLiveSpectatorWarGameMenu:ShowTab(tabName)

	local tabIndex;
	if ( tabName ) then
		for index, data in pairs(panels) do
			if ( data.name == tabName ) then
				tabIndex = index;
				break;
			end
		end
	else
		-- no side panel specified, check current panel
		if ( self.activeTabIndex ) then
			tabIndex = self.activeTabIndex;
		else
			-- no current panel, go to the first panel
			tabIndex = 1;
		end
	end	
	if ( not tabIndex ) then
		return;
	end

	-- show it
	self.activeTabIndex = tabIndex;	
	PanelTemplates_SetTab(self, tabIndex);
	for index, data in pairs(panels) do
		local panel = _G[data.name];
		if ( index == tabIndex ) then
			panel:Show();
			local height = panel:GetHeight();
			height = height + 70;
			self:SetHeight(height);
		elseif ( panel ) then
			panel:Hide();
		end
	end
	
	-- Update player scroll frame to show info text depending on open tab:
	self.warGames.playerScrollFrame:update();
end

function ArenaLiveSpectatorWarGameMenu.TabOnClick(tab)
	
	local self = ArenaLiveSpectatorWarGameMenu;
	PlaySound("igCharacterInfoTab");
	local tabName = panels[tab:GetID()].name;
	self:ShowTab(tabName);
end

--[[
		SELECTED PLAYER CURSOR BUTTON:
]]--
function ArenaLiveSpectatorWarGamePlayerCursorButton:SetPlayer(battleTag)

	local presenceID, presenceName, _, infoText, _, client, clientTexture, isOnline = ArenaLiveSpectatorWarGameMenu:GetPlayerDataByBattleTag(battleTag);
	if ( presenceID ) then
		self.name:SetText(presenceName);
		self.gameIcon:SetTexture(clientTexture);

		if ( client ~= BNET_CLIENT_WOW and isOnline ) then
			self.info:SetText(L["Not logged into WoW"]);
		end
		
		self.info:SetText(infoText);
		
		CURRENT_CURSOR_SELECT = battleTag;
		self:EnableMouse(false);
		
		PlaySound("INTERFACESOUND_CURSORGRABOBJECT");
		self:Show();
	end
end

function ArenaLiveSpectatorWarGamePlayerCursorButton:Reset()
	CURRENT_CURSOR_SELECT = nil;
	PlaySound("INTERFACESOUND_CURSORDROPOBJECT");
	self:Hide();
end

function ArenaLiveSpectatorWarGamePlayerCursorButton:OnUpdate(elapsed)
	if ( CURRENT_CURSOR_SELECT ) then
		local scale = UIParent:GetEffectiveScale();
		local x, y = GetCursorPosition();
		self:ClearAllPoints();
		self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x/scale, y/scale);
	else
		self:Hide();
	end
end



--[[
		PLAYER SCROLL FRAME
]]--
function ArenaLiveSpectatorWarGameMenuWarGamesPlayerScrollFrame:update()
	if ( ArenaLiveSpectatorWarGameMenu:IsShown() ) then
		local buttons = self.buttons;
		local offset = HybridScrollFrame_GetOffset(self);
		local numButtons = #buttons;
		local numPlayers = availablePlayerInfo.count;
		
		local _, button, index,  name, realm;
		for i = 1, numButtons do
			button = buttons[i];
			index = offset + i;
			if ( index <= numPlayers ) then
				local presenceID, presenceName, battleTag, infoText, toonID, client, clientTexture, isOnline = ArenaLiveSpectatorWarGameMenu:GetPlayerDataByID(index);
				button.battleTag = battleTag;
				button.name:SetText(presenceName);
				button.info:SetText(infoText);
				button.gameIcon:SetTexture(clientTexture);
				if ( isOnline ) then
					button.background:SetTexture(0, 0.694, 0.941, 0.05);
				else
					button.background:SetTexture(0.5, 0.5, 0.5, 0.05);
				end
			else
				button:Hide();
			end
		end
		
		local totalHeight = numPlayers * WARGAME_MENU_PLAYER_BUTTON_HEIGHT;
		HybridScrollFrame_Update(self, totalHeight, self:GetHeight());
	end
end



--[[
		TEAM LEADER BUTTON
]]--
local function TeamLeaderButton_OnDragStart(teamButton)
	local database = ArenaLive:GetDBComponent(addonName, nil, teamButton.group);
	if ( database.Leader and database.Leader ~= "" ) then
		local database = ArenaLive:GetDBComponent(addonName, nil, teamButton.group);
		ArenaLiveSpectatorWarGamePlayerCursorButton:SetPlayer(database.Leader);
		database.Leader = nil;
		ArenaLiveSpectatorWarGameMenu:UpdateTeamLeaderButton(teamButton);
	end
end

local function TeamLeaderButton_OnClick(teamButton, button, down)	
	if ( CURRENT_CURSOR_SELECT ) then
		local database = ArenaLive:GetDBComponent(addonName, nil, teamButton.group);
		database.Leader = CURRENT_CURSOR_SELECT;
		ArenaLiveSpectatorWarGamePlayerCursorButton:Reset();
		ArenaLiveSpectatorWarGameMenu:UpdateTeamLeaderButton(teamButton);
	end
end

function ArenaLiveSpectatorWarGameMenu:InitialiseTeamLeaderButton(button, group)
	button.group = group;
	button.title:SetText(L["Team Leader:"]);
	button:RegisterForDrag("LeftButton");
	button:RegisterForClicks("LeftButtonUp");
	button:SetScript("OnClick", TeamLeaderButton_OnClick);
	button:SetScript("OnReceiveDrag", TeamLeaderButton_OnClick);
	button:SetScript("OnDragStart", TeamLeaderButton_OnDragStart);
end

function ArenaLiveSpectatorWarGameMenu:UpdateTeamLeaderButton(button)
	local database = ArenaLive:GetDBComponent(addonName, nil, button.group);
	local leader = database.Leader or "";

	if ( leader == "" ) then
		-- No leader chosen:
		button.presenceID = nil;
		button.name:SetText(L["Choose a Player"]);
		button.name:SetTextColor(1, 0, 0, 1);
		button.info:SetText(L["Drag from the player list"]);
		button.icon:SetTexture();
		button.background:SetTexture(1, 0, 0, 0.05);
	else

		local presenceID, presenceName, battleTag, infoText, toonID, client, clientTexture, isOnline = ArenaLiveSpectatorWarGameMenu:GetPlayerDataByBattleTag(leader);
		if ( presenceID ) then
			button.name:SetText(presenceName);
			button.icon:SetTexture(clientTexture);
			button.info:SetText(infoText);
			
			if ( client == BNET_CLIENT_WOW ) then
				button.toonID = toonID;
				button.background:SetTexture(0, 1, 0, 0.05);
				button.name:SetTextColor(0, 1, 0, 1);
			else
				button.toonID = nil;
				button.background:SetTexture(1, 0, 0, 0.05);
				button.name:SetTextColor(1, 0, 0, 1);
				
				if ( isOnline ) then
					button.info:SetText(L["Not logged into WoW"]);
				end
			end
		end
	end
	
	self.warGames.startButton:Toggle();
end



--[[
		START WARGAME BUTTON (AAAAWWW YEEEEAAAH!)
]]--
function ArenaLiveSpectatorWarGameMenuWarGamesStartButton:Toggle()
	local database = ArenaLive:GetDBComponent(addonName);
	local leader1, leader2, bracket, map, tournamentRules;
	leader1 = ArenaLiveSpectatorWarGameMenuWarGamesLeftLeaderButton.toonID;
	leader2 = ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButton.toonID;
	bracket = database.PlayMode;
	map = database.Map;
	tournamentRules = ValueToBoolean(database.TournamentRules);
	
	if ( not leader1 or not leader2 or leader1 == leader2 ) then
		self:Disable();
	else
		self:Enable();
	end
	
end

function ArenaLiveSpectatorWarGameMenuWarGamesStartButton:OnClick(button, down)
	local database = ArenaLive:GetDBComponent(addonName);
	local leader1, leader2, bracket, map, tournamentRules;
	leader1 = ArenaLiveSpectatorWarGameMenuWarGamesLeftLeaderButton.toonID;
	leader2 = ArenaLiveSpectatorWarGameMenuWarGamesRightLeaderButton.toonID;
	bracket = database.PlayMode;
	map = database.Map;
	tournamentRules = ValueToBoolean(database.TournamentRules);
	
	if ( leader1 and leader2 and bracket ) then
		ArenaLive:Message("Calling StartSpectatorWarGame(): leader1 = %s, leader2 = %s, bracket = %d, map = %s, tournamentRules = %s", "debug", tostring(leader1), tostring(leader2), bracket, tostring(map), tostring(tournamentRules));
		StartSpectatorWarGame(leader1, leader2, bracket, map, tournamentRules);
			
		-- Broadcast team data to raid, if broadcasting is enabled:
		if ( database.Broadcast and UnitIsGroupLeader("player") ) then
			local leftTeamName, leftTeamScore, rightTeamName, rightTeamScore = database.TeamA.Name, tostring(database.TeamA.Score), database.TeamB.Name, tostring(database.TeamB.Score);
			local msg = "TEAM_UPDATE;"..leftTeamName..";"..leftTeamScore..";"..rightTeamName..";"..rightTeamScore..";"..bracket;
			ArenaLive:Message("Sending team data to raid...", "debug");
			SendAddonMessage("ALSPEC", msg, "RAID");
		end
	else
		ArenaLive:Message(L["Unable to queue spectated wargame, because either team leader's or bracket number wasn't found."]);
	end
end