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
local RoleIcon = ArenaLive:ConstructHandler("SpectatorRoleIcon", true);
RoleIcon:RegisterEvent("AL_SPEC_PLAYER_SPECIALIZATION_UPDATE");

function RoleIcon:Update(unitFrame)
	local unit = unitFrame.unit;
	local roleIcon = unitFrame[self.name];
	if ( not unit ) then
		self:Reset(unitFrame);
		return;
	end

	local role = ArenaLiveSpectator.UnitCache:GetUnitRole(unit);
	if ( role == "HEALER" ) then
		roleIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES");
		roleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(role));
		roleIcon:Show();
	else
		self:Reset(unitFrame);
	end
end

function RoleIcon:Reset(unitFrame)
	local roleIcon = unitFrame[self.name];
	roleIcon:Hide();
end

function RoleIcon:OnEvent(event, ...)
	local unit = ...;
	if ( ArenaLive:IsUnitInUnitFrameCache(unit) ) then
		for id in ArenaLive:GetAffectedUnitFramesByUnit(unit) do
			local unitFrame = ArenaLive:GetUnitFrameByID(id);
			if ( unitFrame[self.name] ) then
				RoleIcon:Update(unitFrame);
			end
		end
	end
end