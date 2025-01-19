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
local CooldownTracker = ArenaLive:ConstructHandler("CooldownTracker", true, true);
local Cooldown = ArenaLive:GetHandler("Cooldown");
local NameText = ArenaLive:GetHandler("NameText");

-- DEBUG:
-- CooldownTracker.currentStatusID = 1;

local CooldownTrackerClass = {};
local trashTable = {};
local trackers = {};
local trackedUnits = {};
local cooldownData = {};
local activeCooldowns = {};

local actionToPriority = {
	["ADD"] = 5,
	["REPLACE"] = 4,
	["REMOVE"] = 3,
	["MODIFY_COOLDOWN"] = 2,
	["MODIFY_CHARGES"] = 1,
};

local NUM_GLPYH_SLOTS = 6;
local MAX_TALENT_TIERS = 7;
local NUM_TALENT_COLUMNS = 3;

CooldownTracker:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
CooldownTracker:RegisterEvent("AL_SPEC_PLAYER_UPDATE");
CooldownTracker:RegisterEvent("AL_SPEC_PLAYER_SPECIALIZATION_UPDATE");
CooldownTracker:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
CooldownTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED_SPELL_DISPEL");

function ArenaLiveSpectator:GetTrackedUnits()
	for unit, numRegisters in pairs(trackedUnits) do
		print(unit, numRegisters);
	end
end

local function newTable()
	local numTables = #trashTable or 0;
	local new;
	if ( numTables > 0 ) then
		new = table.remove(trashTable, numTables);
	else
		new = {};
	end
	
	return new;
end

local function dumpTable(t)
	if ( type(t) ~= "table" ) then
		return;
	end
	
	table.wipe(t);
	table.insert(trashTable, t);
end

local sortGUID;
local function sortFunc(a, b)
	return cooldownData[sortGUID]["cooldowns"][a].priority > cooldownData[sortGUID]["cooldowns"][b].priority;
end

local function OnEnter(self)
	local database = ArenaLive:GetDBComponent(self.addon, "CooldownTracker", self.group);
	if ( database.ShowTooltip and self.spellID ) then
		ArenaLiveSpectatorTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
		ArenaLiveSpectatorTooltip:SetSpellByID(self.spellID);
	end
end

local function OnLeave(self)
	ArenaLiveSpectatorTooltip:Hide();
end

--[[
****************************************
****** HANDLER METHODS START HERE ******
****************************************
]]--
function CooldownTracker:ConstructObject(cooldownTracker, nameText, classIcon, specIcon, addonName, frameGroup, template)
	cooldownTracker.nameText = nameText;
	cooldownTracker.classIcon = classIcon;
	cooldownTracker.specIcon = specIcon;
	cooldownTracker.addon = addonName;
	cooldownTracker.group = frameGroup;
	cooldownTracker.template = template;
	cooldownTracker.numIcons = 0;
	cooldownTracker.shownCooldowns = {};
	ArenaLive:CopyClassMethods(CooldownTrackerClass, cooldownTracker);
	
	cooldownTracker:Enable();
end

function CooldownTracker:ConstructIcon(cooldownTracker)
	local prefix = cooldownTracker:GetName();
	local numIcons = cooldownTracker.numIcons;
	local icon = CreateFrame("Button", prefix.."Icon"..numIcons+1, cooldownTracker, cooldownTracker.template);
	
	cooldownTracker["icon"..numIcons+1] = icon;
	cooldownTracker.numIcons = cooldownTracker.numIcons + 1;
	
	Cooldown:ConstructObject(icon.cooldown, cooldownTracker.addon, nil, nil, 10);
	
	icon:SetScript("OnEnter", OnEnter);
	icon:SetScript("OnLeave", OnLeave);
	
	return icon;
end

function CooldownTracker:GetNewOffset(cooldownTracker, width, height, xOffset, yOffset)
	local database = ArenaLive:GetDBComponent(cooldownTracker.addon, self.name, cooldownTracker.group);
	local space = database.Space;
	if ( database.GrowingDirection == "UP" ) then
		yOffset = yOffset + height + space;
	elseif ( database.GrowingDirection == "RIGHT" ) then
		xOffset = xOffset + width + space;
	elseif ( database.GrowingDirection == "DOWN" ) then
		yOffset = yOffset - height - space;
	elseif ( database.GrowingDirection == "LEFT" ) then
		xOffset = xOffset - width - space;
	end

	return xOffset, yOffset;
end

function CooldownTracker:UpdateTrackersByUnit(unit)
	for tracker in pairs(trackers) do
		if ( unit == tracker.unit ) then
			tracker:Update();
		end
	end
end

function CooldownTracker:UpdateTrackersByGUID(guid)
	for tracker in pairs(trackers) do
		if ( guid == tracker.guid ) then
			tracker:Update();
		end
	end
end

function CooldownTracker:UpdateTrackerShownIconsByGUID(guid)
	for tracker in pairs(trackers) do
		if ( guid == tracker.guid ) then
			tracker:UpdateShownCooldowns();
		end
	end
end

function CooldownTracker:RegisterUnit(unit)
	if ( not trackedUnits[unit] ) then
		trackedUnits[unit] = 1;
	else
		trackedUnits[unit] = trackedUnits[unit] + 1;
	end
end

function CooldownTracker:UnregisterUnit(unit)
	if ( trackedUnits[unit] ) then
		trackedUnits[unit] = trackedUnits[unit] - 1;

		if ( trackedUnits[unit] < 1 ) then
			trackedUnits[unit] = nil;
		end
	end
end

function CooldownTracker:GatherCooldownInfo(unit)

	if ( not unit ) then
		ArenaLive:Message(string.format(L["%s: Usage %s"], "error", "CooldownTracker:GatherCooldownInfo()", "CooldownTracker:GatherCooldownInfo(unit)"));
	end
	
	local guid = UnitGUID(unit);
	local isPlayer = UnitIsPlayer(unit);
	if ( guid and isPlayer ) then
		
		-- Reset old information first:
		CooldownTracker:ResetCooldownTable(guid);
		
		-- Set up cooldown table structure:
		CooldownTracker:SetUpCooldownTable(guid);
		
		local _, class = UnitClass(unit);
		local _, race = UnitRace(unit);
		
		cooldownData[guid].class = class;
		cooldownData[guid].race = race;
		cooldownData[guid].faction = UnitFactionGroup(unit);
		cooldownData[guid].specID = ArenaLiveSpectator.UnitCache:GetUnitSpecialisation(unit);
		cooldownData[guid].unit = unit; -- prevents cooldowns from triggering from multiple unitIDs with the same guid.
		
		for tier = 1, MAX_TALENT_TIERS do
			local talentID, name = ArenaLiveSpectator.UnitCache:GetUnitSelectedTalentByTier(unit, tier);
			if ( talentID and name ) then
				cooldownData[guid].talents[talentID] = name;
			end
		end
		
		-- Apply glyphs:
		for slot = 1, NUM_GLPYH_SLOTS do
			local glyphID = ArenaLiveSpectator.UnitCache:GetUnitSelectedGlyphBySlot(unit, slot);
			if ( glyphID ) then
				cooldownData[guid].glyphs[glyphID] = true;
			end
		end
		
		CooldownTracker:SetUpCooldownsForGUID(guid);
	end
end

function CooldownTracker:SetUpCooldownTable(guid)

	if ( guid and not cooldownData[guid] ) then
		cooldownData[guid] = newTable();
		cooldownData[guid].cooldowns = newTable();
		cooldownData[guid].priorityList = newTable();
		cooldownData[guid].talents = newTable();
		cooldownData[guid].glyphs = newTable();
	end
end

function CooldownTracker:ResetCooldownTable(guid)
	if ( guid and cooldownData[guid] ) then
		dumpTable(cooldownData[guid].cooldowns);
		cooldownData[guid].cooldowns = nil;
		dumpTable(cooldownData[guid].priorityList);
		cooldownData[guid].priorityList = nil;
		dumpTable(cooldownData[guid].talents);
		cooldownData[guid].talents = nil;
		dumpTable(cooldownData[guid].glyphs);
		cooldownData[guid].glyphs = nil;
		dumpTable(cooldownData[guid]);
		cooldownData[guid] = nil;
		CooldownTracker:UpdateTrackerShownIconsByGUID(guid);
	end
end

local cooldownActionQueue = {};
local function sortActionQueue(a, b)
	return actionToPriority[a.action] > actionToPriority[b.action];
end

local function addToActionQueue(action, spellID, value, replaceID, newPriority)
	if ( type(action) == "table" ) then
		for index, actionType in pairs(action) do
			if ( actionType == "REPLACE" ) then
				addToActionQueue(actionType, spellID[index], value[index], replaceID[index]);
			elseif ( type(newPriority) == "table" ) then
				addToActionQueue(actionType, spellID[index], value[index], nil, newPriority[index]);
			else
				addToActionQueue(actionType, spellID[index], value[index], nil, newPriority);
			end
		end
	elseif ( type(spellID) == "table" ) then
		for key, realSpellID in pairs(spellID) do
			addToActionQueue(action, realSpellID, value, replaceID, newPriority);
		end
	elseif ( action ) then
		table.insert(cooldownActionQueue, { ["action"] = action, ["spellID"] = spellID, ["value"] = value, ["replace"] = replaceID, ["newPriority"] = newPriority});
	end
end

function CooldownTracker:SetUpCooldownsForGUID(guid)
	if ( guid and cooldownData[guid] ) then
		local class = cooldownData[guid].class;
		local race = cooldownData[guid].race;
		local faction = cooldownData[guid].faction;
		local specID = cooldownData[guid].specID;
		-- Set trinket cooldown:
		local spellID, duration = unpack(ArenaLive.spellDB.Trinket);
		CooldownTracker:AddCooldown(guid, spellID, duration);
		
		-- NOTE: Some important racials are back in version 3.1.12b
		-- Set racial cooldown:
		if ( race == "Dwarf" or race == "Orc" or race == "Scourge" or race == "Troll" ) then
			if ( ArenaLive.spellDB.Racials[race][class] ) then
				spellID, duration = unpack(ArenaLive.spellDB.Racials[race][class]);
			else
				spellID, duration = unpack(ArenaLive.spellDB.Racials[race]);
			end
			CooldownTracker:AddCooldown(guid, spellID, duration);
		end
		
		-- Get class/spec cooldowns:
		for spellID, duration in pairs(ArenaLiveSpectator.SpellDB.CooldownClassSpecInfo[class][specID]) do
			CooldownTracker:AddCooldown(guid, spellID, duration);
		end
		
		-- Now iterate through talents and glyphs:
		for talentID, talentName in pairs(cooldownData[guid].talents) do
			local action, spellID, value, replaceID, newPriority = ArenaLiveSpectator:GetCooldownInfo(class, "talent", talentID);
			if ( action ) then
				addToActionQueue(action, spellID, value, replaceID, newPriority);
			end
		end
		
		for glyphID in pairs(cooldownData[guid].glyphs) do
			local action, spellID, value, replaceID, newPriority = ArenaLiveSpectator:GetCooldownInfo(class, "glyph", glyphID);
			
			if ( action ) then
				addToActionQueue(action, spellID, value, replaceID, newPriority);
			end
		end

		-- NOTE: Sort action table.
		-- Priority is: ADD > REPLACE > MODIFY_COOLDOWN = MODIFY_CHARGES
		table.sort(cooldownActionQueue, sortActionQueue);
		
		for index, actionTable in ipairs(cooldownActionQueue) do
			CooldownTracker:ExecuteCooldownModification(guid, actionTable.action, actionTable.spellID, actionTable.value, actionTable.replace, actionTable.newPriority);
		end
		table.wipe(cooldownActionQueue);
		
		-- Sort priority table according to spell priorities:
		sortGUID = guid;
		table.sort(cooldownData[guid].priorityList, sortFunc);
		
		-- Update affected unit frames:
		CooldownTracker:UpdateTrackerShownIconsByGUID(guid);
	end
end
function CooldownTracker:ExecuteCooldownModification(guid, action, spellID, value, replaceID, newPriority)
	if ( action == "ADD" ) then
		CooldownTracker:AddCooldown(guid, spellID, value);
	elseif ( action == "MODIFY_CHARGES" ) then
		CooldownTracker:ModifyCooldownCharges(guid, spellID, value);
	elseif( action == "MODIFY_COOLDOWN" ) then
		CooldownTracker:ModifyCooldown(guid, spellID, value);
	elseif ( action == "REMOVE" ) then
		CooldownTracker:RemoveCooldown(guid, spellID);
	elseif ( action == "REPLACE" ) then
		CooldownTracker:RemoveCooldown(guid, replaceID);
		CooldownTracker:AddCooldown(guid, spellID, value);
	end
		
	if ( newPriority ) then
		CooldownTracker:ModifyCooldownPriority(guid, spellID, newPriority)
	end
end

function CooldownTracker:AddCooldown(guid, spellID, duration)	
	local _, _, icon = GetSpellInfo(spellID);
	local class = cooldownData[guid].class;
	local faction = cooldownData[guid].faction;
	local specID = cooldownData[guid].specID;
	-- Switch texture for pvp trinket:
	if ( spellID == 42292 ) then
		if ( faction == "Alliance" ) then
			icon = "Interface\\ICONS\\INV_Jewelry_TrinketPVP_01";
		else
			icon = "Interface\\ICONS\\INV_Jewelry_TrinketPVP_02";
		end	
	end
	
	local totalCharges;
	if ( type(duration) == "table" ) then
		-- This spell has charges:
		totalCharges = duration[2];
		duration = duration[1];
	else
		totalCharges = 1;
	end
	
	-- Check if there is an active cooldown for this spell:
	local identifier = guid..";"..spellID;
	local activeCooldownInfo = activeCooldowns[identifier];
	local expires, charges;
	if ( activeCooldownInfo ) then
		expires, charges = string.split(";", activeCooldownInfo);
		expires = tonumber(expires);
		charges = tonumber(charges);
		if ( expires > GetTime() ) then
			charges = charges - 1;
		end
	end
	
	cooldownData[guid]["cooldowns"][spellID] = newTable();
	cooldownData[guid]["cooldowns"][spellID].charges = charges or totalCharges;
	cooldownData[guid]["cooldowns"][spellID].duration = duration;
	cooldownData[guid]["cooldowns"][spellID].expires = expires;
	cooldownData[guid]["cooldowns"][spellID].texture = icon;
	cooldownData[guid]["cooldowns"][spellID].totalCharges = totalCharges;
	cooldownData[guid]["cooldowns"][spellID].priority = ArenaLiveSpectator:GetCooldownPriority(spellID, class, specID);
	
	table.insert(cooldownData[guid].priorityList, spellID);
end

function CooldownTracker:ModifyCooldown(guid, spellID, value)

	if ( cooldownData[guid]["cooldowns"][spellID] ) then
		local newVal;
		local baseDuration = cooldownData[guid]["cooldowns"][spellID].duration;
		if ( type(value) == "function" ) then
			-- Some values need a function to execute their spell changes.		
			newVal = value(baseDuration);
		else
			newVal = baseDuration + value;
		end		

		cooldownData[guid]["cooldowns"][spellID].duration = newVal;
	end
end

function CooldownTracker:ModifyCooldownCharges(guid, spellID, value)
	if ( cooldownData[guid]["cooldowns"][spellID] ) then
		local charges = cooldownData[guid]["cooldowns"][spellID].charges;
		local totalCharges = cooldownData[guid]["cooldowns"][spellID].totalCharges;
		cooldownData[guid]["cooldowns"][spellID].totalCharges = totalCharges + value;
		cooldownData[guid]["cooldowns"][spellID].charges = charges + value;
	end
end

function CooldownTracker:ModifyCooldownPriority(guid, spellID, newPriority)
	if ( cooldownData[guid]["cooldowns"][spellID] ) then
		cooldownData[guid]["cooldowns"][spellID].priority = newPriority;
	end
end

function CooldownTracker:RemoveCooldown(guid, spellID)
	if ( cooldownData[guid]["cooldowns"][spellID] ) then
		--ArenaLive:Message([[Remove Cooldown: %d for guid %s, cooldownData[guid]["cooldowns"][spellID] = %s ]], "debug", spellID, guid, tostring(cooldownData[guid]["cooldowns"][spellID]));
		
		dumpTable(cooldownData[guid]["cooldowns"][spellID]);
		cooldownData[guid]["cooldowns"][spellID] = nil;
		
		-- Remove from prio list:
		for index, prioSpellID in ipairs(cooldownData[guid].priorityList) do
			if ( spellID == prioSpellID ) then
				table.remove(cooldownData[guid].priorityList, index);
				break;
			end
		end
	end
end

function CooldownTracker:StartCooldown(guid, spellID, customDuration)
	if ( cooldownData[guid] and cooldownData[guid]["cooldowns"][spellID] ) then
		-- Set charges - 1:
		CooldownTracker:UpdateCooldownCharges(guid, spellID, -1, nil, customDuration);
	end
end

function CooldownTracker:UpdateCooldownCharges(guid, spellID, value, isFullRecharge, customDuration)
	
	local charges, totalCharges = cooldownData[guid]["cooldowns"][spellID].charges, cooldownData[guid]["cooldowns"][spellID].totalCharges;
	if ( isFullRecharge ) then
		charges = totalCharges;
	else
		charges = charges + value;
	end
	
	if ( charges > totalCharges ) then
		charges = totalCharges;
	elseif ( charges < 0 ) then
		charges = 0;
	end
	
	cooldownData[guid]["cooldowns"][spellID].charges = charges;
	
	-- Set new cooldown if necessary:
	if ( charges < totalCharges ) then
		local currExpire = cooldownData[guid]["cooldowns"][spellID].expires;
		local startTime = GetTime();
		local duration = customDuration or cooldownData[guid]["cooldowns"][spellID].duration;
		local expires = startTime + duration;
		if ( ( not currExpire or ( totalCharges == 1 and currExpire < expires ) ) ) then
			cooldownData[guid]["cooldowns"][spellID].expires = expires;
			activeCooldowns[guid..";"..spellID] = expires..";"..tostring(charges + 1);
			if ( not self:IsShown() ) then
				self:Show();
			end
		end
	end
	
end

function CooldownTracker:ResetCooldown(guid, spellID, isFullReset)
	if ( cooldownData[guid] and cooldownData[guid]["cooldowns"][spellID] ) then
		-- Reset cooldown data:
		cooldownData[guid]["cooldowns"][spellID].expires = nil;
		
		-- Update charges:
		CooldownTracker:UpdateCooldownCharges(guid, spellID, 1, isFullReset);
	end
end

function CooldownTracker:CallGatherForAll()
	for unit in pairs(trackedUnits) do
		CooldownTracker:GatherCooldownInfo(unit);
	end
end

function CooldownTracker:ResetAll()
	for tracker in pairs(trackers) do
		tracker:Reset();
	end
end

function CooldownTracker:GetInterruptOrDispelBySpec(specID)
	return ArenaLiveSpectator.SpellDB.SpecIDToDispelOrInterrupt[specID];
end

function CooldownTracker:OnEvent(event, ...)
	local unit = ...;
	--unit = ArenaLive:GetPetOwnerUnit(unit);
	
	if ( event == "AL_SPEC_PLAYER_UPDATE" and trackedUnits[unit] ) then
			for tracker in pairs(trackers) do
				if ( unit == tracker.unit ) then
					tracker:UpdateGUID();
				end
			end
	elseif ( event == "AL_SPEC_PLAYER_SPECIALIZATION_UPDATE" and trackedUnits[unit] ) then
		CooldownTracker:GatherCooldownInfo(unit);
	elseif ( event == "UNIT_SPELLCAST_SUCCEEDED" and self.currentStatusID ) then
		local spellID = select(5, ...);
		local guid = UnitGUID(unit);
		-- Dispels need to be filtered, because they only trigger when they dispel something.
		-- Their cooldown is, therefore, triggered by COMBAT_LOG_EVENT_UNFILTERED_SPELL_DISPEL
		if ( guid and cooldownData[guid] and unit == cooldownData[guid].unit and not ArenaLiveSpectator.SpellDB.Dispels[spellID] ) then
			-- Check for cooldown resets:
			if ( ArenaLive.spellDB.CooldownResets[spellID] ) then
				for resetID in pairs(ArenaLive.spellDB.CooldownResets[spellID]) do
					CooldownTracker:ResetCooldown(guid, resetID, true);
				end
			end
			
			-- Start cooldown:
			if ( cooldownData[guid]["cooldowns"][spellID] ) then
				CooldownTracker:StartCooldown(guid, spellID);
			end
			
			-- Check if there are shared CDs:
			if ( ArenaLiveSpectator.SpellDB.SharedCooldowns[spellID] ) then
				for sharedID, sharedDuration in pairs(ArenaLiveSpectator.SpellDB.SharedCooldowns[spellID]) do
					CooldownTracker:StartCooldown(guid, sharedID, sharedDuration);
				end
			end
			
			-- Update cooldown tracker frames after all changes have been applied:
			CooldownTracker:UpdateTrackersByUnit(unit);
		end
	elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED_SPELL_DISPEL" and self.currentStatusID ) then
		local spellID = select(12, ...);
		if ( ArenaLiveSpectator.SpellDB.Dispels[spellID] ) then
			local sourceGUID = select(4, ...);
			if ( unit and cooldownData[sourceGUID] and cooldownData[sourceGUID]["cooldowns"][spellID] ) then
				CooldownTracker:StartCooldown(sourceGUID, spellID);
			end
		end
	elseif ( event == "UPDATE_BATTLEFIELD_STATUS" ) then
		local statusID = ...;
		local status, mapName, teamSize, registeredMatch, suspendedQueue, queueType, gameType, role, unknown = GetBattlefieldStatus(statusID);
		local isSpectator, gameType = IsSpectator();
		if ( status == "active" and isSpectator and gameType == "arena" ) then
			self.currentStatusID = statusID;
			
			-- Wipe active cooldown cache, because CDs reset when joining the arena. 
			table.wipe(activeCooldowns);			
		elseif ( status == "none" and statusID == self.currentStatusID ) then
			for guid in pairs(cooldownData) do
				CooldownTracker:ResetCooldownTable(guid);
			end
			self:ResetAll();
			
			self.currentStatusID = nil;
		end
	end
end

local elapsedTillNow = 0;
local THROTTLE = 1.0;
function CooldownTracker:OnUpdate(elapsed)
	elapsedTillNow = elapsedTillNow + elapsed;
	if ( elapsedTillNow > THROTTLE ) then
		elapsedTillNow = 0;
		local theTime = GetTime();
		
		nextKey, nextValue = next(activeCooldowns);
		if ( nextKey ) then
			for identifier, expireInfo in pairs(activeCooldowns) do
				local expires, newCharges = string.split(";", expireInfo);
				expires = tonumber(expires);
				newCharges = tonumber(newCharges);
				if ( expires <= theTime ) then
					local guid, spellID = string.split(";", identifier);
					spellID = tonumber(spellID);
					activeCooldowns[identifier] = nil;
					CooldownTracker:ResetCooldown(guid, spellID);
					CooldownTracker:UpdateTrackersByGUID(guid);
				end
			end
		end
		
		if ( not nextKey ) then
			-- Hide frame so OnUpdate script won't be called any longer:
			ArenaLive:Message("Hiding CooldownTracker's handler frame...", "debug");
			self:Hide();
		end
	end
end
CooldownTracker:SetScript("OnUpdate", CooldownTracker.OnUpdate);

--[[
****************************************
******* CLASS METHODS START HERE *******
****************************************
]]--
function CooldownTrackerClass:Enable()
	self:Show();
	trackers[self] = true;
	self:Update();
	self:UpdatePositions();
	self.enabled = true;
end

function CooldownTrackerClass:Disable()
	self:UpdateUnit();
	self:Reset();
	self:Hide();
	self.enabled = false;
end

function CooldownTrackerClass:Update()
	
	local unit = self.unit;
	local guid = self.guid;
	if ( not self.enabled or not unit or not guid or not cooldownData[guid] ) then
		self:Reset();
		return;
	end
	
	self:Show();
	
	-- Set class icon:
	local class = cooldownData[guid].class;
	if ( self.classIcon and class ) then
		self.classIcon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes");
		self.classIcon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]));
	end
	
	-- Set talent spec icon:
	if ( self.specIcon ) then
		local specID = cooldownData[guid].specID
		if ( specID ) then
			local _, _, _, texture = GetSpecializationInfoByID(specID);
			self.specIcon:SetTexture(texture);
			self.specIcon:Show();
		else
			self.specIcon:Hide();
		end
	end
	
	-- Set name:
	local name = NameText:GetNickname(unit) or UnitName(unit);
	if ( self.nameText ) then
		self.nameText:SetText(name);
	end	
	
	-- Set Cooldown icons:
	local theTime = GetTime();
	for key, spellID in ipairs(self.shownCooldowns) do

		icon = self["icon"..key];
		if ( not icon ) then
			icon = CooldownTracker:ConstructIcon(self);
			self:UpdatePositions();
		end
		
		icon:Show();
		
		icon.spellID = spellID;
		icon.addon = self.addon;
		icon.group = self.group;

		-- Set Texture:
		if ( cooldownData[guid]["cooldowns"][spellID] ) then
			local texture = cooldownData[guid]["cooldowns"][spellID]["texture"] or [[Interface\Icons\INV_Misc_QuestionMark]];
			icon.texture:SetTexture(texture);
				
			-- Set number of charges:
			local charges, totalCharges = cooldownData[guid]["cooldowns"][spellID]["charges"], cooldownData[guid]["cooldowns"][spellID]["totalCharges"];
			if ( icon.count ) then
				if ( charges > 0 and totalCharges > 1 ) then
					icon.count:Show();
					icon.count:SetText(charges);
				else
					icon.count:Hide();
				end
			end
				
			-- Check for active cooldown:
			local expires = cooldownData[guid]["cooldowns"][spellID]["expires"];
			local duration = cooldownData[guid]["cooldowns"][spellID]["duration"];
			if ( expires and expires > theTime and charges == 0 ) then
				local startTime = expires - duration;
				icon.cooldown:Set(startTime, duration);
			else
				icon.cooldown:Reset();
			end
		else
			self:ResetIcon(icon);
		end
	end
	
	-- Reset empty icons:
	for i = #self.shownCooldowns + 1, self.numIcons do
		icon = self["icon"..i];
		self:ResetIcon(icon);
	end
end

function CooldownTrackerClass:UpdateShownCooldowns()
	local database = ArenaLive:GetDBComponent(self.addon, "CooldownTracker", self.group);
	local unit = self.unit;
	local guid = self.guid;
	
	-- Reset old entries:
	table.wipe(self.shownCooldowns);	
	
	if ( unit and guid and cooldownData[guid] ) then
		local specID = cooldownData[guid].specID;
		local i = 1;
		local spellsFound = 0;
		local numCooldowns = #cooldownData[guid].priorityList or 0;
		local _, race = UnitRace(unit);
		-- NOTE: Racials were removed from cooldown list in
		-- version 3.1.11b, to reduce ability bloat.
		--[[if ( race == "Human" and numCooldowns > 0 ) then
			-- BUGFIX: As I do filter Human's Racial below,
			-- I have to reduce numCooldowns by 1, otherwise
			-- the last cooldown in the list gets shown twice,
			-- if a player has less than 9 cooldowns.
			numCooldowns = numCooldowns - 1;
		end]]
		
		
		while ( spellsFound < database.MaxShownIcons ) do
			if ( spellsFound == database.MaxShownIcons - 1 or spellsFound == numCooldowns - 1 ) then
				-- The last cooldown always is either interrupt or dispel,
				-- depending on spec:
				local spellID = CooldownTracker:GetInterruptOrDispelBySpec(specID);
				spellsFound = spellsFound + 1;
				if ( spellID ) then
					self.shownCooldowns[spellsFound] = spellID;
				else
					self.shownCooldowns[spellsFound] = cooldownData[guid].priorityList[i];
				end
				
				break; -- Break loop to make sure that this one is the last cooldown in the list.
			else
				spellsFound = spellsFound + 1;
				self.shownCooldowns[spellsFound] = cooldownData[guid].priorityList[i];
			end
			
			i = i + 1;
		end
		self:Update();
	else
		self:Reset();
	end
end

function CooldownTrackerClass:UpdatePositions()
	local database = ArenaLive:GetDBComponent(self.addon, "CooldownTracker", self.group);
	
	local point, relativeTo, xSpace ,ySpace;
	if ( database.GrowingDirection == "UP" ) then
		point = "BOTTOM";
	elseif ( database.GrowingDirection == "RIGHT" ) then
		point = "LEFT";
	elseif ( database.GrowingDirection == "DOWN" ) then
		point = "TOP";
	elseif ( database.GrowingDirection == "LEFT" ) then
		point = "RIGHT";
	end
	
	local xOffset, yOffset = 0, 0;
	local icon, width, height;
	if ( self.classIcon ) then
		width, height = self.classIcon:GetSize();
		self.classIcon:ClearAllPoints();
		self.classIcon:SetPoint(point, self, point, xOffset, yOffset);
		
		xOffset, yOffset = CooldownTracker:GetNewOffset(self, width, height, xOffset, yOffset);
	end
	
	if ( self.nameText ) then
		width, height = self.nameText:GetSize();
		if ( database.GrowingDirection == "RIGHT" ) then
			self.nameText:SetJustifyH("LEFT")
		elseif ( database.GrowingDirection == "LEFT" ) then
			self.nameText:SetJustifyH("RIGHT")
		end
		
		self.nameText:ClearAllPoints();
		self.nameText:SetPoint(point, self, point, xOffset, yOffset);
		
		xOffset, yOffset = CooldownTracker:GetNewOffset(self, width, height, xOffset, yOffset);
	end
	
	for i = 1, self.numIcons do
		icon = self["icon"..i];
		width, height = icon:GetSize();
		
		icon:ClearAllPoints();
		icon:SetPoint(point, self, point, xOffset, yOffset);
		
		xOffset, yOffset = CooldownTracker:GetNewOffset(self, width, height, xOffset, yOffset);
	end
	
	-- Use this if you want to adjust cooldown tracker elements manually:
	if ( type(self.OnPositionUpdate) == "function" ) then
		self:OnPositionUpdate();
	end
end

function CooldownTrackerClass:Reset()
	
	if ( self.classIcon ) then
		self.classIcon:SetTexture();
	end
	
	if ( self.specIcon ) then
		self.specIcon:SetTexture();
	end	
	
	if ( self.nameText ) then
		self.nameText:SetText("");
	end
	
	local icon;
	for i = 1, self.numIcons do
		icon = self["icon"..i];
		self:ResetIcon(icon);
	end
	self:Hide();
end

function CooldownTrackerClass:ResetIcon(icon)
	icon.texture:SetTexture([[Interface\Icons\INV_Misc_QuestionMark]]);
	icon.cooldown:Reset();
	icon:Hide();
end

function CooldownTrackerClass:UpdateUnit(unit)
	if ( unit and unit ~= self.unit ) then
		if ( self.unit ) then
			CooldownTracker:UnregisterUnit(self.unit);
		end
		
		CooldownTracker:RegisterUnit(unit);
	elseif ( not unit and self.unit ) then
		CooldownTracker:UnregisterUnit(unit);
	end
	
	self.unit = unit;
	self:UpdateGUID();	
end

function CooldownTrackerClass:UpdateGUID()
	if ( not self.unit ) then
		self.guid = nil;
		return;
	end
	
	local guid = UnitGUID(self.unit);
	if ( guid ~= self.guid ) then
		self.guid = guid;
		if ( guid ) then
			self:UpdateShownCooldowns();
		else
			self:Reset();
		end
	end
end