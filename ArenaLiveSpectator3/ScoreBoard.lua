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
local TOTAL_MATCH_TIME = 25;

function ArenaLiveSpectatorScoreBoard:Initialise()
	local database = ArenaLive:GetDBComponent(addonName);
	local teamAr, teamAg, teamAb = unpack(database.TeamA.Colour);
	local teamBr, teamBg, teamBb = unpack(database.TeamB.Colour);
	
	self.leftTeam.group = "TeamA";
	self.rightTeam.group = "TeamB";
	
	-- Set Team Colours:
	self.scoreLeft:SetTextColor(teamAr, teamAg, teamAb);
	self.leftTeam.name:SetTextColor(teamAr, teamAg, teamAb);
	self.scoreRight:SetTextColor(teamBr, teamBg, teamBb);
	self.rightTeam.name:SetTextColor(teamBr, teamBg, teamBb);
	
	-- Set Texts:
	self:UpdateTeamName("TeamA");
	self:UpdateTeamScore("TeamA");
	self:UpdateTeamName("TeamB");
	self:UpdateTeamScore("TeamB");
	
	-- Set Scripts:
	self:RegisterForClicks("RightButtonUp");
	self:SetScript("OnClick", self.OnClick);
	
	ArenaLiveSpectatorScoreBoardDampeningIndicator.text = ArenaLiveSpectatorScoreBoardDampeningIndicatorText;
	ArenaLiveSpectatorScoreBoardDampeningIndicator.statusBar:SetMinMaxValues(0, 91);
	ArenaLiveSpectatorScoreBoardDampeningIndicator.statusBar:SetValue(0);
	ArenaLiveSpectatorScoreBoardDampeningIndicator.anim:SetScript("OnPlay", self.OnAnimationPlay);
	ArenaLiveSpectatorScoreBoardDampeningIndicator.anim:SetScript("OnFinished", self.OnAnimationFinished);
	ArenaLiveSpectatorScoreBoardDampeningIndicator.anim:SetScript("OnStop", self.OnAnimationFinished);
	ArenaLiveSpectatorScoreBoardDampeningIndicator:UpdateTournamentIcon();
	
	-- Toggle scoreboard:
	ArenaLiveSpectatorScoreBoard:Toggle();
end

function ArenaLiveSpectatorScoreBoard:Toggle()
	local database = ArenaLive:GetDBComponent(addonName);
	if ( database.ShowScoreBoard ) then
		self.enabled = true;
		self:Show();
	else
		self.enabled = false;
		self:Hide();
	end
end

function ArenaLiveSpectatorScoreBoard:OnClick(button, down)
	if ( button == "RightButton" and not down ) then
		if ( ArenaLiveSpectator.swapTeams ) then
			ArenaLiveSpectator.swapTeams = false;
		else
			ArenaLiveSpectator.swapTeams = true;
		end
		
		ArenaLiveSpectatorScoreBoard:UpdateTeamName("TeamA");
		ArenaLiveSpectatorScoreBoard:UpdateTeamName("TeamB");
		ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamA");
		ArenaLiveSpectatorScoreBoard:UpdateTeamScore("TeamB");
	end
end

function ArenaLiveSpectatorScoreBoard:Reset()
	self.timer:SetText("00:00");
	ArenaLiveSpectatorScoreBoardDampeningIndicator:Reset();
end

function ArenaLiveSpectatorScoreBoard:UpdateTeamName(team)
	local frame;
	if ( ( not ArenaLiveSpectator.swapTeams and team == "TeamA" ) or
		 ( ArenaLiveSpectator.swapTeams and team == "TeamB" ) ) then
		frame = self.leftTeam;
	elseif ( ( not ArenaLiveSpectator.swapTeams and team == "TeamB" ) or 
		   ( ArenaLiveSpectator.swapTeams and team == "TeamA" ) ) then
		frame = self.rightTeam;
	else
		ArenaLive:Message(L["%s: Invalid team %s. Use \"TeamA\"  or \"TeamB\""], "error", "ArenaLiveSpectatorScoreBoard:UpdateTeamName()", team);
	end
	
	if ( frame ) then
		local database = ArenaLive:GetDBComponent(addonName, nil, team);
		frame.name:SetText(database.Name);
	end
end

function ArenaLiveSpectatorScoreBoard:UpdateTeamScore(team)
	local text;
	if ( ( not ArenaLiveSpectator.swapTeams and team == "TeamA" ) or
		 ( ArenaLiveSpectator.swapTeams and team == "TeamB" ) ) then
		text = self.scoreLeft;
	elseif ( ( not ArenaLiveSpectator.swapTeams and team == "TeamB" ) or 
		   ( ArenaLiveSpectator.swapTeams and team == "TeamA" ) ) then
			text = self.scoreRight;
	else
		ArenaLive:Message(L["%s: Invalid team %s. Use \"TeamA\"  or \"TeamB\""], "error", "ArenaLiveSpectatorScoreBoard:UpdateTeamName()", team);
	end
	
	if ( text ) then
		local database = ArenaLive:GetDBComponent(addonName, nil, team);
		text:SetText(database.Score);
	end
end

function ArenaLiveSpectatorScoreBoard:Update()
	self:UpdateTeamName("TeamA");
	self:UpdateTeamName("TeamB");
	self:UpdateTeamScore("TeamA");
	self:UpdateTeamScore("TeamB");
end

function ArenaLiveSpectatorScoreBoard:OnAnimationPlay()
	ArenaLiveSpectatorScoreBoard.dampeningIndicator.icon:Show();
	ArenaLiveSpectatorScoreBoard.dampeningIndicator.text:Show();
	ArenaLiveSpectatorScoreBoard.dampeningIndicator.icon:SetAlpha(0);
	ArenaLiveSpectatorScoreBoard.dampeningIndicator.text:SetAlpha(1);
end

function ArenaLiveSpectatorScoreBoard:OnAnimationFinished(animation)
	ArenaLiveSpectatorScoreBoard.dampeningIndicator.vs:SetAlpha(0);
	ArenaLiveSpectatorScoreBoard.dampeningIndicator.icon:SetAlpha(1);
	ArenaLiveSpectatorScoreBoardDampeningIndicator.statusBar:Show();
end

function ArenaLiveSpectatorScoreBoard:UpdateTimer(minutes, seconds)
	if ( not minutes or not seconds ) then
		return;
	end
	
	self.timer:SetText(minutes..":"..seconds);
	
	local numberMin, numberSec = tonumber(minutes), tonumber(seconds);
	if ( numberMin < ( TOTAL_MATCH_TIME - 5 ) and ArenaLiveSpectator:HasMatchStarted() ) then
		ArenaLiveSpectatorScoreBoardDampeningIndicator:Update(numberMin, numberSec);
	end
end

function ArenaLiveSpectatorScoreBoardDampeningIndicator:GetCurrentColour(value)
	
	local r, g, b;
	local min, max = 0, 91;
	value = (value - min) / (max - min);
	if(value > 0.5) then
		r = 1.0;
		g = (1.0 - value) * 2;
	else
		r = value * 2;
		g = 1.0;
	end
	b = 0.0;
	
	return r, g, b;
end

function ArenaLiveSpectatorScoreBoardDampeningIndicator:Update(minutes, seconds)
	local r, g, b;
	local minutes = TOTAL_MATCH_TIME - minutes;
	if ( minutes >= 5 ) then
		seconds = 60 - seconds;
		minutes = minutes - 6;
		if ( minutes > 0 ) then
			local minToSec = minutes * 60;
			seconds = seconds + minToSec;
		end
		
		local stacks = ( 1 + math.floor(seconds / 10 ) );
		if ( not self.icon:IsShown() ) then
			self.anim:Play();
		end
		r, g, b = ArenaLiveSpectatorScoreBoardDampeningIndicator:GetCurrentColour(stacks);
		self.statusBar:SetValue(stacks);
		self.statusBar:SetStatusBarColor(r, g, b);
		self.text:SetTextColor(r, g, b);
		self.text:SetText("-"..tostring(stacks).."%");
	end
	
	
end

function ArenaLiveSpectatorScoreBoardDampeningIndicator:UpdateTournamentIcon()
	local database = ArenaLive:GetDBComponent(addonName);
	local vsTexture;
	if ( database.TournamentIcon and database.TournamentIcon ~= "" ) then
		vsTexture = "Interface\\AddOns\\ArenaLiveSpectator3\\TournamentIcons\\"..database.TournamentIcon;
	else
		vsTexture = "Interface\\AddOns\\ArenaLiveSpectator3\\Textures\\VersusText";
	end
	
	ArenaLiveSpectatorScoreBoardDampeningIndicator.vs:SetTexture(vsTexture);
end

function ArenaLiveSpectatorScoreBoardDampeningIndicator:Reset()
	self.icon:SetAlpha(0);
	self.icon:Hide();
	
	self.text:SetAlpha(0);
	self.text:Hide();
	
	self.vs:SetAlpha(1);
	self.vs:Show();
	
	self.statusBar:SetValue(0);
	self.statusBar:Hide();
end

