--[[
    ArenaLive [Spectator] 3 is an user interface for spectated arena 
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
]]

-- Addon Name and localisation table:
local addonName, L = ...;

--[[
**************************************************
******* GENERAL HANDLER SET UP STARTS HERE *******
**************************************************
]]--
-- Create new Handler and register for all important events:
local MainTargetIndicator = ArenaLive:ConstructHandler("MainTargetIndicator", true, true);
MainTargetIndicator:RegisterEvent("AL_SPEC_PLAYER_UPDATE");
MainTargetIndicator:RegisterEvent("PLAYER_ENTERING_WORLD");

local MAIN_TARGET_LEFT, MAIN_TARGET_RIGHT;
local NUM_PLAYERS_LEFT, NUM_PLAYERS_RIGHT = 0, 0;
local playerTargets = {};

--[[
****************************************
****** HANDLER METHODS START HERE ******
****************************************
]]--
function MainTargetIndicator:Update(unitFrame)
	local unit = unitFrame.unit;
	local indicator = unitFrame[self.name];
	
	if ( not unit ) then
		indicator:Hide();
		return;
	end
	
	local guid = unitFrame.guid;
	local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;
	
	-- Get correct main target according to unit type: 
	local mainTarget;
	if ( unitType == "spectateda" ) then
		mainTarget = MAIN_TARGET_RIGHT;
	elseif ( unitType == "spectatedb" ) then
		mainTarget = MAIN_TARGET_LEFT;
	end
	
	if ( mainTarget and mainTarget == guid ) then
		indicator:Show();
	else
		indicator:Hide();
	end
end

function MainTargetIndicator:Reset(unitFrame)
	local unit = unitFrame.unit;
	local indicator = unitFrame[self.name];
	indicator:Hide();
end

function MainTargetIndicator:UpdateNumPlayers()
	NUM_PLAYERS_LEFT = ArenaLiveSpectator.UnitCache:GetNumPlayers(1);
	NUM_PLAYERS_RIGHT = ArenaLiveSpectator.UnitCache:GetNumPlayers(2);
	
	local iMax;
	if ( NUM_PLAYERS_LEFT > NUM_PLAYERS_RIGHT ) then
		iMax = NUM_PLAYERS_LEFT;
	else
		iMax = NUM_PLAYERS_RIGHT;
	end
	local unit;
	for i = 1, iMax do
		unit = "spectateda"..i;
		if ( i <= NUM_PLAYERS_LEFT ) then
			playerTargets[unit] = false;
		else
			playerTargets[unit] = nil;
		end
		
		unit = "spectatedb"..i;
		if ( i <= NUM_PLAYERS_RIGHT ) then
			playerTargets[unit] = false;
		else
			playerTargets[unit] = nil;
		end
	end
	
	if ( NUM_PLAYERS_LEFT > 0 or NUM_PLAYERS_RIGHT > 0 ) then
		self:Show();
	else
		self:Hide();
	end
end

local tempTargetInfo = {};
function MainTargetIndicator:UpdateMainTarget(team)
	local numPlayers, numTargets, playerUnitMod, targetUnitMod;
	if ( team == 1 ) then
		playerUnitMod = "spectateda";
		targetUnitMod = "spectatedb";
		numPlayers = NUM_PLAYERS_LEFT;
		numTargets = NUM_PLAYERS_RIGHT;
	elseif ( team == 2 ) then
		playerUnitMod = "spectatedb";
		targetUnitMod = "spectateda";
		numPlayers = NUM_PLAYERS_RIGHT;
		numTargets = NUM_PLAYERS_LEFT;
	else
		ArenaLive:Message(L["%s: Usage %s"], "error", "MainTargetIndicator:UpdateMainTarget()", "MainTargetIndicator:UpdateMainTarget(team)");
	end
	
	-- There is no main target, if number of players or numer of targets is zero.
	if ( numPlayers == 0 or numTargets == 0 ) then
		if ( team == 1 ) then
			MAIN_TARGET_LEFT = nil;
		elseif ( team == 2 ) then
			MAIN_TARGET_LEFT = nil;
		end
		return;
	end
	
	-- Reset old temp targeting info:
	table.wipe(tempTargetInfo);
	local unit, guid, health, healthMax, health, healthPercent;
	for i = 1, numTargets do
		-- Gather target data:
		unit = targetUnitMod..i;
		guid = UnitGUID(unit);
		if ( guid ) then
			if ( not tempTargetInfo[guid] ) then
				health = UnitHealth(unit);
				healthMax = UnitHealthMax(unit);
				if ( healthMax == 0 ) then
					healthMax = 1; -- Prevent division by zero.
				end
				
				healthPercent = health / healthMax;
				
				tempTargetInfo[guid] = {
					["healthPercent"] = healthPercent,
					["targetedBy"] = 0,
				};
			end
		end
	end
	
	-- Now gather targeting data:
	for i = 1, numPlayers do
		unit = playerUnitMod..i;
		guid = playerTargets[unit];
		if ( guid and tempTargetInfo[guid] ) then
			tempTargetInfo[guid].targetedBy = tempTargetInfo[guid].targetedBy + 1;
		end		
	end

	-- Detect main target. A main target must be
	-- targeted by more than 50% of the opposing team
	-- or must be below 25% health and have the lowest
	-- health of the whole team.
	local targetRatio, tempMainTarget;
	for guid, infoTable in pairs(tempTargetInfo) do
		targetRatio = infoTable.targetedBy / numPlayers;
		infoTable["targetRatio"] = targetRatio;
		
		if ( targetRatio > 0.5 ) then
			tempMainTarget = guid;
		elseif ( infoTable["healthPercent"] < 0.25 and infoTable["healthPercent"] > 0 ) then
			if ( not tempMainTarget 
			or ( targetRatio >= tempTargetInfo[tempMainTarget]["targetRatio"]
			and infoTable["healthPercent"] < tempTargetInfo[tempMainTarget]["targetRatio"] ) ) then
				tempMainTarget = guid;
			end
		end
	end
	
	if ( team == 1 ) then
		MAIN_TARGET_LEFT = tempMainTarget;
		MainTargetIndicator:CallUpdateForUnitType(targetUnitMod);
	elseif ( team == 2 ) then
		MAIN_TARGET_RIGHT = tempMainTarget;
		MainTargetIndicator:CallUpdateForUnitType(targetUnitMod);
	end
end

function MainTargetIndicator:CallUpdateForUnitType(unitType)
	if ( not unitType ) then
		return;
	end
	
	for i = 1, 5 do
		local unit = unitType..i;
		if ( ArenaLive:IsUnitInUnitFrameCache(unit) ) then
			for id in ArenaLive:GetAffectedUnitFramesByUnit(unit) do
				local unitFrame = ArenaLive:GetUnitFrameByID(id);
				if ( unitFrame.enabled and unitFrame[self.name] ) then
					MainTargetIndicator:Update(unitFrame);
				end
			end
		end
	end
end

function MainTargetIndicator:OnEvent(event, ...)
	if ( event == "AL_SPEC_PLAYER_UPDATE" ) then
		self:UpdateNumPlayers();
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		self:UpdateNumPlayers();
	elseif ( event == "UNIT_TARGET" ) then
		local unit = ...;
		local unitType = string.match(unit, "^([a-z]+)[0-9]+$") or unit;
		if ( unitType == "spectateda" ) then
			MainTargetIndicator:UpdateMainTarget(1);
		elseif ( unitType == "spectatedb" ) then
			MainTargetIndicator:UpdateMainTarget(2);
		end
	end
end

local THROTTLE_INTERVAL = 0.5;
local elapsedUntilNow = 0;
function MainTargetIndicator:OnUpdate(elapsed)
	elapsedUntilNow = elapsedUntilNow + elapsed;
	
	if ( elapsedUntilNow >= THROTTLE_INTERVAL ) then
		elapsedUntilNow =  0;
		
		for unit, targetGUID in pairs(playerTargets) do
			local guid = UnitGUID(unit.."target") or false;
			if ( guid ~= targetGUID ) then
				playerTargets[unit] = guid;
				-- Fake UNIT_TARGET event, as currently UNIT_TARGET doesn't fire for spectated units:
				self:OnEvent("UNIT_TARGET", unit);
			end
		end		
	end
end

MainTargetIndicator:SetScript("OnUpdate", MainTargetIndicator.OnUpdate);