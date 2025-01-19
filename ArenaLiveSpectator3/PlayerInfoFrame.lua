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
local PlayerInfoFrame = ArenaLiveSpectatorPlayerInfoFrame;
local NameText = ArenaLive:GetHandler("NameText");
local NUM_TALENTS = 7;
local NUM_GLYPHS = 6;

function PlayerInfoFrame:Initialise ()
	self.title:SetText(L["Player Information"]);
	self.talentFrame.title:SetText(L["Talents:"])
	self.glyphFrame.title:SetText(L["Glyphs:"]);
	
	self:RegisterForDrag("LeftButton");
	
	
	self:SetScript("OnDragStart", self.OnDragStart)
	self:SetScript("OnDragStop", self.StopMovingOrSizing)
	self:SetScript("OnShow", self.OnShow);
	
	self:Update();
end

function PlayerInfoFrame:Update ()
	if ( self.unit ) then
		local name = NameText:GetNickname(self.unit) or UnitName(self.unit);
		local specID = ArenaLiveSpectator.UnitCache:GetUnitSpecialisation(self.unit);
		if ( name and specID ) then
			if ( self.waitingOnPlayerInfo ) then
				self.waitingOnPlayerInfo = nil;
				self:Show();
			end
			
			-- Set Title Frame:
			local db = ArenaLive:GetDBComponent(addonName);
			local _, _, _, _, teamID = ArenaLiveSpectator.UnitCache:GetUnitInfo(self.unit);
			local red, green, blue, alpha;
			if ( teamID == 1 ) then	
				red, green, blue, alpha = unpack(db.TeamA.Colour);
			elseif ( teamID == 0 ) then
				red, green, blue, alpha = unpack(db.TeamB.Colour);
			else
				red, green, blue, alpha = 1, 1, 1, 1;
			end
			
			self.titleFrame.playerName:SetText(name);
			self.titleFrame.playerName:SetTextColor(red, green, blue, alpha);
			
			local _, specName, _, specIcon = GetSpecializationInfoByID(specID)
			local className = UnitClass(self.unit);
			self.titleFrame.specAndClassName:SetText(string.format("%s %s", specName, className));
			SetPortraitToTexture(self.titleFrame.specIcon, specIcon);
			
			-- Set Talent Frame:
			for tier = 1, NUM_TALENTS do
				local button = self.talentFrame["talent"..tier];
				local talentID = ArenaLiveSpectator.UnitCache:GetUnitSelectedTalentByTier(self.unit, tier);
				if ( talentID ) then
					local _, name, icon = GetTalentInfoByID(talentID);
					button.talentID = talentID;
					button.name:SetText(name);
					button.icon:SetTexture(icon);
					button:Show();					
				else
					button:Hide();
				end
			end
			
			-- Set Glyph Frame:
			for slot = 1, NUM_GLYPHS do
				local button = self.glyphFrame["glyph"..slot];
				local glyphID = ArenaLiveSpectator.UnitCache:GetUnitSelectedGlyphBySlot(self.unit, slot);
				if ( glyphID ) then
					local name, _, icon = GetSpellInfo(glyphID);
					button.glyphID = glyphID;
					button.name:SetText(name);
					button.icon:SetTexture(icon);
					button:Show();
				else
					button:Hide();
				end
			end
		else
			self.waitingOnPlayerInfo = true;
			self:Hide();
		end
	else
		self:Hide();
	end
end

function PlayerInfoFrame:SetUnitAndShow (unit)
	self.unit = unit;
	if ( not self:IsShown() ) then
		self:Show();
	else
		self:Update();
	end
end

function PlayerInfoFrame:OnDragStart ()
	self:StartMoving();
	self:SetClampedToScreen(true);
end

function PlayerInfoFrame:OnShow ()
	self:Update();
end

-- This function is called by ArenaLiveSpectator's OnEvent() method,
-- if "AL_SPEC_PLAYER_SPECIALIZATION_UPDATE" fires.
function PlayerInfoFrame:OnPlayerSpecialisationUpdate(unit)
	if ( self:IsVisible() and unit == self.unit ) then
		if ( self.waitingOnUpdate ) then
			self.waitingOnPlayerInfo = nil;
			self:Show();
		end
	end
end