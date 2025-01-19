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

local NUMBER_TEX_COORDS_TABLE = {
	[0] = {0, 0.25, 0, 0.33203125};
	[1] = {0.25, 0.5, 0, 0.33203125};
	[2] = {0.5, 0.75, 0, 0.33203125};
	[3] = {0.75, 1, 0, 0.33203125};
	[4] = {0, 0.25, 0.33203125, 0.66406250};
	[5] = {0.25, 0.5, 0.33203125, 0.66406250};
	[6] = {0.5, 0.75, 0.33203125, 0.66406250};
	[7] = {0.75, 1, 0.33203125, 0.66406250};
	[8] = {0, 0.25, 0.66406250, 0.99609375};
	[9] = {0.25, 0.5, 0.66406250, 0.99609375};
};

function ArenaLiveSpectatorCountDown:SetTimer(seconds, totalTime)
	self.time = seconds;
	self.totalTime = totalTime;
	self:Show();
	if ( seconds >= 10 ) then
		ArenaLiveSpectatorCountDownDigitFrameAnimation:Stop();
		ArenaLiveSpectatorCountDownDigitFrame:Hide();
		
		ArenaLiveSpectatorCountDownStatusBar:SetMinMaxValues(0, self.totalTime);
		self:UpdateStatusBarValue();
		ArenaLiveSpectatorCountDownStatusBar:Show();
		self:SetScript("OnUpdate", self.OnUpdate);
	elseif ( seconds >= 0 ) then
		self:SetScript("OnUpdate", nil);
		ArenaLiveSpectatorCountDownStatusBar:Hide();
		
		ArenaLiveSpectatorCountDownDigitFrame:Show();
		ArenaLiveSpectatorCountDownDigitFrameAnimation:Play();
	else
		self:SetScript("OnUpdate", nil);
		self.time = nil;
		self.totalTime = nil;
		self:Hide();
	end
end

function ArenaLiveSpectatorCountDown:UpdateStatusBarValue()
	
	if ( not self.time or not self.totalTime ) then
		self:Hide();
		return;
	end
	
	local minutes, seconds = math.floor(self.time / 60), math.floor(self.time % 60);
	ArenaLiveSpectatorCountDownStatusBar:SetValue(self.time);
	ArenaLiveSpectatorCountDownStatusBarText:SetText(string.format(L["%d:%d"], minutes, seconds));
end

function ArenaLiveSpectatorCountDown:OnUpdate(elapsed)
	if ( self.time and self.time >= 10 ) then
		self.time = self.time - elapsed;
		ArenaLiveSpectatorCountDown:UpdateStatusBarValue();
	else
		self:SetScript("OnUpdate", nil);
		ArenaLiveSpectatorCountDownStatusBar:Hide();
		ArenaLiveSpectatorCountDownDigitFrame:Show();
		ArenaLiveSpectatorCountDownDigitFrameAnimation:Play();
	end
end

function ArenaLiveSpectatorCountDown:OnAnimationPlay()
	self.time = math.floor(self.time);
	ArenaLiveSpectatorCountDownDigitFrameTexture:SetTexCoord(unpack(NUMBER_TEX_COORDS_TABLE[self.time]));
	if ( self.time > 0 ) then
		PlaySoundKitID(25477, "SFX", false);
	end
	
end

function ArenaLiveSpectatorCountDown:OnAnimationFinished()
	if ( self.time > 0 ) then
		self.time = self.time - 1;
		ArenaLiveSpectatorCountDownDigitFrameAnimation:Play();
	else
		PlaySoundKitID(25478);
		self.time = nil;
		self.totalTime = nil;
		self:Hide();
	end
end