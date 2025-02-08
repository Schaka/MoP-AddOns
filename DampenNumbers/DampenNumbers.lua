local tooltip = CreateFrame("GameTooltip", "DampenNumbersToolTip", nil, "GameTooltipTemplate")
tooltip:SetOwner( WorldFrame, "ANCHOR_NONE" )

local function GetTooltipLines(tooltip)
	local textLines = {}
	local regions = {tooltip:GetRegions()}

	for _, r in ipairs(regions) do
		if r:IsObjectType("FontString") then
			table.insert(textLines, r:GetText())
		end
	end

	return textLines
end

hooksecurefunc("AuraButton_Update", function(buttonName, index, filter)

	local buffName = buttonName..index;
	local buff = _G[buffName];

	local name, rank, texture, count, debuffType, duration, expirationTime, _, _, shouldConsolidate, spellId = UnitAura("player", index, filter);
	if spellId == 110310 then
		tooltip:ClearLines()
		tooltip:SetUnitAura("player", index, filter);

		local lines = GetTooltipLines(tooltip)
		for _, line in pairs(lines) do
			local percent = string.match(line, "Healing effects received reduced by (%d+).*")
			if percent then
				buff.count:SetText(percent);
				buff.count:Show()
				return
			end
		end
	end
end)