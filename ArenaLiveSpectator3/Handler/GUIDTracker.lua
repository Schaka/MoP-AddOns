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

local guidToUnit = {};
function ArenaLiveSpectator:RefreshGUIDs()

	local unit, guid;
	for i = 1, 5 do
		unit = "spectateda"..i;
		guid = UnitGUID(unit);
		if ( guid ) then
			guidToUnit[guid] = unit;
		end
		
		unit = "spectatedpeta"..i;
		guid = UnitGUID(unit);
		if ( guid ) then
			guidToUnit[guid] = unit;
		end

		unit = "spectatedb"..i;
		guid = UnitGUID(unit);
		if ( guid ) then
			guidToUnit[guid] = unit;
		end
		
		unit = "spectatedpetb"..i;
		guid = UnitGUID(unit);
		if ( guid ) then
			guidToUnit[guid] = unit;
		end
	end
end

function ArenaLiveSpectator:GetUnitByGUID(guid)
	return guidToUnit[guid];
end