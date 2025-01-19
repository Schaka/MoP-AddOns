--[[ ArenaLive Core Functions: Crowd Control Indicator Handler
Created by: Vadrak
Creation Date: 11.04.2014
Last Update: 27.04.2014
Used to create a indicator that shows current CC or important auras on the unit.
]]--

-- ArenaLive addon Name and localisation table:
local addonName, L = ...;

--[[
**************************************************
******* GENERAL HANDLER SET UP STARTS HERE *******
**************************************************
]]--
-- Create new Handler and register for aura event:
local CCIndicator = ArenaLive:ConstructHandler("CCIndicator", true);
CCIndicator.canToggle = true;
CCIndicator:RegisterEvent("UNIT_AURA", "UpdateCache");
CCIndicator:RegisterEvent("PLAYER_TARGET_CHANGED", "UpdateCache");
CCIndicator:RegisterEvent("PLAYER_FOCUS_CHANGED", "UpdateCache");

-- Create CC cache. This will be sorted by unitID and inside the unitID table by spellID:
local unitCCCache = {};

-- Variables for max buffs and debuffs:
local MAX_BUFFS = 40;
local MAX_DEBUFFS = 40;



--[[
****************************************
****** HANDLER METHODS START HERE ******
****************************************
]]--
function CCIndicator:ConstructObject (indicator, texture, cooldown, addonName)
	
	-- Add references:
	indicator.texture = texture;
	indicator.cooldown = cooldown;
	
	local width, height = indicator:GetSize();
	local parent = indicator:GetParent();
	if ( width == 0 and height == 0 and parent ) then
		-- BUGFIX: If size and height is 0, try to use parent's size, because it seems like SetAllPoints doesn't work for LUA created frames somehow:
		width, height = parent:GetSize();
		indicator:SetSize(width, height);
	end
	
	-- Set up cooldown (without frameType, as I want to store cooldown options per addon and not per frame type):
	ArenaLive:ConstructHandlerObject(cooldown, "Cooldown", addonName, indicator);
	
end

function CCIndicator:OnEnable (unitFrame)
	CCIndicator:Update(unitFrame);
end

function CCIndicator:OnDisable (unitFrame)
	CCIndicator:Reset(unitFrame);
end

function CCIndicator:Update (unitFrame)
	
	local unit = unitFrame.unit;
	local indicator = unitFrame[self.name];
	
	if ( not unit or not indicator.enabled ) then
		return;
	end
	
	local priority, highestID, highestPriority, highestExpires;
	local database = ArenaLive:GetDBComponent(unitFrame.addon, self.name);

	-- Update according to cache entries:
	if ( unitCCCache[unit] ) then
		-- Iterate through all cached CCs in order to find the most important one:
		for spellID, infoTable in pairs(unitCCCache[unit]) do
			priority = database.Priorities[infoTable["priorityType"]];
			if ( priority > 0 ) then
				if ( GetTime() > unitCCCache[unit][spellID]["expires"] ) then
					-- Important spell has run out already. Remove entry from cache:
					table.wipe(unitCCCache[unit][spellID]);
					unitCCCache[unit][spellID] = nil;
				elseif ( not highestPriority or priority > highestPriority or ( priority == highestPriority and unitCCCache[unit][spellID]["expires"] > highestExpires ) ) then
					highestExpires = unitCCCache[unit][spellID]["expires"];
					highestID = spellID;
					highestPriority = priority;
				end
			end
		end
		
		if ( highestID ) then
			local startTime = unitCCCache[unit][highestID]["expires"] - unitCCCache[unit][highestID]["duration"];
			indicator.texture:SetTexture(unitCCCache[unit][highestID]["texture"]);
			indicator.cooldown:Set(startTime, unitCCCache[unit][highestID]["duration"]);
			indicator:Show();
		else
			CCIndicator:Reset(unitFrame);
		end
		
	else
		CCIndicator:Reset(unitFrame);
	end
end

function CCIndicator:Reset(unitFrame)
	local indicator = unitFrame[self.name];
	indicator.texture:SetTexture();
	indicator.cooldown:Reset();
	indicator:Hide();
end

function CCIndicator:UpdateCache (event, unit, denyUpdate)
	
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		unit = "target";
	elseif ( event == "PLAYER_FOCUS_CHANGED" ) then
		unit = "focus";
	end

	-- Reset table if there is one:
	if ( unitCCCache[unit] ) then
		table.wipe(unitCCCache[unit]);
	end
	
	local _, texture, duration, expires, spellID, priorityType;
	
	-- Check Buffs:
	for i = 1, MAX_BUFFS, 1 do
		_, _, texture, _, _, duration, expires, _, _, _, spellID = UnitBuff(unit, i);
		
		if ( spellID ) then
			priorityType = ArenaLive.spellDB.CCIndicator[spellID];
			
			-- Found an important buff, store it in the cache:
			if ( priorityType ) then
				
				-- No cc was tracked for this unit until now. Create table for the new unit:
				if ( not unitCCCache[unit] ) then
					unitCCCache[unit] = {};
				end
				
				-- Update the cache if necessary:
				if ( not unitCCCache[unit][spellID] or ( unitCCCache[unit][spellID] and expires > unitCCCache[unit][spellID]["expires"] ) ) then
					
					if ( not unitCCCache[spellID] ) then
						unitCCCache[unit][spellID] = {};
					end
				
					unitCCCache[unit][spellID]["texture"] = texture;
					unitCCCache[unit][spellID]["duration"] = duration;
					unitCCCache[unit][spellID]["expires"] = expires;
					unitCCCache[unit][spellID]["priorityType"] = priorityType;
				end
			end
		else
			break;
		end
	end

	-- Check Debuffs:
	for i = 1, MAX_DEBUFFS, 1 do
		_, _, texture, _, _, duration, expires, _, _, _, spellID = UnitDebuff(unit, i);
		
		if ( spellID ) then
			priorityType = ArenaLive.spellDB.CCIndicator[spellID];
			
			-- Found an important buff, store it in the cache:
			if ( priorityType ) then
				
				-- No cc was tracked for this unit until now. Create table for the new unit:
				if ( not unitCCCache[unit] ) then
					unitCCCache[unit] = {};
				end
				
				-- Update the cache if necessary:
				if ( not unitCCCache[unit][spellID] or ( unitCCCache[unit][spellID] and expires > unitCCCache[unit][spellID]["expires"] ) ) then
					
					if ( not unitCCCache[spellID] ) then
						unitCCCache[unit][spellID] = {};
					end
				
					unitCCCache[unit][spellID]["texture"] = texture;
					unitCCCache[unit][spellID]["duration"] = duration;
					unitCCCache[unit][spellID]["expires"] = expires;
					unitCCCache[unit][spellID]["priorityType"] = priorityType;
				end
			end
		else
			break;
		end
	end
	
	-- Inform all affected cc indicators that something has changed:
	if ( not denyUpdate and ArenaLive:IsUnitInUnitFrameCache(unit) ) then
		for id in ArenaLive:GetAffectedUnitFramesByUnit(unit) do
			local unitFrame = ArenaLive:GetUnitFrameByID(id);
			if ( unitFrame[self.name] ) then
				CCIndicator:Update(unitFrame);
			end
		end
	end
end


--[[
****************************************
**** OPTION FRAME SETUP STARTS HERE ****
****************************************
]]--
CCIndicator.optionSets = {
	["Enable"] = {
		["type"] = "CheckButton",
		["title"] = L["Enable"],
		["tooltip"] = L["Enables the Crowd Control Indicator."],
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Enabled; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Enabled = newValue; end,
		["postUpdate"] = function (frame, newValue, oldValue) for id, unitFrame in ArenaLive:GetAllUnitFrames() do if ( unitFrame.addon == frame.addon and unitFrame.group == frame.group and unitFrame[CCIndicator.name] ) then unitFrame:ToggleHandler(CCIndicator.name); end end end,
	},
	["DefCD"] = {
		["type"] = "Slider",
		["title"] = L["Defensive Cooldowns"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.defCD; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.defCD = newValue; end,
	},
	["OffCD"] = {
		["type"] = "Slider",
		["title"] = L["Offensive Cooldowns"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.offCD; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.offCD = newValue; end,
	},
	["Stun"] = {
		["type"] = "Slider",
		["title"] = L["Stuns"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.stun; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.stun = newValue; end,
	},
	["Silence"] = {
		["type"] = "Slider",
		["title"] = L["Silences"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.silence; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.silence = newValue; end,
	},
	["CrowdControl"] = {
		["type"] = "Slider",
		["title"] = L["Crowd Control"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.crowdControl; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.crowdControl = newValue; end,
	},
	["Root"] = {
		["type"] = "Slider",
		["title"] = L["Roots"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.root; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.root = newValue; end,
	},
	["Disarm"] = {
		["type"] = "Slider",
		["title"] = L["Disarms"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.disarm; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.disarm = newValue; end,
	},
	["UsefulBuff"] = {
		["type"] = "Slider",
		["title"] = L["Useful Buffs"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.usefulBuffs; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.usefulBuffs = newValue; end,
	},
	["UsefulDebuff"] = {
		["type"] = "Slider",
		["title"] = L["Useful Debuffs"],
		["width"] = 150,
		["height"] = 17,
		["min"] = 0,
		["max"] = 10,
		["step"] = 1,
		["inputType"] = "NUMERIC",
		["GetDBValue"] = function (frame) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); return database.Priorities.usefulDebuffs; end,
		["SetDBValue"] = function (frame, newValue) local database = ArenaLive:GetDBComponent(frame.addon, frame.handler, frame.group); database.Priorities.usefulDebuffs = newValue; end,
	},
};
