local addonName, L = ...;

-- Key Bindings:
_G["BINDING_HEADER_ARENALIVESPECTATOR_TARGETING_MACROS"] = "Targeting";

_G["BINDING_NAME_CLICK ALSPEC_LeftSideFramesFrame1:LeftButton"] = "Target First Left Team Member";
_G["BINDING_NAME_CLICK ALSPEC_LeftSideFramesFrame2:LeftButton"] = "Target Second Left Team Member";
_G["BINDING_NAME_CLICK ALSPEC_LeftSideFramesFrame3:LeftButton"] = "Target Third Left Team Member";
_G["BINDING_NAME_CLICK ALSPEC_LeftSideFramesFrame4:LeftButton"] = "Target Fourth Left Team Member";
_G["BINDING_NAME_CLICK ALSPEC_LeftSideFramesFrame5:LeftButton"] = "Target Fifth Left Team Member";

_G["BINDING_NAME_CLICK ALSPEC_RightSideFramesFrame1:LeftButton"] = "Target First Right Team Member";
_G["BINDING_NAME_CLICK ALSPEC_RightSideFramesFrame2:LeftButton"] = "Target Second Right Team Member";
_G["BINDING_NAME_CLICK ALSPEC_RightSideFramesFrame3:LeftButton"] = "Target Third Right Team Member";
_G["BINDING_NAME_CLICK ALSPEC_RightSideFramesFrame4:LeftButton"] = "Target Fourth Right Team Member";
_G["BINDING_NAME_CLICK ALSPEC_RightSideFramesFrame5:LeftButton"] = "Target Fifth Right Team Member";

L["ArenaLive [Spectator] %s"] = "ArenaLive [Spectator] %s";

L["Hide normal UI"] = "Hide normal UI";

L["%s: Usage %s"] = "%s: Usage %s";

L["ArenaLiveSpectator.UnitCache:GetNumPlayers(): teamID too low or too high. Value must be 1 or 2."] = "ArenaLiveSpectator.UnitCache:GetNumPlayers(): teamID too low or too high. Value must be 1 or 2.";

L["Spectator addon has been loaded successfully! Type /alspec to open the spectator war game menu or /alspec help for a list of available commands."] = "Spectator addon has been loaded successfully! Type /alspec to open the spectator war game menu or /alspec help for a list of available commands.";
L["Joined a spectated battleground. Displaying a spectator UI in spectated battlegrounds requires BGLive."] = "Joined a spectated battleground. Displaying a spectator UI in spectated battlegrounds requires BGLive.";

L["Available Slash Commands for ArenaLive [Spectator] are:"] = "Available Slash Commands for ArenaLive [Spectator] are:";
L["Shows this info message."] = "Shows this info message.";
L["Shows the War Game Menu"] = "Shows the War Game Menu";
L["Shows the Match Statistic"] = "Shows the Match Statistic";
L["%s: %s"] = "%s: %s";

L["Unable to queue spectated wargame, because either team leader's or bracket number wasn't found."] = "Unable to queue spectated wargame, because either team leader's or bracket number wasn't found.";

-- Broadcasting Feature:
L["Broadcast Team Data"] = "Broadcast Team Data";
L["If checked, team names and scores will be broadcast to the spectator group, when queuing for a war game."] = "If checked, team names and scores will be broadcast to the spectator group, when queuing for a war game.";
L["Received team data from group leader (%s). Updating team entries... (%s)"] = "Received team data from group leader (%s). Updating team entries... (%s)";
L["WARNING! Couldn't register addon message prefix for ArenaLive [Spectator]. You won't be able to receive broadcast data during this session."] = "WARNING! Couldn't register addon message prefix for ArenaLive [Spectator]. You won't be able to receive broadcast data during this session.";

-- Important Message Frame Handler:
L["|c%s%s|r disconnected."] = "|c%s%s|r disconnected.";
L["|c%s%s|r reconnected."] = "|c%s%s|r reconnected.";
L["|c%s%s|r has low health."] = "|c%s%s|r has low health.";
L["|c%s%s|r tries to resurrect |c%s%s|r."] = "|c%s%s|r tries to resurrect |c%s%s|r.";

-- Match Statistic:
L["Clear Match Database"] = "Clear Match Database";
L["Clearing the match statistic database will delete all logged matches. Do you want to proceed?"] = "Clearing the match statistic database will delete all logged matches. Do you want to proceed?";
L["%s vs %s (%d:%d)"] = "%s vs %s (%d:%d)";
L["%d. %s"] = "%d. %s";
L["Choose a Match"] = "Choose a Match";
L["Match:"] = "Match:";
L["ArenaLive [Spectator] Match Statistic"] = "ArenaLive [Spectator] Match Statistic";
L["ArenaLiveSpectatorMatchStatistic:SetMatch(id): id too high."] = "ArenaLiveSpectatorMatchStatistic:SetMatch(id): id too high.";
L["Damage Dealt:"] = "Damage Dealt:";
L["Highest Damage:"] = "Highest Damage:";
L["%s\n(%s)"] = "%s\n(%s)";
L["Healing Done:"] = "Healing Done:";
L["Time in CC:"] = "Time in CC:";
L["Leave Arena"] = "Leave Arena";
L["%d:%s"] = "%d:%s";
L["Delete Match"] = "Delete Match";

-- Player Information Frame:
L["Player Information"] = "Player Information";
L["Talents:"] = "Talents:";
L["Glyphs:"] = "Glyphs:";

-- Settings Tab:
L["Settings"] = "Settings";

	-- Map Drop Down:
	L["Map:"] = "Map:";
	L["Choose the map the war game will take place on."] = "Choose the map the war game will take place on.";
		-- Arena Names:
		-- Names must correspond with the names 
		-- that are shown in Blizzard's Wargame UI.
		L["Blade's Edge Arena"] = "Blade's Edge Arena";
		L["Dalaran Sewers"] = "Dalaran Sewers";
		L["Nagrand Arena"] = "Nagrand Arena";
		L["Ruins of Lordaeron"] = "Ruins of Lordaeron";
		L["The Ring of Valor"] = "The Ring of Valor";
		L["The Tiger's Peak"] = "The Tiger's Peak";
		L["Tol'Viron Arena"] = "Tol'Viron Arena";
		L["All Arenas"] = "All Arenas";

		-- Battleground Names:
		L["Alterac Valley"] = "Alterac Valley";
		L["Warsong Gulch"] = "Warsong Gulch";
		L["Twin Peaks"] = "Twin Peaks";
		L["The Battle for Gilneas"] = "The Battle for Gilneas";
		L["Temple of Kotmogu"] = "Temple of Kotmogu";
		L["Silvershard Mines"] = "Silvershard Mines";
		L["Arathi Basin"] = "Arathi Basin";
		L["Eye of the Storm"] = "Eye of the Storm";
		L["Strand of the Ancients"] = "Strand of the Ancients";
		L["Isle of Conquest"] = "Isle of Conquest";
		L["Deepwind Gorge"] = "Deepwind Gorge";
		L["Southshore vs Tarren Mill"] = "Southshore vs Tarren Mill";
		L["Random Battleground"] = "Random Battleground";
	
	-- Play Mode DropDown:
	L["Bracket:"] = "Bracket:";
	L["Choose the number of players per team."] = "Choose the number of players per team.";
	L["Battleground"] = "Battleground";
	L["2v2"] = "Arena (2v2)";
	L["3v3"] = "Arena (3v3)";
	L["5v5"] = "Arena (5v5)";

	-- Unit Frame Options:
	L["Disable"] = "Disable";
	L["If checked, target and target-of-target frames will be disabled and the width of the current target's side frame will be increased dynamically instead."] = "If checked, target and target-of-target frames will be disabled and the width of the current target's side frame will be increased dynamically instead.";
	L["Enable Castbar"] = "Enable Castbar";
	L["Enable Casthistory"] = "Enable Casthistory";

L["SET_CUSTOM_TOURNAMENT_ICON_TITLE"] = "Tournament Icon:";	
L["SET_CUSTOM_TOURNAMENT_ICON_TOOLTIP"]	= [[Set a custom tournament icon texture that will replace the VS texture on the scoreboard. The texture must either be in .blp, .tga or .png format. It has to have a width of 64 pixels and a height of 32 pixels. The texture must be located in the "TournamentIcons" directory in your "ArenaLiveSpectator3" addon directory.]]

-- Spectated War Games Tab:
L["Spectated War Games"] = "Spectated War Games";

	-- Nickname Database:
	L["Nickname Database"] = "Nickname Database";
	L["New Nickname:"] = "New Nickname:";
	L["Clear Database"] = "Clear Database";
	L["Clearing the nickname database will delete all player nicknames. Do you want to proceed?"] = "Clearing the nickname database will delete all player nicknames. Do you want to proceed?";
	L["Import/Export Editbox:"] = "Import/Export Editbox:";
	L["Import Nicknames"] = "Import Nicknames";
	L["Error while trying to import nickname data. Please check the syntax of the data you're trying to import. Query was: %s"] = "Error while trying to import nickname data. Please check the syntax of the data you're trying to import. Query was: %s";
	L["Export Nicknames"] = "Export Nicknames";
	L["Remove Nickname"] = "Remove Nickname";
	L["Current Nickname:"] = "Current Nickname:";
	L["Add"] = "Add";
	L["Cancel"] = "Cancel";
	L["+"] = "+";
	L["Add a new character name to the selected nickname."] = "Add a new character name to the selected nickname.";
	L["Please enter a character name that will be added to the current nickname.\nUsage: Charactername-RealmName."] = "Please insert a character name that will be added to the current nickname.\nUsage: Charactername-RealmName.";
	L["-"] = "-";
	L["Remove all selected characters from the current nickname."] = "Remove all selected characters from the current nickname.";
	L["Deleting a nickname will also delete the list of characters assigned to it. Do you want to proceed?"] = "Deleting a nickname will also delete the list of characters assigned to it. Do you want to proceed?";
	L["Choose a Nickname"] = "Choose a Nickname";
	L["Choose a Nickname to assign new character names to or delete current entries from."] = "Choose a Nickname to assign new character names to or delete current entries from.";
	
	-- Cooldowntracker Options:
	L["Show Tooltip"] = "Show Tooltip";
	L["If enabled, spell tooltips will be shown when moving the mouse over a cooldown button."] = "If enabled, spell tooltips will be shown when moving the mouse over a cooldown button.";
	
	-- Team Leader Button:
	L["Team Leader:"] = "Team Leader:";
	L["Choose a Player"] = "Choose a Player";
	L["Drag from the player list"] = "Drag and drop here";
	L["Not logged into WoW"] = "Not logged into WoW";
	L["Offline"] = "Offline";

	-- Tournament Rules Checkbutton:
	L["Tournament Rules"] = "Tournament Rules";
	L["If checked, participants will only be allowed to use Tournament Gear. Other equipment will be disabled."] = "If checked, participants will only be allowed to use Tournament Gear. Other equipment will be disabled.";

	-- Team Name Editbox:
	L["Team Name:"] = "Team Name:";
	L["Enter the name of the team. The name will be shown on the scoreboard and on the match statistic."] = "Enter the name of the team. The name will be shown on the scoreboard and on the match statistic.";

	-- Team Score Editbox:
	L["Score:"] = "Score:";
	L["Enter the score of the team. It will be shown on the scoreboard."] = "Enter the score of the team. It will be shown on the scoreboard.";

	-- War Game Queue Button:
	L["Start Spectated War Game"] = "Start Spectated War Game";	
	
-- Scoreboard:
L["Enable Scoreboard"] = "Enable Scoreboard";
L["If checked, a scoreboard with match timer, team name, team score and dampening tracker will be shown during matches."] = "If checked, a scoreboard with match timer, team name, team score and dampening tracker will be shown during matches.";
L["%s: Invalid team %s. Use \"TeamA\"  or \"TeamB\""] = "%s: Invalid team %s. Use \"TeamA\"  or \"TeamB\"";

-- Third Person Player View:
L["Follow Target"] = "Follow Target";
L["If checked, ArenaLive will fixate the camera on your current target. Note: When following a player, nameplates are disabled by the WoW client."] = "If checked, ArenaLive will fixate the camera on your current target. Note: When following a player, nameplates are disabled by the WoW client.";

-- Countdown statusbar text:
L["%d:%d"] = "%d:%d";

-- Chat message patterns (NOTE: These must correspond exactly with the messages that are sent to the client while in the Arena preparation room!):
L["One minute until the Arena battle begins!"] = "One minute until the Arena battle begins!";
L["(.+) seconds until the Arena battle begins!"] = "(.+) seconds until the Arena battle begins!";
	L["Thirty"] = "Thirty";
	L["Fifteen"] = "Fifteen";
L["The Arena battle has begun!"] = "The Arena battle has begun!";
 