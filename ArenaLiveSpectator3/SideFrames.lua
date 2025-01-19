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

local function initialiseSideFrame(frame, group)

	local prefix = frame:GetName();
	local id = frame:GetID();
	
	ArenaLive:ConstructHandlerObject(frame, "UnitFrame", addonName, group, "target", "target");
	
	frame.border = _G[prefix.."Border"];
	frame.background = _G[prefix.."Background"];
	frame:RegisterHandler(_G[prefix.."HealthBar"], "HealthBar", nil, _G[prefix.."HealthBarHealPredictionBar"], _G[prefix.."HealthBarAbsorbBar"], _G[prefix.."HealthBarAbsorbBarOverlay"], 32, _G[prefix.."HealthBarAbsorbBarFullHPIndicator"], nil, addonName, group);
	frame:RegisterHandler(_G[prefix.."PowerBar"], "PowerBar", nil, addonName, group);
	frame:RegisterHandler(_G[prefix.."Portrait"], "Portrait", nil, _G[prefix.."PortraitTexture"],  _G[prefix.."PortraitThreeD"], frame);
	--frame:RegisterHandler(_G[prefix.."Portrait"], "Portrait", nil, _G[prefix.."PortraitBackground"], _G[prefix.."PortraitTexture"],  _G[prefix.."PortraitThreeD"], frame);
	frame:RegisterHandler(_G[prefix.."PortraitCCIndicator"], "CCIndicator", nil, _G[prefix.."PortraitCCIndicatorTexture"], _G[prefix.."PortraitCCIndicatorCooldown"], addonName);
	frame:RegisterHandler(_G[prefix.."Name"], "NameText", nil, frame, true, true);
	frame:RegisterHandler(_G[prefix.."HealthBarText"], "HealthBarText", nil, frame);
	frame:RegisterHandler(_G[prefix.."PowerBarText"], "PowerBarText", nil, frame);
	frame:RegisterHandler(_G[prefix.."CastBar"], "CastBar", nil, _G[prefix.."CastBarIcon"], _G[prefix.."CastBarText"], _G[prefix.."CastBarShield"], _G[prefix.."CastBarAnimation"], _G[prefix.."CastBarAnimationFadeOut"], true, addonName, group);
	frame:RegisterHandler(_G[prefix.."CastHistory"], "CastHistory");
	frame:RegisterHandler(_G[prefix.."AuraFrame"], "Aura", nil, _G[prefix.."AuraFrameBuffFrame"], _G[prefix.."AuraFrameDebuffFrame"]);
	frame:RegisterHandler(_G[prefix.."MainTargetIndicator"], "MainTargetIndicator");
	frame:RegisterHandler(_G[prefix.."SpiritHealerFrame"], "SpiritHealerFrame");
	frame:RegisterHandler(_G[prefix.."RoleIcon"], "SpectatorRoleIcon");
end

function ArenaLiveSpectator:InitialiseSideFrames()
	for i = 1, 5 do
		local frame = _G["ALSPEC_LeftSideFramesFrame"..i];
		initialiseSideFrame(frame, "Left");
		
		frame = _G["ALSPEC_RightSideFramesFrame"..i];
		initialiseSideFrame(frame, "Right");
	end
end

function ArenaLiveSpectator:SetUpSideFrames(numPlayers)
	
	-- Enable and disable frames:
	local frame;
	for i = 1, 5 do
		if ( i <= numPlayers ) then
			frame = _G["ALSPEC_LeftSideFramesFrame"..i];
			self:UpdateSideFrameConstituents(frame);
			frame:Enable();
			frame:UpdateUnit("spectateda"..i);
			
			frame = _G["ALSPEC_RightSideFramesFrame"..i];
			self:UpdateSideFrameConstituents(frame)
			frame:Enable();
			frame:UpdateUnit("spectatedb"..i);
		else
			frame = _G["ALSPEC_LeftSideFramesFrame"..i];
			frame:Disable();
			
			frame = _G["ALSPEC_RightSideFramesFrame"..i];
			frame:Disable();
		end
	end
end

function ArenaLiveSpectator:UpdateSideFrameAppearance(frame)
	if ( not frame.unit or not frame.enabled ) then
		return;
	end
	local database = ArenaLive:GetDBComponent(addonName);
	
	if ( database.HideTargetFrames and UnitIsUnit(frame.unit, "target") ) then
		if ( not frame.hasTargetSize ) then
			frame:SetSize(237, 72);
			frame.background:SetTexture("Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\TargetFrameBackground");
			
			frame.border:SetSize(239, 75);
			frame.border:SetTexture("Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\SideFrameTargetBorder");
			
			frame.MainTargetIndicator:SetSize(240, 79);
			frame.MainTargetIndicator:SetTexture("Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\TargetIndicatorGlowLarge");
			
			if ( frame.group == "Left" ) then
				frame.background:SetTexCoord(0.037109375, 0.962890625, 0.2109375, 0.7734375);
				frame.border:SetTexCoord(0.037109375, 0.970703125, 0.22265625, 0.8046875);
				frame.MainTargetIndicator:SetTexCoord(0.0390625, 0.9765625, 0.18359375, 0.80078125);
			elseif ( frame.group == "Right" ) then
				frame.background:SetTexCoord(0.962890625, 0.037109375, 0.2109375, 0.7734375);
				frame.border:SetTexCoord(0.970703125, 0.037109375, 0.22265625, 0.8046875);
				frame.MainTargetIndicator:SetTexCoord(0.9765625, 0.0390625, 0.18359375, 0.80078125);
			end
			
			frame.HealthBar:SetWidth(165);
			frame.PowerBar:SetWidth(165);
		
			frame.hasTargetSize = true;
			frame:Update();
		end
	elseif ( frame.hasTargetSize ) then
		frame:SetSize(182, 72);
		frame.background:SetTexture("Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\SideFrameBackground");
		
		frame.border:SetSize(184, 75);
		frame.border:SetTexture("Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\SideFrameBorder");
		
		frame.MainTargetIndicator:SetSize(185, 79);
		frame.MainTargetIndicator:SetTexture("Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\TargetIndicatorGlow");
			
		if ( frame.group == "Left" ) then
			frame.background:SetTexCoord(0.140625, 0.8515625, 0.20703125, 0.76953125);
			frame.border:SetTexCoord(0.140625, 0.859375, 0.20703125, 0.7890625);
			frame.MainTargetIndicator:SetTexCoord(0.140625, 0.865234375, 0.18359375, 0.80078125);
		elseif ( frame.group == "Right" ) then
			frame.background:SetTexCoord(0.8515625, 0.140625, 0.20703125, 0.76953125);
			frame.border:SetTexCoord(0.859375, 0.140625, 0.20703125, 0.7890625);
			frame.MainTargetIndicator:SetTexCoord(0.865234375, 0.140625, 0.18359375, 0.80078125);
		end
		
		frame.HealthBar:SetWidth(110);
		frame.PowerBar:SetWidth(110);
		
		frame.hasTargetSize = nil;
		
		frame:Update();
	end
end

function ArenaLiveSpectator:UpdateSideFrameByUnit(unit, state)
	if ( not unit ) then
		return;
	end
	
	local unitType, unitNumber = string.match(unit, "^([a-z]+)([0-9]+)$");
	if ( unitType and unitNumber ) then
		local frame;
		if ( unitType == "spectateda" ) then
			frame = _G["ALSPEC_LeftSideFramesFrame"..unitNumber];
		elseif ( unitType == "spectatedb" ) then
			frame = _G["ALSPEC_RightSideFramesFrame"..unitNumber];
		end
		
		if ( frame ) then
			--ArenaLive:Message("Updating side frame GUID for frame %s. unit = %s, state = %s", "debug", tostring(frame:GetName()), unit, tostring(state));
			frame:UpdateGUID();
			if ( state ) then
				frame:Update();
			else
				frame:Reset();
			end
		end
	end
end

function ArenaLiveSpectator:UpdateSideFrames()
	local database = ArenaLive:GetDBComponent(addonName);
	local numPlayers = database.PlayMode;
	local frame;
	
	for i = 1, numPlayers do
		frame = _G["ALSPEC_LeftSideFramesFrame"..i];
		if ( frame.enabled ) then
			frame:UpdateGUID();
			frame:Update();
		end
		
		frame = _G["ALSPEC_RightSideFramesFrame"..i];
		if ( frame.enabled ) then
			frame:UpdateGUID();
			frame:Update();
		end
	end
end

function ArenaLiveSpectator:UpdateSideFrameConstituents(frame)
	local database = ArenaLive:GetDBComponent(frame.addon, nil, frame.group);
	
	-- Update cast bar and cast history states:
	frame:ToggleHandler("CastBar");
	frame:ToggleHandler("CastHistory");	
	
	-- Grow cast history upwards if castbar is disabled:
	if ( database.CastBar.Enabled ) then
		frame.CastHistory:SetSize(73, 18);
		if ( frame.group == "Left" and database.CastHistory.Direction == "UP" ) then
			database.CastHistory.Direction = "RIGHT";
		elseif ( frame.group == "Right" and database.CastHistory.Direction == "UP" ) then
			database.CastHistory.Direction = "LEFT";
		end
	else
		frame.CastHistory:SetSize(18, 73);
		if ( database.CastHistory.Direction ~= "UP" ) then
			database.CastHistory.Direction = "UP";
		end
	end
end

function ArenaLiveSpectator:UpdateAllSideFrameConstituents()
	local frame;
	for i = 1, 5 do
		frame = _G["ALSPEC_LeftSideFramesFrame"..i];
		ArenaLiveSpectator:UpdateSideFrameConstituents(frame);
		frame = _G["ALSPEC_RightSideFramesFrame"..i];
		ArenaLiveSpectator:UpdateSideFrameConstituents(frame);
	end
end