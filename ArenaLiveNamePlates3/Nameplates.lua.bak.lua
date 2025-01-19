local addonName, L = ...;

local frames = {}
local Nameplate = ArenaLive:ConstructHandler("Nameplate", true, true);
Nameplate:RegisterEvent("UNIT_AURA", "UNIT_AURA");
Nameplate:RegisterEvent("PLAYER_TARGET_CHANGED", "UNIT_AURA");

local relevantUnits = {
	"target",
    "targettarget",
	"focus",
	"arena1",
	"arena2",
	"arena3",
    "arena4",
	"arena5",
	"party1",
	"party2",
	"party3",
	"party4",
	"party5",
    "party1target",
	"party2target",
	"party3target",
	"party4target",
	"party5target",
	"raid1",
	"raid2",
	"raid3",
	"raid4",
	"raid5",
    "raid6",
	"raid7",
	"raid8",
	"raid9",
	"raid10",
    "raid11",
	"raid12",
	"raid13",
	"raid14",
	"raid15",
    "raid1target",
	"raid2target",
	"raid3target",
	"raid4target",
	"raid5target",
    "raid6target",
	"raid7target",
	"raid8target",
	"raid9target",
	"raid10target",
    "raid11target",
	"raid12target",
	"raid13target",
	"raid14target",
	"raid15target",
    "mouseover",
    "mouseovertarget",
}


local numKids, lastupdate, i = 0, 0, 0
local WorldFrame = WorldFrame

local function setupNameplate(frame)
	local healthbar, nameframe = frame:GetChildren()
	if healthbar and nameframe then
		local threat, hpborder, highlightBorder, skullIcon, raidIcon, eliteIcon = healthbar:GetRegions()
		local health, castbar = healthbar:GetChildren()
		local name, name2, name3 = nameframe:GetRegions()

        if not frame.ccIndicator then
            local indicator = CreateFrame("Frame", nil, frame)
            indicator:SetPoint('TOP', frame, 0, 32)
            indicator:SetSize(48, 48)
            indicator.enabled = true

            local cooldown = CreateFrame("Cooldown", nil, indicator)
            cooldown.SetHideCountdownNumbers = function() end
            cooldown.SetSwipeColor = function() end
            cooldown.SetCooldown = function(self, startTime, duration)
                local remaining = duration - (GetTime() - startTime);
                self.remaining = remaining;
                self.elapsed = 0;
                if not self:IsShown() then
                    self:Show()
                end
            end
            cooldown.Set = function(self, startTime, duration)
                local remaining = duration - (GetTime() - startTime);
                self.remaining = remaining;
                self.elapsed = 0;
                if not self:IsShown() then
                    self:Show()
                end
            end

            local text = indicator:CreateFontString(nil, "OVERLAY", "ArenaLiveFont_CooldownText")
            text:SetAllPoints(indicator)
            cooldown.text = text

            local icon = indicator:CreateTexture(nil, "OVERLAY")
            icon:SetSize(48, 48)
            icon:SetAllPoints(indicator)

            ArenaLive:ConstructHandlerObject (indicator, "CCIndicator", icon, cooldown, "ArenaLiveUnitFrames3")

            frame.CCIndicator = indicator
            frame.addon = "ArenaLiveUnitFrames3"
        end

	end

end

local function updateNameplate(frame)
    
    local inInstance, instanceType = IsInInstance()

    local healthbar, nameframe = frame:GetChildren()
	if healthbar and nameframe then
		local threat, hpborder, highlightBorder, skullIcon, raidIcon, eliteIcon = healthbar:GetRegions()
		local health, castbar = healthbar:GetChildren()
		local name, name2, name3 = nameframe:GetRegions()

        local namePlateName = name:GetText()
        local CCIndicator = ArenaLive:GetHandler("CCIndicator")

        -- don't show outside of PvP areas
        if frame.CCIndicator and not (instanceType == "pvp" or instanceType == "arena") then
            CCIndicator:Reset(frame)
            return
        end 

        for k, unit in pairs(relevantUnits) do
            if UnitName(unit) == name:GetText() then

                if not frame.CCIndicator then
                    setupNameplate(frame)
                end

                local indicator = frame.CCIndicator
                frame.unit = unit
    
                -- hackfix, but what can you do?
                CCIndicator:UpdateCache("UNIT_AURA", unit, true)
                CCIndicator:Update(frame); -- manual update, so we don't spam update all other CCIndicators for this unit, like target etc
                return
            end
        end
        
        if frame.CCIndicator then
            CCIndicator:Reset(frame)
        end
    
	end

end

Nameplate:SetScript("OnUpdate", function(self, elapsed)
	lastupdate = lastupdate + elapsed

	if lastupdate > 0.1 then

		for i=1, WorldFrame:GetNumChildren() do
            local frame = select(i, WorldFrame:GetChildren())
    
            local frame_name = frame:GetName()
    
            if frame:IsShown() and ( frame_name and frame_name:sub(1,9) == "NamePlate" ) then
                local healthbar, nameframe = frame:GetChildren()
    
                if healthbar and nameframe then
                    updateNameplate(frame)                    
                end   
    
            end
        end

		lastupdate = 0
	end

end)

function Nameplate:UNIT_AURA(event, unit)

    if event == "PLAYER_TARGET_CHANGED" then
        event = "UNIT_AURA"
        unit = "target"
    end    

    for i=1, WorldFrame:GetNumChildren() do
		local frame = select(i, WorldFrame:GetChildren())

		local frame_name = frame:GetName()

		if frame:IsShown() and ( frame_name and frame_name:sub(1,9) == "NamePlate" ) then
            local healthbar, nameframe = frame:GetChildren()

            if healthbar and nameframe then
                local name, name2, name3 = nameframe:GetRegions()

                if UnitName(unit) == name:GetText() and frame.CCIndicator then
                    local indicator = frame.CCIndicator
                    frame.unit = unit

                    local CCIndicator = ArenaLive:GetHandler("CCIndicator")
                    CCIndicator:UpdateCache("UNIT_AURA", unit)
                end    
            end   

        end
	end
end