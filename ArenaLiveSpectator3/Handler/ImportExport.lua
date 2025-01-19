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
	________________________________________________________________________
	
	The Import and Export script was contributed by Jochen Taeschner.
]]

-- Create Handler:
local ImportExport = ArenaLive:ConstructHandler("ImportExport");

function ImportExport:TableToLuaData(t)
	if ( type(t) ~= "table" ) then
		ArenaLive:Message(L["%s: Usage %s"], "error", "ImportExport:TableToLuaData()", "ImportExport:TableToLuaData(table)");
	end
	
	local output = "\n{\n";
	local i = 0;

	for key, value in pairs(t) do
		if ( i > 0 ) then
			output = output .. ",\n";
		end

		if ( type(key) == "string" ) then
			output = output .. "[\"" .. key .. "\"] = ";
		else
             output = output .. "[" .. key .. "] = ";
		end

		if ( type(value) == "string" ) then
			output = output .. "\"" .. ImportExport:Escape(value) .."\"";
		elseif ( type(value) == "table" ) then
			output = output .. self:TableToLuaData(value);
		else
			output = output .. value;
		end

		i = i + 1;
	end
	
	output = output .. "\n}\n";

	return output;
end

-- this function takes lua code and executes it in an isolated environment
-- this environment is then returned, and variables set in the code via
-- varname = value
-- can then outside be addressed via emptyenv.varname or [returnvalue].varname
function ImportExport:LuaDataToTable(text)
	local func = assert(loadstring(text));
	--local smallenv = { format=format, tostring=tostring, getglobal=getglobal}
	local emptyenv = {};
	setfenv(func, emptyenv);
	func();

	return emptyenv;
end

function ImportExport:Escape(text)

	text = string.gsub(text, [[\]], [[\\]] );
	
	return text;
end