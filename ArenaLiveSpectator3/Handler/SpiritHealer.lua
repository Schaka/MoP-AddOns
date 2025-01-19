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
local SpiritHealerFrame = ArenaLive:ConstructHandler("SpiritHealerFrame", true, true);
SpiritHealerFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
SpiritHealerFrame:RegisterEvent("AL_SPEC_PLAYER_UPDATE");

local playerStates = {};

local function OnAnimStop(animation)
	local frame = animation:GetParent();
	frame.flash:Hide();
end

function SpiritHealerFrame:ConstructObject(spiritHealerFrame)
	spiritHealerFrame.fadeOutAnim:SetScript("OnFinished", OnAnimStop);
	spiritHealerFrame.fadeOutAnim:SetScript("OnStop", OnAnimStop);
end

function SpiritHealerFrame:UpdateNumPlayers()
	local numTeamA = ArenaLiveSpectator.UnitCache:GetNumPlayers(1);
	local numTeamB = ArenaLiveSpectator.UnitCache:GetNumPlayers(2);
	local iMax
	if ( numTeamA > numTeamB ) then
		iMax = numTeamA;
	else
		iMax = numTeamB;
	end
	
	for i = 1, iMax do
		local unit = "spectateda"..i;
		if ( i <= numTeamA ) then
			playerStates[unit] = ValueToBoolean(UnitIsDeadOrGhost(unit));
		else
			playerStates[unit] = nil;
		end
		
		unit = "spectatedb"..i;
		if ( i <= numTeamB ) then
			playerStates[unit] = ValueToBoolean(UnitIsDeadOrGhost(unit));
		else
			playerStates[unit] = nil;
		end
	end
	
	-- Show/Hide frame to enable/disable OnUpdate script;
	if ( numTeamA > 0 or numTeamB > 0 ) then
		self:Show();
	else
		self:Hide();
	end
end

function SpiritHealerFrame:Update(unitFrame)
	local unit = unitFrame.unit;
	local frame = unitFrame[self.name];
	
	if ( not unit or not playerStates[unit] ) then
		self:Reset(unitFrame);
	elseif ( not frame:IsShown() ) then
		frame:Show();
		frame.flash:SetAlpha(1);
		frame.flash:Show();
		frame.texture:Show();
		frame.fadeOutAnim:Play();
	end
end

function SpiritHealerFrame:Reset(unitFrame)
	local unit = unitFrame.unit;
	local frame = unitFrame[self.name];
	
	if ( frame.fadeOutAnim:IsPlaying() ) then
		frame.fadeOutAnim:Stop();
	end
	
	frame:Hide();
end

function SpiritHealerFrame:OnEvent(event, ...)
	SpiritHealerFrame:UpdateNumPlayers();
end

function SpiritHealerFrame:CallUpdateForUnit(unit)
	if ( ArenaLive:IsUnitInUnitFrameCache(unit) ) then
		for id in ArenaLive:GetAffectedUnitFramesByUnit(unit) do
			local unitFrame = ArenaLive:GetUnitFrameByID(id);
			if ( unitFrame and unitFrame[self.name] ) then
				self:Update(unitFrame);
			end
		end
	end
end

local THROTTLE, elapsedTilNow = 0.1, 0;
function SpiritHealerFrame:OnUpdate(elapsed)
	elapsedTilNow = elapsedTilNow + elapsed;
	if ( elapsedTilNow >= THROTTLE ) then
		elapsedTilNow = 0;
		for unit, isDeadOrGhost in pairs(playerStates) do
			local name = GetSpellInfo(5384)
			local feignDeath = UnitBuff(unit, name);
			local newState = ValueToBoolean((UnitIsDeadOrGhost(unit) and not UnitBuff(unit, name)));
			if ( newState ~= isDeadOrGhost ) then
				playerStates[unit] = newState;
				SpiritHealerFrame:CallUpdateForUnit(unit);
			end
		end
	end
end

SpiritHealerFrame:SetScript("OnUpdate", SpiritHealerFrame.OnUpdate);