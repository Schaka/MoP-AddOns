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

--[[
**************************************************
******* GENERAL HANDLER SET UP STARTS HERE *******
**************************************************
]]--
-- Create new Handler and register for all important events:
local ImportantMessageFrame = ArenaLive:ConstructHandler("ImportantMessageFrame", true, true);
local NameText = ArenaLive:GetHandler("NameText");
ImportantMessageFrame:RegisterEvent("AL_SPEC_PLAYER_UPDATE");
ImportantMessageFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
ImportantMessageFrame:RegisterEvent("UNIT_AURA");
ImportantMessageFrame:RegisterEvent("UNIT_CONNECTION");
ImportantMessageFrame:RegisterEvent("UNIT_SPELLCAST_START");
--ImportantMessageFrame:RegisterEvent("UNIT_HEALTH"); Deactivated until UNIT_HEALTH actually fires for spectated unitIDs

local messageFrames = {};
local unitCache = {};
local unitHealthCache = {};
local unitLowHealthCache = {}; -- This table will store, if a unit was below 25% health, to prevent message spam.
local MessageFrameClass = {};
local feignDeathName;
local unitFeignDeathCache = {};

local function MessageFrameAnimation_OnFinished(animation)
	local singleFrame = animation:GetParent();
	local id = singleFrame:GetID();
	local messageFrame = singleFrame:GetParent();
	singleFrame:Hide();
	
	table.remove(messageFrame.activeMessages, id);
	
	if ( #messageFrame.messageQueue > 0 ) then
		messageFrame:Update();
	end
end

--[[
****************************************
****** HANDLER METHODS START HERE ******
****************************************
]]--
function ImportantMessageFrame:ConstructObject(messageFrame, addon, group)
	messageFrame.addon = addon;
	messageFrame.group = group;
	
	messageFrames[messageFrame] = true;
	messageFrame.activeMessages = {};
	messageFrame.numFrames = 0;
	messageFrame.messageQueue = {};
	
	ArenaLive:CopyClassMethods(MessageFrameClass, messageFrame);
	
	local database = ArenaLive:GetDBComponent(addon, self.name, messageFrame.group);
	for i = 1, database.NumMaxMessages do
		ImportantMessageFrame:CreateSingleFrame(messageFrame);
	end
end

function ImportantMessageFrame:CreateSingleFrame(messageFrame)
	local prefix = messageFrame:GetName();
	local frameNum = messageFrame.numFrames + 1;
	local frame = CreateFrame("Frame", prefix.."Frame"..frameNum, messageFrame, "ArenaLvieSpectatorSingleMessageFrameTemplate");
	
	frame:SetID(frameNum);
	
	local width = messageFrame:GetWidth();
	local height = 32;
	frame:SetSize(width, height);
	
	local point, relativeTo, relativePoint, xOffset, yOffset;
	if ( frameNum == 1 ) then
		point = "TOP";
		relativeTo = messageFrame;
		relativePoint= "TOP";
		xOffset = 0;
		yOffset = 0;
	else
		point = "TOP";
		relativeTo = messageFrame["frame"..messageFrame.numFrames];
		relativePoint= "BOTTOM";
		xOffset = 0;
		yOffset = -5;
	end
	
	frame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset);
	messageFrame["frame"..frameNum] = frame;
	messageFrame.numFrames = frameNum;
	
	frame.anim:SetScript("OnFinished", MessageFrameAnimation_OnFinished);
	frame.anim2:SetScript("OnFinished", MessageFrameAnimation_OnFinished);
	return frame;
end

function ImportantMessageFrame:CreateMessage(event, ...)
	
	local unit = ...;
	local name = NameText:GetNickname(unit) or UnitName(unit);
	local _, class = UnitClass(unit);
	if ( not name or not class ) then
		return;
	end
	
	local unitType = string.match(unit, "^([a-z]+)[0-9]+$");
	local classColour = RAID_CLASS_COLORS[class].colorStr;

	local texture, texCoords, msg, team;
	if ( unitType == "spectateda" ) then
		team = "A";
	else --if ( unitType == "spectatedb" ) then
		team = "B";
	end
	
	if ( event == "UNIT_CONNECTION" ) then --and unitCache[unit]
		local isConnected = select(2, ...);
		if ( isConnected ) then
			texture = BNet_GetClientTexture();
			texCoords = {0, 1, 0, 1}
			msg = string.format(L["|c%s%s|r reconnected."], classColour, name);
		else
			texture = "Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\Battlenet-Offlineicon";
			texCoords = {0, 1, 0, 1}
			msg = string.format(L["|c%s%s|r disconnected."], classColour, name);
		end
	elseif ( event == "UNIT_HEALTH" ) then
		msg = string.format(L["|c%s%s|r has low health."], classColour, name);
		texture = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes";
		texCoords = CLASS_ICON_TCOORDS[class];
	elseif ( event == "UNIT_SPELLCAST_START" ) then
		local spellID = select(5, ...);
		local spellName, _, icon = GetSpellInfo(spellID)
		if ( ArenaLiveSpectator.SpellDB["Resurrects"][spellID] ) then
			local resName = NameText:GetNickname(unit.."target") or UnitName(unit.."target");
			local _, resClass = UnitClass(unit.."target");
			if ( resName and resClass ) then
				local resClassColour = RAID_CLASS_COLORS[resClass].colorStr;
				texture = icon;
				texCoords = {0, 1, 0, 1}
				msg = string.format(L["|c%s%s|r tries to resurrect |c%s%s|r."], classColour, name, resClassColour, resName);
			end
		end
	end
	
	if ( msg and texture and texCoords and team ) then
		for frame in pairs(messageFrames) do
			frame:AddMessage({texture, texCoords, msg, team});
		end
	end
end

function ImportantMessageFrame:UpdatePlayerCache()
	-- Wipe old Cache:
	table.wipe(unitCache);
	table.wipe(unitHealthCache);
	
	-- Check how many players are on both sides:
	local teamA = ArenaLiveSpectator.UnitCache:GetNumPlayers(1);
	local teamB = ArenaLiveSpectator.UnitCache:GetNumPlayers(2);
	local iMax;
	if ( teamA > teamB ) then
		iMax = teamA;
	else
		iMax = teamB;
	end
	
	-- Update cache tables:
	if ( teamA > 0 or teamB > 0 ) then
		local unit;
		for i = 1, iMax do			
			unit = "spectateda"..i;
			if ( i <= teamA ) then
				unitCache[unit] = true;
				unitHealthCache[unit] = 0;
			end
			
			unit = "spectatedb"..i;
			if ( i <= teamB ) then
				unitCache[unit] = true;
				unitHealthCache[unit] = 0;
			end
		end
	end
end

function ImportantMessageFrame:OnEvent(event, ...)
	local unit = ...;
	if ( event == "AL_SPEC_PLAYER_UPDATE" ) then
		ImportantMessageFrame:UpdatePlayerCache();
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		if ( IsSpectator() ) then
			feignDeathName = GetSpellInfo(5384);
			ImportantMessageFrame:UpdatePlayerCache();
			self:Show();
		else
			self:Hide();
			for frame in pairs(messageFrames) do
				frame:Reset();
			end
		end
	elseif ( event == "UNIT_AURA" and unitCache[unit] ) then
		-- BUGFIX: Prevent low health warning
		-- from triggering, if player used
		-- Feign Death.
		local name = UnitBuff(unit, feignDeathName);
		if ( name ) then
			unitFeignDeathCache[unit] = true;
		elseif ( not name and type(unitFeignDeathCache[unit]) == "boolean" ) then
			unitFeignDeathCache[unit] = GetTime() + 1;
		end
	elseif ( event == "UNIT_CONNECTION" and unitCache[unit] ) then
		ImportantMessageFrame:CreateMessage(event, ...);
	elseif ( event == "UNIT_HEALTH" and unitCache[unit] ) then
		-- Use health cache instead of UnitHealth and UnitHealthMax functions: 
		local healthPercent = unitHealthCache[unit];
		local theTime = GetTime();
		if ( healthPercent <= 0.25 and not unitLowHealthCache[unit] and ( not unitFeignDeathCache[unit] or ( type(unitFeignDeathCache[unit]) == "number" and unitFeignDeathCache[unit] <= theTime ) ) ) then
			ImportantMessageFrame:CreateMessage(event, unit);
			unitLowHealthCache[unit] = theTime + 5;
		elseif ( healthPercent > 0.25 and unitLowHealthCache[unit] and unitLowHealthCache[unit] <= theTime  ) then
			-- Reset entry, because unit is abvoe 25% health again
			unitLowHealthCache[unit] = nil;
		end
	elseif ( event == "UNIT_SPELLCAST_START" and unitCache[unit] ) then
		local spellID = select(5, ...);
		if ( ArenaLiveSpectator.SpellDB.Resurrects[spellID] ) then
			ImportantMessageFrame:CreateMessage(event, ...);
		end
	end
end

-- The OnUpdate script fakes UNIT_HEALTH events, because they currently don't work for spectated unitIDs:
function ImportantMessageFrame:OnUpdate(elapsed)
	if ( next(unitHealthCache) and ArenaLiveSpectator:HasMatchStarted() ) then
		local health, healthMax, newHealthPercent;
		for unit, healthPercent in pairs(unitHealthCache ) do
			health = UnitHealth(unit);
			healthMax = UnitHealthMax(unit);
			if ( healthMax == 0 )  then
				healthMax = 1; -- Prevent division by zero.
			end
			
			newHealthPercent = health / healthMax;
			
			if ( newHealthPercent ~= healthPercent ) then
				unitHealthCache[unit] = newHealthPercent;
				ImportantMessageFrame:OnEvent("UNIT_HEALTH", unit);
			end
			
		end
	end
end
ImportantMessageFrame:SetScript("OnUpdate", ImportantMessageFrame.OnUpdate);


--[[
****************************************
****** CLASS METHODS START HERE ******
****************************************
]]--
function MessageFrameClass:AddMessage(messageData)
	local msgNum = #self.activeMessages + 1;
	local database = ArenaLive:GetDBComponent(self.addon, "ImportantMessageFrame", self.group);
	if ( msgNum <= database.NumMaxMessages ) then
		table.insert(self.activeMessages, 1, messageData);
		self:Update();
	else
		table.insert(self.messageQueue, messageData);
	end
end

function MessageFrameClass:Update()
	local frameDB = ArenaLive:GetDBComponent(self.addon, "ImportantMessageFrame", self.group);
	local database = ArenaLive:GetDBComponent(addonName);
	
	for i = 1, frameDB.NumMaxMessages do
		if ( self.activeMessages[i] ) then
			local texture, texCoords, msg, team = unpack(self.activeMessages[i]);
			local frame = self["frame"..i];
			if ( not frame ) then
				frame = ImportantMessageFrame:CreateSingleFrame(self);
			end
			
			-- Stop current animations:
			frame.anim:Stop();
			frame.anim2:Stop();
			
			local red, green, blue;
			if ( team == "A" ) then
				red, green, blue = unpack(database.TeamA.Colour);
			elseif ( team == "B" ) then
				red, green, blue = unpack(database.TeamB.Colour);
			end
				
			frame.icon:SetTexture(texture);
			frame.icon:SetTexCoord(unpack(texCoords));
			frame.font:SetTextColor(red, green, blue);
			frame.font:SetText(msg);
			
			-- First message is always fade in, as it is the newest one:
			if ( i == 1 )then
				frame.anim:Play();
			else
				frame.anim2:Play();
			end
			frame:Show();
		end
	end
	
	if ( #self.activeMessages < frameDB.NumMaxMessages and #self.messageQueue > 0 ) then
		-- Add the first message of the queue:
		local msgData = table.remove(self.messageQueue, 1);
		self:AddMessage(msgData);
	end
end

function MessageFrameClass:Reset()
	for i = 1, self.numFrames do
		local frame = self["frame"..i];
		frame.anim:Stop();
		frame:Hide();
	end
	
	table.wipe(self.activeMessages);
	table.wipe(self.messageQueue);
end