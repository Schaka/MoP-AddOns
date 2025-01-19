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

-- Addon Name and localisation table:
local addonName, L = ...;
-- no separate handling
addonName = "ArenaLive"

--[[
**************************************************
******* GENERAL HANDLER SET UP STARTS HERE *******
**************************************************
]]--
ArenaLive.UnitCache = CreateFrame("Frame", "ArenaLiveSpectatorUnitCache");
local UnitCache = ArenaLiveSpectator.UnitCache;
local unitCache = {};
local unitInfo = {};
local NUM_MAX_PLAYERS = 10;
local ELAPSED, ON_UPDATE_THROTTLE = 0, 1;
local NEXT_PLAYER_INFO_REFRESH, REFRESH_THROTTLE = 0, 10;
local GUID_WAITING_FOR_INSPECT_EVENT, INSPECT_TIME_UNTIL_TIMEOUT;
local NUM_GLPYH_SLOTS = 6;
local MAX_TALENT_TIERS = 7;
local NUM_TALENT_COLUMNS = 3;
local inspectQueue = {};

local numPlayers = {
	[1] = 0,
	[2] = 0,
};
UnitCache:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");



--[[
****************************************
****** HANDLER METHODS START HERE ******
****************************************
]]--
function UnitCache:Enable(statusID)
	self.statusID = statusID;
	UnitCache:PopulateUnitCacheTables();
	self:RegisterEvent("UNIT_PET");
	self:RegisterEvent("INSPECT_READY");
	
	if ( not ArenaLiveSpectator:HasMatchStarted() ) then
		-- Refresh all inspect info on match start,
		-- so talent swaps are processed correctly:
		ArenaLiveSpectator:CallOnMatchStart(UnitCache.GetInspectInfoForAll, "UnitCache:GetInspectInfoForAll()");
	end
	
	ELAPSED = ON_UPDATE_THROTTLE;
	NEXT_PLAYER_INFO_REFRESH = GetTime() + REFRESH_THROTTLE;
	self:Show();
	self.enabled = true;
	ArenaLive:Message("Enabling Spectated Unit Cache", "debug");
end

function UnitCache:Disable()
	self.statusID = nil;
	self:RegisterEvent("UNIT_PET");
	self:UnregisterEvent("INSPECT_READY");
	self:Hide();
	
	ELAPSED = 0;
	
	-- Reset unit info:
	table.wipe(unitCache);
	table.wipe(unitInfo);
	
	numPlayers[1] = 0;
	numPlayers[2] = 0;
	
	table.wipe(inspectQueue);
	GUID_WAITING_FOR_INSPECT_EVENT = nil;
	INSPECT_TIME_UNTIL_TIMEOUT = nil;
	
	self.enabled = false;
	ArenaLive:Message("Disabling Spectated Unit Cache", "debug");
end

function UnitCache:IsEnabled()
	return self.enabled;
end

function UnitCache:GetNumPlayers(teamID)
	if ( type(teamID) ~= "number" ) then
		ArenaLive:Message(L["%s: Usage %s"], "error", "UnitCache:GetNumPlayers()", "UnitCache:GetNumPlayers(teamID)");
	elseif ( teamID < 1 or teamID > 2 ) then
		ArenaLive:Message(L["ArenaLiveSpectator.UnitCache:GetNumPlayers(): teamID too low or too high. Value must be 1 or 2."], "error");
	else
		return numPlayers[teamID]
	end
end

function UnitCache:GetUnitInfo(unit)
	if ( unit and unitInfo[unit] ) then
		return true, unit, unitInfo[unit].guid, unitInfo[unit].name, unitInfo[unit].team;
	else
		return nil;
	end
	
end

function UnitCache:GetUnitInfoByGUID(guid)
	local queryUnit;
	for unit, infoTable in pairs(unitInfo) do
		if ( guid == infoTable.guid ) then
			queryUnit = unit;
			break;
		end
	end
	
	return self:GetUnitInfo(queryUnit);
end

function UnitCache:GetUnitInfoByName(name)
	local queryUnit;
	for unit, infoTable in pairs(unitInfo) do
		if ( name == infoTable.name ) then
			queryUnit = unit;
			break;
		end
	end
	
	return self:GetUnitInfo(unit);
end

function UnitCache:CheckUnitState(unit)
	if ( not unit ) then
		return;
	end
	
	local unitName = UnitName(unit);
	local exists = UnitExists(unit);
	local guid = UnitGUID(unit);
	
	local state = ( exists and guid and unitName and unitName ~= UNKNOWN );
	if ( state ~= unitCache[unit] or ( unitInfo[unit] and guid ~= unitInfo[unit].guid ) ) then
		local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;
		
		local teamID;
		if ( unitType == "spectateda" ) then
			teamID = 1;
		elseif ( unitType == "spectatedb" ) then
			teamID = 2;
		end		
		
		local countMod;
		if ( state ) then
			countMod = 1;
		else
			countMod = -1;
		end	

		if ( state ~= unitCache[unit] and teamID ) then
			numPlayers[teamID] = numPlayers[teamID] + countMod;
			ArenaLive:Message("%s: state = %s, countMod = %d, numPlayers[%d] = %d", "debug", unit, tostring(state), countMod, teamID, numPlayers[teamID]);
		end
		
		unitCache[unit] = state;
		--ArenaLive:Message([[UnitCache: Existence state or GUID changed for unit %s to %s. numPlayers[%d] = %d. Triggering "AL_SPEC_PLAYER_UPDATE" event...]], "debug", unit, tostring(state), teamID, numPlayers[teamID]);
		self:SetUnitInfo(unit);
		ArenaLive:TriggerEvent("AL_SPEC_PLAYER_UPDATE", unit, state);
	end
end

function UnitCache:PopulateUnitCacheTables()
	-- DEBUG: For debugging purposes:
	--unitCache["player"] = false;
	for i = 1, NUM_MAX_PLAYERS do
		local unit = "spectateda"..i;
		unitCache[unit] = false;
		unit = "spectatedb"..i;
		unitCache[unit] = false;
	end
end

function UnitCache:SetUnitInfo(unit)
	if ( unitCache[unit] ) then
		local name, realm = UnitName(unit);
		local guid = UnitGUID(unit);
		if ( not realm ) then
			realm = GetRealmName();
		end
		name = name.."-"..realm;
		local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;
		local teamID;
		local database = ArenaLive:GetDBComponent(addonName);
		if ( unitType == "spectateda" or unitType == "spectatedpeta" ) then
			teamID = 1; -- (Alliance or yellow team);
		elseif ( unitType == "spectatedb"  or unitType == "spectatedpetb" ) then
			teamID = 0; -- (Horde or green team);
		end
		
		unitInfo[unit] = {};
		unitInfo[unit].guid = guid;
		unitInfo[unit].name = name;
		unitInfo[unit].team = teamID;
		
		local isPlayer = UnitIsPlayer(unit);
		if ( isPlayer and not inspectQueue[guid] ) then
			inspectQueue[guid] = unit;
			if ( not GUID_WAITING_FOR_INSPECT_EVENT ) then
				UnitCache:CallInspect();
			end
		end
	elseif ( unitInfo[unit] ) then
		table.wipe(unitInfo[unit]);
		unitInfo[unit] = nil;
	end
	
end



--[[
	INSPECT AND TALENT RELEVANT FUNCTIONS:
]]
function UnitCache:CallInspect()
	local guid, unit = next(inspectQueue);
	if ( unit and CanInspect(unit) ) then
		local name = GetUnitName(unit);
		ArenaLive:Message("Sending inspect query for %s (%s)...", "debug", unit, name);
		NotifyInspect(unit);
		
		GUID_WAITING_FOR_INSPECT_EVENT = guid;
		-- If the server doesn't respond within 5 seconds,
		-- I assume a timeout for the inspect query and move
		-- on to the next guid in the queue.
		INSPECT_TIME_UNTIL_TIMEOUT = GetTime() + 5;
	elseif ( guid ) then
		-- Remove this entry from the list, as it cannot be inspected:
		inspectQueue[guid] = nil;
		
		local nextKey, nextValue = next(inspectQueue);
		if ( nextKey and guid == GUID_WAITING_FOR_INSPECT_EVENT ) then
			UnitCache:CallInspect();
		end	
	end
end

function UnitCache:OnInspectTimeOut()
	if ( GUID_WAITING_FOR_INSPECT_EVENT and INSPECT_TIME_UNTIL_TIMEOUT and GetTime() >= INSPECT_TIME_UNTIL_TIMEOUT ) then
		local guid, unit = GUID_WAITING_FOR_INSPECT_EVENT, inspectQueue[GUID_WAITING_FOR_INSPECT_EVENT];
		ArenaLive:Message([[Inspect timeout for player with guid "%s", trying next entry...]], "debug", guid);
		-- Remove old entry
		inspectQueue[GUID_WAITING_FOR_INSPECT_EVENT] = nil;
		GUID_WAITING_FOR_INSPECT_EVENT = nil;
		INSPECT_TIME_UNTIL_TIMEOUT = nil;
		
		
		local nextGUID = next(inspectQueue);
		if ( nextGUID ) then
			-- Try next one:
			UnitCache:CallInspect();
		end
		
		-- Add old one to list:
		inspectQueue[guid] = unit;
		if ( not nextGUID ) then
			-- Retry if it was the last player in the queue:
			UnitCache:CallInspect();
		end
	end
end

function UnitCache:GetInspectInfoForAll()
	for unit in pairs(unitCache) do
		if ( unit ) then
			local exists, _, guid = UnitCache:GetUnitInfo(unit);
			if ( guid ) then
				inspectQueue[guid] = unit;
			end
		end
	end
	
	UnitCache:CallInspect();
end

function UnitCache:GetUnitRole(unit)
	if ( not unit or not unitInfo[unit] ) then
		return nil;
	else
		return unitInfo[unit].role;
	end
end

function UnitCache:GetUnitSpecialisation(unit)
	if ( not unit or not unitInfo[unit] ) then
		return nil;
	else
		return unitInfo[unit].specID;
	end
end

function UnitCache:GetUnitSelectedTalentByTier(unit, tier)
	if ( not unit or not tier ) then
		ArenaLive:Message(L["%s: Usage %s"], "error", "UnitCache:GetUnitSelectedTalentByTier()", "UnitCache:GetUnitSelectedTalentByTier(unit, tier)");
	elseif ( not unitInfo[unit] or not unitInfo[unit].talents or not unitInfo[unit].talents[tier] ) then
		return nil;
	else
		return GetTalentInfoByID(unitInfo[unit].talents[tier]);
	end
end

function UnitCache:GetUnitSelectedGlyphBySlot(unit, slot)
	if ( not unit or not slot ) then
		ArenaLive:Message(L["%s: Usage %s"], "error", "UnitCache:GetUnitSelectedGlyphBySlot()", "UnitCache:GetUnitSelectedGlyphBySlot(unit, slot)");
	elseif ( not unitInfo[unit] or not unitInfo[unit].glyphs ) then
		return nil;
	else
		return unitInfo[unit].glyphs[slot];
	end
end

function UnitCache:SetInspectData(unit)
	if ( not unit or not unitInfo[unit] ) then
		return;
	end
	
	ArenaLive:Message("Received Inspect Data for unit %s, starting to info table with values...", "debug", unit);
	
	local specID = GetInspectSpecialization(unit);
	unitInfo[unit].specID = specID;
	unitInfo[unit].role = GetSpecializationRoleByID(specID or 0);
	
	-- Get Selected talents:
	if ( not unitInfo[unit].talents ) then
		unitInfo[unit].talents = {};
	else
		table.wipe(unitInfo[unit].talents);
	end
	for tier = 1, MAX_TALENT_TIERS do
		for column = 1, NUM_TALENT_COLUMNS do
			local talentID, name, _, selected = GetTalentInfo(tier, column, nil, true, unit);
			if ( talentID and selected ) then
				unitInfo[unit].talents[tier] = talentID;
				ArenaLive:Message("     Tier %d selected Talent is %s", "debug", tier, name);
			end
		end
	end
		
	-- Get Selected Glyphs:
	if ( not unitInfo[unit].glyphs ) then
		unitInfo[unit].glyphs = {};
	else
		table.wipe(unitInfo[unit].glyphs);
	end
	for slot = 1, NUM_GLPYH_SLOTS do
		local _, _, _, glpyhID = GetGlyphSocketInfo(slot, nil, true, unit);
		if ( glpyhID ) then
			local name = GetSpellInfo(glpyhID);
			unitInfo[unit].glyphs[slot] = glpyhID;
			ArenaLive:Message("     Slot %d selected Glyph is %s", "debug", slot, name);
		end
	end
	
	ArenaLive:Message("     Finished setting up inspect data for unit %s, firing AL_SPEC_PLAYER_SPECIALIZATION_UPDATE event...", "debug", unit);
	ArenaLive:TriggerEvent("AL_SPEC_PLAYER_SPECIALIZATION_UPDATE", unit);
end

function UnitCache:OnEvent(event, ...)
	if ( event == "UNIT_PET" ) then
		local unit = ...;
		local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;
		if ( unitType == "spectateda" or unitType == "spectatedb" ) then
			local number = string.match(unit, "^[a-z]+([0-9]+)$");
			local unit;
			if ( unitType == "spectateda" ) then
				unit = "spectatedpeta"..number;
			else
				unit = "spectatedpetb"..number;
			end
			
			self:CheckUnitState(unit);
		end
	elseif ( event == "INSPECT_READY" and GUID_WAITING_FOR_INSPECT_EVENT ) then		
		local guid = ...;
		if ( guid == GUID_WAITING_FOR_INSPECT_EVENT ) then
			GUID_WAITING_FOR_INSPECT_EVENT = nil;
			INSPECT_TIME_UNTIL_TIMEOUT = nil;
			inspectQueue[guid] = nil;
			
			for unit, infoTable in pairs(unitInfo) do
				if ( guid == infoTable.guid ) then
					UnitCache:SetInspectData(unit);
				end
			end
		
			-- Clear Inspect:
			ClearInspectPlayer();
		
			-- Call next inspect in queue, if necessary:
			if ( next(inspectQueue) ) then
				UnitCache:CallInspect();
			end
		end
	elseif ( event == "UPDATE_BATTLEFIELD_STATUS" ) then
		local statusID = ...;
		local status = GetBattlefieldStatus(statusID);
		local isSpectator = IsSpectator();
		if( status == "active" and isSpectator and ( not self.enabled or statusID ~= self.statusID ) ) then -- 
			self:Enable(statusID);
		elseif ( status == "none" and statusID == self.statusID ) then
			self:Disable();
		end
	end
end

function UnitCache:OnUpdate(elapsed)
	if ( self.enabled ) then
		ELAPSED = ELAPSED + elapsed;
		if ( ELAPSED >= ON_UPDATE_THROTTLE ) then
			local theTime = GetTime();
			ELAPSED = 0;
			-- DEBUG: For debugging purposes:
			--UnitCache:CheckUnitState("player");
			for i = 1, NUM_MAX_PLAYERS do
				local unit = "spectateda"..i;
				UnitCache:CheckUnitState(unit);
				unit = "spectatedb"..i;
				UnitCache:CheckUnitState(unit);
			end
		
			if ( INSPECT_TIME_UNTIL_TIMEOUT and theTime >= INSPECT_TIME_UNTIL_TIMEOUT ) then
				UnitCache:OnInspectTimeOut();
			end
			
			-- As long as we're in the waiting room,
			-- we refresh player spec info every 10
			-- sec, so the player info frame is always
			-- up to date.
			if ( theTime >= NEXT_PLAYER_INFO_REFRESH and not ArenaLiveSpectator:HasMatchStarted() ) then
				NEXT_PLAYER_INFO_REFRESH = theTime + REFRESH_THROTTLE;
				UnitCache:GetInspectInfoForAll();
			end
		end
	end
end

-- Disable on initial load:
UnitCache:Disable();
UnitCache:SetScript("OnEvent", UnitCache.OnEvent);
UnitCache:SetScript("OnUpdate", UnitCache.OnUpdate);