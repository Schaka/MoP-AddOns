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

local NameText = ArenaLive:GetHandler("NameText");
local ImportExport = ArenaLive:GetHandler("ImportExport");

local frameName = "ArenaLiveSpectatorWarGameMenuNicknameDatabase";

ArenaLiveSpectator.NicknameDatabase = _G[frameName];
local NicknameDatabase = ArenaLiveSpectator.NicknameDatabase;
local nicknameDB;

local NICKNAME_DATABASE_CHARACTER_ENTRY_HEIGHT = 28;

local function addCharacterAccept (self)
	if ( self:GetObjectType() == "EditBox" ) then
		self = self:GetParent();
	end
	local nickname = NicknameDatabase.nickname;
	local characterName = self.editBox:GetText();
	self.editBox:SetText("");
	self:Hide();
	
	NicknameDatabase:AssignCharacterToNickname(nickname, characterName);
	NicknameDatabase.scrollFrame:update();
end

-- Static Popups:
StaticPopupDialogs["ALSPEC_CONFIRM_CLEAR_NICKNAME_DB"] = {
	text = L["Clearing the nickname database will delete all player nicknames. Do you want to proceed?"],
	button1 = YES,
	button2 = NO,
	OnAccept = function (self) 
		NicknameDatabase:ClearDatabase();
		UIDropDownMenu_SetText(NicknameDatabase.nickNameDropdown, L["Choose a Nickname"]);
		NicknameDatabase.nickname = nil;
		NicknameDatabase.scrollFrame:update();
	end,
	OnCancel = function (self) end,
	hideOnEscape = 1,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	preferredIndex = STATICPOPUP_NUMDIALOGS, -- Avoid some UI taint.
}

StaticPopupDialogs["ALSPEC_CONFIRM_DELETE_NICKNAME"] = {
	text = L["Deleting a nickname will also delete the list of characters assigned to it. Do you want to proceed?"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(self) 
		local nickname = NicknameDatabase.nickname;
		for key, characterName in ipairs(nicknameDB[nickname]) do
			NameText:RemoveNickname(characterName);
		end
		NicknameDatabase.nickname = nil;
		nicknameDB[nickname] = nil;

		UIDropDownMenu_SetText(NicknameDatabase.nickNameDropdown, L["Choose a Nickname"]);
		NicknameDatabase.scrollFrame:update();
		NicknameDatabase.removeNicknameButton:Disable();	
	end,
	OnCancel = function (self) end,
	hideOnEscape = 1,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	preferredIndex = STATICPOPUP_NUMDIALOGS, -- Avoid some UI taint.
}

StaticPopupDialogs["ALSPEC_ADD_CHARACTER_TO_NICKNAME"] = {
	text = L["Please enter a character name that will be added to the current nickname.\nUsage: Charactername-RealmName."],
	button1 = L["Add"],
	button2 = L["Cancel"],
	OnAccept = addCharacterAccept,
	EditBoxOnEnterPressed = addCharacterAccept,
	OnCancel = function (self)
	end,
	OnHide = function (self)
		self.editBox:SetText("");
	end,
	hasEditBox = 1,
	hideOnEscape = 1,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	preferredIndex = STATICPOPUP_NUMDIALOGS, -- Avoid some UI taint.
}


-- ***************************************************************************
-- ****************** BASIC NICKNAME DATABASE FUNCTIONS **********************
-- ***************************************************************************

function NicknameDatabase:Initialise()
	local database = ArenaLive:GetDBComponent(addonName);
	nicknameDB = database.NicknameDatabase;
	
	self.title:SetText(L["Nickname Database"] .. ":");
	self.ieTitle:SetText(L["Import/Export Editbox:"]);
	self.checkedNames = {};
	
	self:InitialiseNicknames();

	self.editBox:Initialise();
	self.addNicknameButton:Initialise()
	self.addNicknameButton:Disable();
	
	ArenaLiveSpectatorWarGameMenu:InitialiseButton(self.clearButton, L["Clear Database"]);
	ArenaLiveSpectatorWarGameMenu:InitialiseButton(self.importButton, L["Import Nicknames"]);
	ArenaLiveSpectatorWarGameMenu:InitialiseButton(self.exportButton, L["Export Nicknames"]);
	
	self.nickNameDropdown:Initialise();
	self.removeNicknameButton:Initialise();
	self.addCharacterButton:Initalise();
	self.removeSelectedButton:Initialise();
	
	-- Scroll Frame:
	self.scrollFrame.scrollBar.doNotHide = true;
	HybridScrollFrame_CreateButtons(self.scrollFrame, "ArenaLiveSpectatorNicknamePlayerButtonTemplate", 0, -2);
	
	-- Scripts:
	self:SetScript("OnShow", self.OnShow);
end

function NicknameDatabase:OnShow()
	self.scrollFrame:update();
end

function NicknameDatabase:InitialiseNicknames()
	for nickname, characterTable in pairs(nicknameDB) do
		for key, characterName in pairs(characterTable) do
			NameText:AddNickname(characterName, nickname);
		end
	end
end

function NicknameDatabase:AddNickname(nickname)
	if ( not nicknameDB[nickname] ) then
		nicknameDB[nickname] = {};
	end
end

function NicknameDatabase:RemoveNickname(nickname)
	if ( nicknameDB[nickname] ) then
		for key, characterName in ipairs(nicknameDB[nickname]) do
			self:RemoveCharacterFromNickname(nickname, characterName);
		end
		
		nicknameDB[nickname] = nil;
	end
end

function NicknameDatabase:AssignCharacterToNickname(nickname, characterName)

	if ( not nickname or not characterName ) then
		ArenaLive:Mesage(L["%s: Usage %s"], "error", "NicknameDatabase:AddNickname()", "NicknameDatabase:AddNickname(nickname, characterName)");
		return; -- Actually not needed, just leaving this here,
				-- so it is clear that the script stops working
				-- due to the error message.
	end
	
	-- First check, if this character name is
	-- is already registered for a nickname:
	for checkNickname, characterTable in pairs(nicknameDB) do
		for key, charName in ipairs(characterTable) do
			if ( charName == characterName ) then
				-- Remove it:
				self:RemoveCharacterFromNickname(checkNickname, characterName);
				break;
			end
		end
	end
	
	-- Now add it to the current nickname:
	table.insert(nicknameDB[nickname], characterName);
	NameText:AddNickname(characterName, nickname);
end

function NicknameDatabase:RemoveCharacterFromNickname(nickname, characterName)
	if ( not nickname or not characterName ) then
		ArenaLive:Mesage(L["%s: Usage %s"], "error", "NicknameDatabase:RemoveCharacterFromNickname()", "NicknameDatabase:RemoveCharacterFromNickname(nickname, characterName)");
		return;
	end
	if ( nicknameDB and nicknameDB[nickname] ) then
		-- Find key of character that will be deleted:
		local charKey;
		for key, value in ipairs(nicknameDB[nickname]) do
			if ( characterName == value ) then
				charKey = key;
				break;
			end
		end
		
		
		if ( charKey ) then	-- Delete character:
			table.remove(nicknameDB[nickname], charKey);
			NameText:RemoveNickname(characterName);
		end
	end
end

function NicknameDatabase:ClearDatabase()
	
	-- Remove ALL the characters:
	for nickname, characterTable in pairs(nicknameDB) do
		for key, characterName in ipairs(nicknameDB[nickname]) do
			NameText:RemoveNickname(characterName);
		end
	end
	
	-- Wipe db table:
	table.wipe(nicknameDB);
end



-- ***************************************************************************
-- ************************ OPTION ITEM FUNCTIONS ****************************
-- ***************************************************************************
local function OptionItemOnEnter(self)
	if ( self.tooltip ) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, 1);
		GameTooltip:Show();
	end
end

local function OptionItemOnLeave(self)
	GameTooltip:Hide();
end



function NicknameDatabase.editBox:Initialise()
	self.title:SetText(L["New Nickname:"]);
	self:SetScript("OnTextChanged", self.OnTextChanged);
	self:SetScript("OnEnterPressed", NicknameDatabase.addNicknameButton.OnClick);
end

function NicknameDatabase.editBox:OnTextChanged()
	local text = self:GetText();
	if ( text == "" or nicknameDB[text] ) then
		NicknameDatabase.addNicknameButton:Disable();
	else
		NicknameDatabase.addNicknameButton:Enable();
	end
end



function NicknameDatabase.addNicknameButton:Initialise()
	ArenaLiveSpectatorWarGameMenu:InitialiseButton(self, L["Add"]);
end

function NicknameDatabase.addNicknameButton:OnClick()
	local nickname = NicknameDatabase.editBox:GetText();
	if ( nickname and nickname ~= "" ) then
		NicknameDatabase.editBox:SetText("");
		NicknameDatabase.editBox:SetCursorPosition(0);
		NicknameDatabase:AddNickname(nickname);
	end
	-- Always clear focus, because editBox's 
	-- OnEnterPressed script edit box calls
	-- this method.
	NicknameDatabase.editBox:ClearFocus();
end



function NicknameDatabase.clearButton.OnClick()
	StaticPopup_Show("ALSPEC_CONFIRM_CLEAR_NICKNAME_DB");
end


function NicknameDatabase.importButton:OnClick()
	
	local import = NicknameDatabase.ieScrollFrame.editBox:GetText();
	if ( string.find(import, "^(nicknameDB =)") ) then
		local returnEnv = ImportExport:LuaDataToTable(import);
		for nickname, characterTable in pairs(returnEnv.nicknameDB) do
			NicknameDatabase:AddNickname(nickname);
			for key, characterName in ipairs(characterTable) do
				NicknameDatabase:AssignCharacterToNickname(nickname, characterName);
			end			
		end
	else
		ArenaLive:Message(L["Error while trying to import nickname data. Please check the syntax of the data you're trying to import. Query was: %s"], "error", import);
	end
	
	NicknameDatabase.ieScrollFrame.editBox:SetText("");
	NicknameDatabase.ieScrollFrame.editBox:SetCursorPosition(0);
	NicknameDatabase.ieScrollFrame.editBox:ClearFocus();
end



function NicknameDatabase.exportButton:OnClick()
	NicknameDatabase.ieScrollFrame.editBox:SetText("nicknameDB = " ..ImportExport:TableToLuaData(nicknameDB));
	NicknameDatabase.ieScrollFrame.editBox:SetFocus();
	NicknameDatabase.ieScrollFrame.editBox:HighlightText();
end



function NicknameDatabase.removeNicknameButton:Initialise()
	ArenaLiveSpectatorWarGameMenu:InitialiseButton(self, L["Remove Nickname"]);
	self:Disable();
end



function NicknameDatabase.removeNicknameButton:OnClick()
	if ( NicknameDatabase.nickname ) then
		StaticPopup_Show("ALSPEC_CONFIRM_DELETE_NICKNAME");
	end
end



function NicknameDatabase.nickNameDropdown:Initialise()
	local prefix = self:GetName();
	
	-- Set title:
	self.title = _G[prefix.."Title"];
	self.title:SetText(L["Current Nickname:"]);
	
	-- Set default text:
	UIDropDownMenu_SetText(self, L["Choose a Nickname"]);
	
	-- Set tooltip scripts:
	self.tooltip = L["Choose a Nickname to assign new character names to or delete current entries from."];
	self:SetScript("OnEnter", OptionItemOnEnter);
	
	self:SetScript("OnLeave", OptionItemOnLeave);
	
	-- Initialise Dropdown:
	UIDropDownMenu_Initialize(self, self.Refresh);
	UIDropDownMenu_SetWidth(self, 150);
end

function NicknameDatabase.nickNameDropdown.Refresh (self, level, menuList)
	local info = {};
	for nickname in pairs(nicknameDB) do
		info.text = nickname;
		info.value = nickname;
		info.func = self.OnClick;
		if ( nickname == NicknameDatabase.nickname ) then
			info.checked = true;
		else
			info.checked = false;
		end
		UIDropDownMenu_AddButton(info);
	end
end

function NicknameDatabase.nickNameDropdown.OnClick(button)
	local dropdown = UIDROPDOWNMENU_OPEN_MENU;
	local valueText = button:GetText();
	
	NicknameDatabase.nickname = button.value;
	table.wipe(NicknameDatabase.checkedNames);
	
	UIDropDownMenu_SetText(dropdown, valueText);

	NicknameDatabase.addCharacterButton:Enable();
	NicknameDatabase.removeSelectedButton:Disable();
	NicknameDatabase.removeNicknameButton:Enable();
	NicknameDatabase.scrollFrame:update();
end



function NicknameDatabase.addCharacterButton:Initalise()
	self.tooltip = L["Add a new character name to the selected nickname."];
	self:SetScript("OnEnter", OptionItemOnEnter);
	self:SetScript("OnLeave", OptionItemOnLeave);
	
	ArenaLiveSpectatorWarGameMenu:InitialiseButton(self, L["+"]);
	self:SetSize(24, 24);
	self:Disable();
end

function NicknameDatabase.addCharacterButton:OnClick()
	if ( NicknameDatabase.nickname ) then
		StaticPopup_Show("ALSPEC_ADD_CHARACTER_TO_NICKNAME");
	end
end


function NicknameDatabase.removeSelectedButton:Initialise()
	self.tooltip = L["Remove all selected characters from the current nickname."];
	self:SetScript("OnEnter", OptionItemOnEnter);
	self:SetScript("OnLeave", OptionItemOnLeave);
	
	ArenaLiveSpectatorWarGameMenu:InitialiseButton(self, L["-"]);
	self:SetSize(24, 24);
	self:Disable();
end

function NicknameDatabase.removeSelectedButton:OnClick()
	if ( NicknameDatabase.nickname ) then
		for characterName in pairs(NicknameDatabase.checkedNames) do
			NicknameDatabase:RemoveCharacterFromNickname(NicknameDatabase.nickname, characterName);
			NicknameDatabase.checkedNames[characterName] = nil;
		end
		
		NicknameDatabase.scrollFrame:update();
	end
end



function NicknameDatabase.scrollFrame:update()
	if ( NicknameDatabase:IsShown() and NicknameDatabase.nickname ) then
		local nickname = NicknameDatabase.nickname;
		local buttons = self.buttons;
		local offset = HybridScrollFrame_GetOffset(self);
		local numButtons = #buttons;
		local numCharacters = #nicknameDB[nickname];
		
		local index, button, characterName;
		for i = 1, numButtons do
			button = buttons[i];
			index = offset + i;
			if ( index <= numCharacters ) then
				characterName = nicknameDB[nickname][index];
				button.characterName = characterName;
				button.name:SetText(characterName);
				button.checkButton:SetChecked(NicknameDatabase.checkedNames[characterName]);
				button:Show();
			else
				button.checkButton:SetChecked(false);
				button:Hide();
			end
		end
		
		local totalHeight = numCharacters * NICKNAME_DATABASE_CHARACTER_ENTRY_HEIGHT;
		HybridScrollFrame_Update(self, totalHeight, self:GetHeight());
		self:Show();
	else
		self:Hide();
	end
end

function NicknameDatabase.scrollFrame.CheckButtonOnClick(self, button, down)
	if ( button == "LeftButton" and not down ) then
		local scrollFrameButton = self:GetParent();
		local checked = self:GetChecked();
		local characterName = scrollFrameButton.characterName;
		if ( checked ) then
			NicknameDatabase.checkedNames[characterName] = true;
		else
			NicknameDatabase.checkedNames[characterName] = nil;
		end
		
		if ( checked ) then
			NicknameDatabase.removeSelectedButton:Enable();
		elseif ( not next(NicknameDatabase.checkedNames) ) then
			NicknameDatabase.removeSelectedButton:Disable();
		end
	end
end



-- ****************************************************************************
-- *** OLD WAY OF DOING NICKNAMES. WITH VERSION 3.1.10b I SWITCHED (BACK) *****
-- *** TO NICKNAMES BASED ON SINGLE CHARACTERNAMES, AS NUMBER OF BATTLE.NET ***
-- *** FRIENDS IS LIMITED, I.E. TOURNAMENT ORGANIZERS WEREN'T ABLE TO SET   ***
-- *** NICKNAMES FOR ALL PLAYERS IN A TOURNAMENT. *****************************
-- ****************************************************************************
--[[
function NicknameDatabase:Initialise()
	database = ArenaLive:GetDBComponent(addonName);
	database = database.NicknameDatabase;
end

function NicknameDatabase:InitialiseNicknames()
	for battleTag, nickname in pairs(database) do
		local _, _, _, _, toonID, client = ArenaLiveSpectatorWarGameMenu:GetPlayerDataByBattleTag(battleTag);
		if ( toonID and client == BNET_CLIENT_WOW ) then
			NicknameDatabase:UpdateCharacter(battleTag, toonID);
		end
	end
end

function NicknameDatabase:UpdateNickname(battleTag, nickname)
	
	if ( not battleTag or not nickname or database[battleTag] == nickname ) then
		return;
	end
	
	-- Reset old Entry:
	if ( database[battleTag] ) then
		NicknameDatabase:RemoveNickname(battleTag);
	end
	
	local _, _, _, _, toonID, client = ArenaLiveSpectatorWarGameMenu:GetPlayerDataByBattleTag(battleTag);
	if ( battleTag and nickname ) then
		database[battleTag] = nickname;
		if ( toonID and client == BNET_CLIENT_WOW ) then
			NicknameDatabase:UpdateCharacter(battleTag, toonID);
		end
	end
end

function NicknameDatabase:RemoveNickname(battleTag)
	if ( database[battleTag] ) then
		database[battleTag] = nil;
		if ( battleTagToCharacterName[battleTag] ) then
			if ( battleTagToCharacterName[battleTag] ) then
				-- Reset current active nickname for player:
				NameText:RemoveNickname(battleTagToCharacterName[battleTag]);
				battleTagToCharacterName[battleTag] = nil;
			end
		end
	end
end

function NicknameDatabase:UpdateCharacter(battleTag, toonID)
	if ( database[battleTag] and toonID ) then
		local _, name, _, realm = BNGetToonInfo(toonID);
		if ( not realm or realm == "" ) then
			realm = GetRealmName();
		else
			-- Remove spaces from realm names, as
			-- Battle.net returns realm name with
			-- spaces and UnitName returns realm
			-- name without spaces.
			realm = string.gsub(realm, " ", "");
		end
		
		name = name.."-"..realm;
		
		-- Reset existing character nickname:
		if ( battleTagToCharacterName[battleTag] ) then
			NameText:RemoveNickname(battleTagToCharacterName[battleTag]);
		end
		
		battleTagToCharacterName[battleTag] = name;
		NameText:AddNickname(name, database[battleTag]);
	end
end

function NicknameDatabase:ClearDatabase()
	for battleTag, nickname in pairs(database) do
		NicknameDatabase:RemoveNickname(battleTag);
	end
end

function NicknameDatabase:IsToonRegistered(battleTag, toonID)
	local hasFocus, toonName, client, realmName = BNGetToonInfo(toonID);
	if ( client == BNET_CLIENT_WOW ) then
		local name = toonName.."-"..realmName;
		if ( battleTagToCharacterName[battleTag] and battleTagToCharacterName[battleTag] == name ) then
			return true;
		else
			return false;
		end
	else
		return -1; -- Indicates that the unit isn't logged into WoW
	end
end

function NicknameDatabase:OnToonNameUpdate(toonID)
	if ( not toonID ) then
		return;
	end
	
	local _, toonName, client, realmName, _, _, _, _, _, _, _, _, _, _, _, presenceID  = BNGetToonInfo(toonID);
	if ( client ~= BNET_CLIENT_WOW ) then
		return;
	end
	
	if ( presenceID ) then
		local _, _, battleTag = BNGetFriendInfoByID(presenceID);
		if ( battleTag and toonID and database[battleTag] ) then
			if ( not NicknameDatabase:IsToonRegistered(battleTag, toonID) ) then
				NicknameDatabase:UpdateCharacter(battleTag, toonID);
			end
		end
	end
end]]