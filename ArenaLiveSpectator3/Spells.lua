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

ArenaLiveSpectator.SpellDB = {
	["Dispels"] = { -- Dispels only trigger their cooldown when actively dispelling something.
					-- In Order to account for that in the cooldown tracker I need a fast way
					-- to know which spell is a dispel and which one is not.
		[2782] = "Druid: Remove Corruption",
		[88423] = "Druid: Nature's Cure",
		[115450] = "Monk: Detox",
		[4987] = "Paladin: Cleanse",
		[527] = "Priest: Purify",
		[51886] = "Shaman: Cleanse Spirit",
		[77130] = "Shaman: Purify Spirit",
	},
	["Resurrects"] = {
		[50769] = "Revive (Druid)",
		[115178] = "Resuscitate (Monk)",
		[7328] = "Redemption (Paladin)",
		[2006] = "Resurrection (Priest)",
		[2008] = "Ancestral Spirit (Shaman)",
	},
	["SharedCooldowns"] = {
		[42292] = { -- PvP-Insignia
			[59752] = 120,			-- Human Racial
			[7744] = 30,			-- Will of the Forsaken
		},
		[59752] = { -- Human Racial
			[42292] = 120,			-- PvP-Insignia
		},
		[7744] = { -- Will of the Forsaken
			[42292] = 30,			-- PvP-Insignia
		},
		[48505] = { -- Starfall
			[78674] = 30,	-- Starsurge
		},
		[78674] = { -- Starsurge
			[48505] = 30,	-- Starfall
		},
		[60192] = { -- Freezing Trap: Trap Launcher
			[1499] = 30,
		},
		[2062] = { -- Earth Elemental Totem
			[2894] = 500,		-- Fire Elemental Totem
			[152256] = 500,		-- Storm Elemental Totem
		},
		[2894] = { -- Fire Elemental Totem
			[2062] = 500,		-- Earth Elemental Totem
			[152256] = 500,		-- Storm Elemental Totem
		},
		[152256] = { -- Storm Elemental Totem
			[2062] = 500,		-- Earth Elemental Totem
			[2894] = 500,		-- Fire Elemental Totem
		},
		[119911] = { -- Optical Blast
			[132409] = 24,				-- Spell lock (Warlock)
		},
		[171140] = { -- Shadowlock
			[132409] = 24,				-- Spell lock (Warlock)
		},
		[119910] = { -- Spell lock
			[132409] = 24,				-- Spell lock (Warlock)
		},
	},
	["CooldownPriorities"] = {
		-- Trinket:
		[42292] = 100,

		-- Racial Abilities:
		--   NOTE: 3.1.12b brought back the important racials.
		--[59752] = 99,		-- Human	
		[20594] = 99,		-- Dwarf
		--[58984] = 99,		-- Night Elf
		--[20589] = 99,		-- Gnome
		--[28880] = 99,		-- Draenei
		--[59542] = 99,
		--[59543] = 99,
		--[59544] = 99,
		--[59545] = 99,
		--[59547] = 99,
		--[59548] = 99,
		--[121093] = 99,
		--[68992] = 99,		-- Worgen
		[20572] = 99,		-- Orc
		[33697] = 99,
		[33702] = 99,
		[7744] = 99,		-- Undead
		--[20549] = 99,		-- Tauren
		[26297] = 99,		-- Troll
		--[69179] = 99,		-- Blood Elf
		--[28730] = 99,
		--[80483] = 99,
		--[25046] = 99,
		--[50613] = 99,
		--[129597] = 99,
		--[69070] = 99,		-- Goblin
		--[107079] = 99,		-- Pandaren
		
		["DEATHKNIGHT"] = {
			[0] = { -- Unskilled
				[47568] = 24,		-- Empowered Rune Weapon
				[48792] = 23,		-- Icbound Fortitude
				[49206] = 22,		-- Summon Gargoyle
				[51052] = 21,		-- Anti-Magic Zone
				[49039] = 20,		-- Lich Borne
				[48743] = 19,		-- Death Pact
				[152279] = 18,		-- Breath of Sindragosa
				[108201] = 17,		-- Desecrated Ground
				[49222] = 16,		-- Bone Shield
				[49028] = 15,		-- Dancing Rune Weapon
				[51271] = 14,		-- Pillar of Frost
				[55233] = 14,		-- Vampiric Blood
				[48707] = 13,		-- Anti-Magic Shell
				[48982] = 12,		-- Rune Tap
				[108194] = 11,		-- Asphyxiate
				[47476] = 11,		-- Strangulate
				[115989] = 10,		-- Unholy Blight
				[108199] = 9,		-- Gorefiend's Grasp
				[108200] = 8,		-- Remorsless Winter
				[77575] = 7,		-- Outbreak
				[77606] = 6,		-- Dark Simulacrum
				[43265] = 5,		-- Death and Decay
				[96268] = 4,		-- Death's Advance
				[152280] = 3,		-- Defile
				[49576] = 3,		-- Death Grip
				[123693] = 2,		-- Plague Leech
				[47528] = 1,		-- Mind Freeze
			},
			[250] = { -- Blood
				[47568] = 24,		-- Empowered Rune Weapon
				[48792] = 23,		-- Icbound Fortitude
				[49206] = 22,		-- Summon Gargoyle
				[51052] = 21,		-- Anti-Magic Zone
				[49039] = 20,		-- Lich Borne
				[48743] = 19,		-- Death Pact
				[152279] = 18,		-- Breath of Sindragosa
				[108201] = 17,		-- Desecrated Ground
				[49222] = 16,		-- Bone Shield
				[49028] = 15,		-- Dancing Rune Weapon
				[51271] = 14,		-- Pillar of Frost
				[55233] = 14,		-- Vampiric Blood
				[48707] = 13,		-- Anti-Magic Shell
				[48982] = 12,		-- Rune Tap
				[108194] = 11,		-- Asphyxiate
				[47476] = 11,		-- Strangulate
				[115989] = 10,		-- Unholy Blight
				[108199] = 9,		-- Gorefiend's Grasp
				[108200] = 8,		-- Remorsless Winter
				[77575] = 7,		-- Outbreak
				[77606] = 6,		-- Dark Simulacrum
				[43265] = 5,		-- Death and Decay
				[96268] = 4,		-- Death's Advance
				[152280] = 3,		-- Defile
				[49576] = 3,		-- Death Grip
				[123693] = 2,		-- Plague Leech
				[47528] = 1,		-- Mind Freeze
			},
			[251] = { -- Frost
				[48792] = 24,		-- Icbound Fortitude
				[48743] = 23,		-- Death Pact
				[51271] = 22,		-- Pillar of Frost
				[48707] = 21,		-- Anti-Magic Shell
				[108194] = 20,		-- Asphyxiate
				[47476] = 20,		-- Strangulate
				[51052] = 19,		-- Anti-Magic Zone
				[49039] = 18,		-- Lich Borne
				[152279] = 17,		-- Breath of Sindragosa
				[108201] = 16,		-- Desecrated Ground
				[49222] = 15,		-- Bone Shield
				[49028] = 14,		-- Dancing Rune Weapon
				[55233] = 13,		-- Vampiric Blood
				[48982] = 12,		-- Rune Tap
				[115989] = 11,		-- Unholy Blight
				[108199] = 10,		-- Gorefiend's Grasp
				[108200] = 9,		-- Remorsless Winter
				[77575] = 8,		-- Outbreak
				[77606] = 7,		-- Dark Simulacrum
				[43265] = 6,		-- Death and Decay
				[96268] = 5,		-- Death's Advance
				[152280] = 4,		-- Defile
				[49576] = 4,		-- Death Grip
				[123693] = 3,		-- Plague Leech
				[47568] = 2,		-- Empowered Rune Weapon
				[47528] = 1,		-- Mind Freeze
			},
			[252] = { -- Unholy
				[48792] = 24,		-- Icebound Fortitude
				[48743] = 23,		-- Death Pact
				[48707] = 22,		-- Anti-Magic Shell
				[49206] = 21,		-- Summon Gargoyle
				[51052] = 20,		-- Anti-Magic Zone
				[108194] = 19,		-- Asphyxiate
				[47476] = 19,		-- Strangulate
				[49039] = 18,		-- Lich Borne
				[152279] = 17,		-- Breath of Sindragosa
				[108201] = 16,		-- Desecrated Ground
				[49222] = 15,		-- Bone Shield
				[49028] = 14,		-- Dancing Rune Weapon
				[51271] = 13,		-- Pillar of Frost
				[55233] = 13,		-- Vampiric Blood
				[48982] = 12,		-- Rune Tap
				[115989] = 11,		-- Unholy Blight
				[108199] = 10,		-- Gorefiend's Grasp
				[108200] = 9,		-- Remorsless Winter
				[77575] = 8,		-- Outbreak
				[77606] = 7,		-- Dark Simulacrum
				[43265] = 6,		-- Death and Decay
				[96268] = 5,		-- Death's Advance
				[152280] = 4,		-- Defile
				[49576] = 4,		-- Death Grip
				[123693] = 3,		-- Plague Leech
				[47568] = 2,		-- Empowered Rune Weapon
				[47528] = 1,		-- Mind Freeze
			},
		},
		["DRUID"] = {
			[0] = {
				[108291] = 29,		-- Heart of the Wild: Balance
				[108292] = 29,		-- Heart of the Wild: Feral
				[108293] = 29,		-- Heart of the Wild: Guardian
				[108294] = 29,		-- Heart of the Wild: Restoration
				[740] = 28,			-- Tranquility
				[61336] = 27,		-- Survival Insticts
				[102560] = 26,		-- Incarnation: Chosen of Elune
				[102543] = 26,		-- Incarnation: King of the Jungle
				[102558] = 26,		-- Incarnation: Son of Ursoc
				[33891] = 26,		-- Incarnation: Tree of Life
				[106951] = 25,		-- Berserk (Feral)
				[50334] = 24,		-- Berserk (Guardian?)
				[112071] = 23,		-- Celestial Alignment
				[108238] = 22,		-- Renewal
				[102342] = 21,		-- Iron Bark
				[22812] = 20,		-- Bark Skin
				[132158] = 19,		-- Nature's Swiftness
				[78675] = 18,		-- Solar Beam
				[102793] = 17,		-- Ursol's Vortex
				[5211] = 16,		-- Mighty Bash
				[99] = 15,			-- Incapacitating Shout
				[102359] = 14,		-- Mass Entanglement
				[132469] = 14,		-- Typhoon
				[1850] = 13,		-- Dash
				[106898] = 12,		-- Stampeding Roar
				[102280] = 11,		-- Displacer Beast
				[102351] = 10,		-- Cenarion Ward
				[5217] = 9,			-- Tiger's Fury
				[48505] = 8,		-- Starfall
				[78674] = 7,		-- Starsurge
				[102693] = 6,		-- Force of Nature
				[62606] = 5,		-- Savage Defense
				[18562] = 4,		-- Swiftmend
				[132302] = 3,		-- Wild Charge
				[48438] = 2,		-- Wild Growth		
				[88423] = 1,		-- Nature's Cure
				[106839] = 1,		-- Skull Bash
				[2782] = 1,			-- Remove Corruption
			},
			[102] = { -- Balance
				[22812] = 17,		-- Bark Skin
				[108291] = 16,		-- Heart of the Wild: Balance
				[102560] = 15,		-- Incarnation: Chosen of Elune
				[112071] = 14,		-- Celestial Alignment
				[5211] = 13,		-- Mighty Bash
				[102793] = 13,		-- Ursol's Vortex
				[99] = 13,			-- Incapacitating Roar
				[108238] = 12,		-- Renewal
				[102359] = 11,		-- Mass Entanglement
				[132469] = 10,		-- Typhoon
				[1850] = 9,			-- Dash
				[106898] = 8,		-- Stampeding Roar
				[102280] = 7,		-- Displacer Beast
				[102351] = 6,		-- Cenarion Ward
				[48505] = 5,		-- Starfall
				[78674] = 4,		-- Starsurge
				[102693] = 3,		-- Force of Nature
				[132302] = 2,		-- Wild Charge	
				[78675] = 1,		-- Solar Beam
				[2782] = 1,			-- Remove Corruption
			},
			[103] = { -- Feral
				[61336] = 16,		-- Survival Insticts
				[108292] = 15,		-- Heart of the Wild: Feral
				[102543] = 14,		-- Incarnation: King of the Jungle
				[106951] = 13,		-- Berserk (Feral)
				[5211] = 12,		-- Mighty Bash
				[102793] = 12,		-- Ursol's Vortex
				[99] = 12,			-- Incapacitating Shout
				[108238] = 11,		-- Renewal
				[102359] = 10,		-- Mass Entanglement
				[132469] = 9,		-- Typhoon
				[1850] = 8,			-- Dash
				[106898] = 7,		-- Stampeding Roar
				[102280] = 6,		-- Displacer Beast
				[102351] = 5,		-- Cenarion Ward
				[5217] = 4,			-- Tiger's Fury
				[102693] = 3,		-- Force of Nature
				[132302] = 2,		-- Wild Charge	
				[106839] = 1,		-- Skull Bash
				[2782] = 1,			-- Remove Corruption
			},
			[104] = { -- Guardian
				[61336] = 18,		-- Survival Insticts
				[22812] = 17,		-- Bark Skin
				[108293] = 16,		-- Heart of the Wild: Guardian
				[102558] = 15,		-- Incarnation: Son of Ursoc
				[50334] = 14,		-- Berserk (Guardian)
				[5211] = 13,		-- Mighty Bash
				[102793] = 13,		-- Ursol's Vortex
				[99] = 13,			-- Incapacitating Shout
				[108238] = 11,		-- Renewal
				[102359] = 10,		-- Mass Entanglement
				[132469] = 9,		-- Typhoon
				[1850] = 8,			-- Dash
				[106898] = 7,		-- Stampeding Roar
				[102280] = 6,		-- Displacer Beast
				[102351] = 5,		-- Cenarion Ward
				[102693] = 4,		-- Force of Nature
				[62606] = 3,		-- Savage Defense
				[132302] = 2,		-- Wild Charge		
				[106839] = 1,		-- Skull Bash	
				[2782] = 1,			-- Remove Corruption
			},
			[105] = { -- Resto
				[102342] = 20,		-- Iron Bark
				[22812] = 19,		-- Bark Skin
				[108294] = 18,		-- Heart of the Wild: Restoration
				[33891] = 17,		-- Incarnation: Tree of Life
				[132158] = 16,		-- Nature's Swiftness
				[5211] = 15,		-- Mighty Bash
				[102793] = 15,		-- Ursol's Vortex
				[99] = 15,			-- Incapacitating Shout
				[740] = 14,			-- Tranquility
				[108238] = 13,		-- Renewal
				[102359] = 12,		-- Mass Entanglement
				[132469] = 11,		-- Typhoon
				[1850] = 10,		-- Dash
				[106898] = 9,		-- Stampeding Roar
				[102280] = 8,		-- Displacer Beast
				[102351] = 7,		-- Cenarion Ward
				[102693] = 6,		-- Force of Nature
				[62606] = 5,		-- Savage Defense
				[18562] = 4,		-- Swiftmend
				[132302] = 3,		-- Wild Charge
				[48438] = 2,		-- Wild Growth		
				[88423] = 1,		-- Nature's Cure
			},
		},		
		["HUNTER"] = {
			[0] = { -- Unskilled
				[121818] = 24,		-- Stampede
				[19263] = 23,		-- Deterrence
				[148467] = 22,		-- Deterrence (Crouching Tiger, Hidden Chimaera)
				[109304] = 21,		-- Exhilaration
				[3045] = 20,		-- Rapid Fire
				[131894] = 19,		-- A Murder of Crows
				[19574] = 18,		-- Bestial Wrath
				[19577] = 17,		-- Intimidation
				[53271] = 16,		-- Master's Call
				[53480] = 15,		-- Roar of Sacrifice
				[109248] = 14,		-- Binding Shot
				[19386] = 14,		-- Wyvern Sting
				[120679] = 13,		-- Dire Beast
				[1499] = 12,		-- Freezing Trap
				[51753] = 10,		-- Camouflage
				[109259] = 9,		-- Power Shot
				[120360] = 9,		-- Barrage
				[5384] = 8,			-- Feign Death
				[13813] = 7,		-- Explosive Trap
				[13809] = 6,		-- Ice Trap
				[3674] = 5,			-- Black Arrow	
				[781] = 3,			-- Disengage
				[117050] = 2,		-- Glaive Toss		
				[147362] = 1,		-- Counter Shot
			},
			[253] = { -- Beast Mastery
				[19263] = 20,		-- Deterrence
				[148467] = 19,		-- Deterrence (Crouching Tiger, Hidden Chimaera)
				[109304] = 18,		-- Exhilaration
				[53480] = 17,		-- Roar of Sacrifice
				[121818] = 16,		-- Stampede
				[131894] = 16,		-- A Murder of Crows
				[109248] = 15,		-- Binding Shot
				[19386] = 15,		-- Wyvern Sting
				[1499] = 14,		-- Freezing Trap
				[19574] = 13,		-- Bestial Wrath
				[19577] = 12,		-- Intimidation
				[53271] = 11,		-- Master's Call
				[120679] = 10,		-- Dire Beast
				[51753] = 9,		-- Camouflage
				[109259] = 8,		-- Power Shot
				[120360] = 7,		-- Barrage
				[5384] = 6,			-- Feign Death
				[13813] = 5,		-- Explosive Trap
				[13809] = 4,		-- Ice Trap
				[781] = 3,			-- Disengage
				[117050] = 2,		-- Glaive Toss		
				[147362] = 1,		-- Counter Shot
			},
			[254] = { -- Marksmanship
				[19263] = 21,		-- Deterrence
				[148467] = 20,		-- Deterrence (Crouching Tiger, Hidden Chimaera)
				[109304] = 19,		-- Exhilaration
				[53480] = 18,		-- Roar of Sacrifice
				[121818] = 17,		-- Stampede
				[3045] = 16,		-- Rapid Fire
				[131894] = 15,		-- A Murder of Crows
				[109248] = 14,		-- Binding Shot
				[19386] = 14,		-- Wyvern Sting
				[1499] = 14,		-- Freezing Trap
				[19577] = 12,		-- Intimidation
				[53271] = 11,		-- Master's Call
				[120679] = 10,		-- Dire Beast
				[51753] = 9,		-- Camouflage
				[109259] = 8,		-- Power Shot
				[5384] = 7,			-- Feign Death
				[13813] = 6,		-- Explosive Trap
				[13809] = 5,		-- Ice Trap
				[120360] = 4,		-- Barrage
				[781] = 3,			-- Disengage
				[117050] = 2,		-- Glaive Toss		
				[147362] = 1,		-- Counter Shot
			},
			[255] = { -- Survival
				[19263] = 20,		-- Deterrence
				[148467] = 19,		-- Deterrence (Crouching Tiger, Hidden Chimaera)
				[109304] = 18,		-- Exhilaration
				[53480] = 17,		-- Roar of Sacrifice
				[121818] = 16,		-- Stampede
				[131894] = 16,		-- A Murder of Crows
				[109248] = 15,		-- Binding Shot
				[19386] = 15,		-- Wyvern Sting
				[1499] = 14,		-- Freezing Trap
				[19577] = 13,		-- Intimidation
				[53271] = 12,		-- Master's Call
				[120679] = 11,		-- Dire Beast
				[51753] = 10,		-- Camouflage
				[109259] = 9,		-- Power Shot
				[5384] = 8,			-- Feign Death
				[13813] = 7,		-- Explosive Trap
				[13809] = 6,		-- Ice Trap
				[3674] = 5,			-- Black Arrow
				[120360] = 4,		-- Barrage
				[781] = 3,			-- Disengage
				[117050] = 2,		-- Glaive Toss		
				[147362] = 1,		-- Counter Shot
			},
		},
		["MAGE"] = {
			[0] = { -- Unskilled
				[45438] = 33,		-- Ice Block
				[11958] = 32,		-- Cold Snap
				[12472] = 31,		-- Icy Veins
				[159916] = 30,		-- Amplify Magic
				[55342] = 29,		-- Mirror Images
				[12042] = 28,		-- Arcane Power
				[152087] = 27,		-- Prismatic Crystal
				[84714] = 26,		-- Frozen Orb
				[108978] = 25,		-- Alter Time
				[157913] = 24,		-- Evanesce
				[11129] = 23,		-- Combustion
				[113724] = 22,		-- Ring of Frost
				[44572] = 21,		-- Deep Freeze
				[122] = 20,			-- Frost Nova
				[31661] = 19,		-- Dragon's Breath
				[102051] = 18,		-- Frostjaw
				[66] = 17,			-- Invisibility
				[12051] = 16,		-- Evocation
				[110959] = 15,		-- Greater Invisibility
				[12043] = 14,		-- Presence of Mind
				[153561] = 13,		-- Meteor
				[153595] = 12,		-- Comet Storm
				[11426] = 11,		-- Ice Barrier
				[108843] = 10,		-- Blazing Speed
				[157981] = 9,		-- Blast Wave
				[157980] = 8,		-- Supernova
				[157997] = 7,		-- Ice Nova
				[111264] = 6,		-- Ice Ward
				[1953] = 5,			-- Blink
				[153626] = 4,		-- Arcane Orb
				[120] = 3,			-- Cone of Cold
				[2136] = 2,			-- Fire Blast
				[2139] = 1,			-- Counterspell
			},
			[62] = { -- Arcane
				[45438] = 24,		-- Ice Block
				[11958] = 23,		-- Cold Snap
				[12043] = 22,		-- Presence of Mind
				[12042] = 21,		-- Arcane Power
				[159916] = 20,		-- Amplify Magic
				[55342] = 19,		-- Mirror Images
				[152087] = 18,		-- Prismatic Crystal
				[108978] = 17,		-- Alter Time
				[157913] = 16,		-- Evanesce
				[113724] = 15,		-- Ring of Frost
				[122] = 14,			-- Frost Nova
				[102051] = 13,		-- Frostjaw
				[66] = 12,			-- Invisibility
				[12051] = 11,		-- Evocation
				[110959] = 10,		-- Greater Invisibility
				[11426] = 9,		-- Ice Barrier
				[108843] = 8,		-- Blazing Speed
				[157980] = 7,		-- Supernova
				[111264] = 6,		-- Ice Ward
				[1953] = 5,			-- Blink
				[153626] = 4,		-- Arcane Orb
				[120] = 3,			-- Cone of Cold
				[2136] = 2,			-- Fire Blast
				[2139] = 1,			-- Counterspell
			},
			[63] = { -- Fire
				[45438] = 23,		-- Ice Block
				[11958] = 22,		-- Cold Snap
				[153561] = 21,		-- Meteor
				[11129] = 20,		-- Combustion
				[31661] = 19,		-- Dragon's Breath
				[159916] = 18,		-- Amplify Magic
				[55342] = 17,		-- Mirror Images
				[152087] = 16,		-- Prismatic Crystal
				[108978] = 15,		-- Alter Time
				[157913] = 14,		-- Evanesce
				[113724] = 13,		-- Ring of Frost
				[122] = 12,			-- Frost Nova
				[102051] = 11,		-- Frostjaw
				[66] = 10,			-- Invisibility
				[110959] = 9,		-- Greater Invisibility
				[11426] = 8,		-- Ice Barrier
				[108843] = 7,		-- Blazing Speed
				[157981] = 6,		-- Blast Wave
				[111264] = 5,		-- Ice Ward
				[1953] = 4,			-- Blink
				[120] = 3,			-- Cone of Cold
				[2136] = 2,			-- Fire Blast
				[2139] = 1,			-- Counterspell
			},
			[64] = { -- Frost
				[45438] = 24,		-- Ice Block
				[11958] = 23,		-- Cold Snap
				[84714] = 22,		-- Frozen Orb
				[44572] = 21,		-- Deep Freeze
				[12472] = 20,		-- Icy Veins
				[159916] = 19,		-- Amplify Magic
				[55342] = 18,		-- Mirror Images
				[152087] = 17,		-- Prismatic Crystal
				[108978] = 16,		-- Alter Time
				[157913] = 15,		-- Evanesce
				[113724] = 14,		-- Ring of Frost
				[122] = 13,			-- Frost Nova
				[102051] = 12,		-- Frostjaw
				[66] = 11,			-- Invisibility
				[110959] = 10,		-- Greater Invisibility
				[153595] = 9,		-- Comet Storm
				[11426] = 8,		-- Ice Barrier
				[108843] = 7,		-- Blazing Speed
				[157997] = 6,		-- Ice Nova
				[111264] = 5,		-- Ice Ward
				[1953] = 4,			-- Blink
				[120] = 3,			-- Cone of Cold
				[2136] = 2,			-- Fire Blast
				[2139] = 1,			-- Counterspell
			},
		},
		["MONK"] = {
			[0] = { -- Unskilled
				[115310] = 29,		-- Revival
				[115176] = 29,		-- Zen Meditation
				[123904] = 28,		-- Invoke Xuen, the White Tiger
				[115203] = 27,		-- Fortifying Brew
				[116849] = 26,		-- Life Cocoon
				[137562] = 25,		-- Nimble Brew
				[122278] = 24,		-- Dampen Harm
				[122783] = 24,		-- Diffuse Magic
				[122470] = 23,		-- Touch of Karma
				[157535] = 22,		-- Breath of the Serpent
				[152173] = 21,		-- Serenity
				[115080] = 20,		-- Touch of Death
				[115288] = 19,		-- Energizing Brew
				[116680] = 18,		-- Thunder Focus Tea
				[119381] = 17,		-- Leg Sweep
				[116844] = 17,		-- Ring of Peace
				[119392] = 17,		-- Charging Ox Wave
				[115295] = 16,		-- Guard
				[116841] = 15,		-- Tiger's Lust
				[113656] = 13,		-- Fists of Fury
				[115078] = 12,		-- Paralysis
				[115399] = 11;		-- Chi Brew
				[152175] = 10,		-- Hurricane Strike
				[123986] = 9,		-- Chi Burst
				[115098] = 9,		-- Chi Wave
				[101545] = 8,		-- Flying Serpent Kick
				[119996] = 7,		-- Transcendence: Transfer
				[115008] = 6,		-- Chi Torpedo
				[109132] = 6,		-- Roll
				[115072] = 4,		-- Expel Harm
				[124081] = 3,		-- Zen Sphere
				[116847] = 2,		-- Rushing Jade Wind
				[116705] = 1,		-- Spear Hand Strike
				[115450] = 1,		-- Detox
			},
			[268] = { -- Brewmaster
				[115176] = 19,		-- Zen Meditation
				[123904] = 18,		-- Invoke Xuen, the White Tiger
				[115203] = 17,		-- Fortifying Brew
				[137562] = 16,		-- Nimble Brew
				[122278] = 15,		-- Dampen Harm
				[122783] = 15,		-- Diffuse Magic
				[152173] = 14,		-- Serenity
				[115080] = 13,		-- Touch of Death
				[119381] = 12,		-- Leg Sweep
				[116844] = 12,		-- Ring of Peace
				[119392] = 12,		-- Charging Ox Wave
				[115295] = 11,		-- Guard
				[116841] = 10,		-- Tiger's Lust
				[115078] = 9,		-- Paralysis
				[115399] = 8;		-- Chi Brew
				[123986] = 7,		-- Chi Burst
				[115098] = 7,		-- Chi Wave
				[124081] = 7,		-- Zen Sphere
				[119996] = 6,		-- Transcendence: Transfer
				[115008] = 5,		-- Chi Torpedo
				[109132] = 5,		-- Roll
				[115072] = 4,		-- Expel Harm
				[116847] = 2,		-- Rushing Jade Wind
				[116705] = 1,		-- Spear Hand Strike
				[115450] = 1,		-- Detox
			},
			[269] = { -- Windwalker
				[122470] = 22,		-- Touch of Karma
				[122278] = 21,		-- Dampen Harm
				[122783] = 21,		-- Diffuse Magic
				[137562] = 20,		-- Nimble Brew
				[115203] = 19,		-- Fortifying Brew
				[115176] = 18,		-- Zen Meditation
				[123904] = 17,		-- Invoke Xuen, the White Tiger
				[152173] = 16,		-- Serenity
				[115080] = 15,		-- Touch of Death
				[115288] = 14,		-- Energizing Brew
				[119381] = 13,		-- Leg Sweep
				[116844] = 13,		-- Ring of Peace
				[119392] = 13,		-- Charging Ox Wave
				[116841] = 12,		-- Tiger's Lust
				[113656] = 11,		-- Fists of Fury
				[115078] = 10,		-- Paralysis
				[115399] = 9;		-- Chi Brew
				[152175] = 8,		-- Hurricane Strike
				[123986] = 7,		-- Chi Burst
				[115098] = 7,		-- Chi Wave
				[124081] = 7,		-- Zen Sphere
				[101545] = 6,		-- Flying Serpent Kick
				[119996] = 5,		-- Transcendence: Transfer
				[115008] = 4,		-- Chi Torpedo
				[109132] = 4,		-- Roll
				[115072] = 3,		-- Expel Harm
				[116847] = 2,		-- Rushing Jade Wind
				[116705] = 1,		-- Spear Hand Strike
				[115450] = 1,		-- Detox
			},
			[270] = { -- Mistweaver
				[115310] = 19,		-- Revival
				[116849] = 18,		-- Life Cocoon
				[137562] = 17,		-- Nimble Brew
				[115203] = 16,		-- Fortifying Brew
				[123904] = 15,		-- Invoke Xuen, the White Tiger
				[122278] = 14,		-- Dampen Harm
				[122783] = 14,		-- Diffuse Magic
				[157535] = 13,		-- Breath of the Serpent
				[115080] = 12,		-- Touch of Death
				[116680] = 11,		-- Thunder Focus Tea
				[119381] = 10,		-- Leg Sweep
				[116844] = 10,		-- Ring of Peace
				[119392] = 10,		-- Charging Ox Wave
				[116841] = 9,		-- Tiger's Lust
				[115078] = 8,		-- Paralysis
				[115399] = 7;		-- Chi Brew
				[123986] = 6,		-- Chi Burst
				[115098] = 6,		-- Chi Wave
				[124081] = 6,		-- Zen Sphere
				[119996] = 5,		-- Transcendence: Transfer
				[115008] = 4,		-- Chi Torpedo
				[109132] = 4,		-- Roll
				[115072] = 3,		-- Expel Harm
				[116847] = 2,		-- Rushing Jade Wind
				[116705] = 1,		-- Spear Hand Strike
				[115450] = 1,		-- Detox
			},
		},		
		["PALADIN"] = {
			[0] = { -- Unskilled
				[642] = 20,			-- Divine Shield
				[1022] = 19,		-- Hand of Protection
				[31850] = 18,		-- Ardent Defender
				[31821] = 18,		-- Devotion Aura
				[86659] = 17,		-- Guardian of the Ancient Kings
				[31842] = 16,		-- Avenging Wrath: Holy (Off CD in a sense that it increases throughput)
				[6940] = 15,		-- Hand of Sacrifice
				[31884] = 14,		-- Avenging Wrath: Retribution
				[105809] = 13,		-- Holy Avenger
				[115750] = 12,		-- Blinding Light
				[498] = 11,			-- Divine Protection
				[853] = 10,			-- Hammer of Justice
				[105593] = 10,		-- Fist of Justice
				[114039] = 9,		-- Hand of Purity
				[152262] = 8,		-- Seraphim
				[1044] = 7,			-- Hand of Freedom
				[20066] = 6,		-- Repentance
				[114157] = 5,		-- Execution Sentence
				[114158] = 4,		-- Light's Hammer
				[85499] = 3,		-- Speed of Light
				[114165] = 2,		-- Holy Prism		
				[96231] = 1,		-- Rebuke
				[4987] = 1,			-- Cleanse
			},
			[65] = { -- Holy
				[642] = 16,			-- Divine Shield
				[1022] = 15,		-- Hand of Protection
				[31842] = 14,		-- Avenging Wrath: Holy
				[114157] = 13,		-- Execution Sentence
				[853] = 12,			-- Hammer of Justice
				[105593] = 12,		-- Fist of Justice
				[31821] = 11,		-- Devotion Aura
				[6940] = 10,		-- Hand of Sacrifice
				[105809] = 9,		-- Holy Avenger
				[115750] = 8,		-- Blinding Light
				[498] = 7,			-- Divine Protection
				[114039] = 6,		-- Hand of Purity
				[1044] = 5,			-- Hand of Freedom
				[20066] = 5,		-- Repentance
				[114158] = 4,		-- Light's Hammer
				[85499] = 3,		-- Speed of Light
				[114165] = 2,		-- Holy Prism		
				[96231] = 1,		-- Rebuke
				[4987] = 1,			-- Cleanse
			},
			[66] = { -- Protection
				[642] = 18,			-- Divine Shield
				[1022] = 17,		-- Hand of Protection
				[31850] = 16,		-- Ardent Defender
				[86659] = 15,		-- Guardian of the Ancient Kings
				[6940] = 14,		-- Hand of Sacrifice
				[105809] = 13,		-- Holy Avenger
				[115750] = 12,		-- Blinding Light
				[498] = 11,			-- Divine Protection
				[853] = 10,			-- Hammer of Justice
				[105593] = 10,		-- Fist of Justice
				[114039] = 9,		-- Hand of Purity
				[152262] = 8,		-- Seraphim
				[1044] = 7,			-- Hand of Freedom
				[20066] = 6,		-- Repentance
				[114157] = 5,		-- Execution Sentence
				[114158] = 4,		-- Light's Hammer
				[85499] = 3,		-- Speed of Light
				[114165] = 2,		-- Holy Prism		
				[96231] = 1,		-- Rebuke
				[4987] = 1,			-- Cleanse
			},
			[70] = { -- Retribution
				[642] = 17,			-- Divine Shield
				[1022] = 16,		-- Hand of Protection
				[6940] = 15,		-- Hand of Sacrifice
				[31884] = 14,		-- Avenging Wrath: Retribution
				[853] = 13,			-- Hammer of Justice
				[105593] = 13,		-- Fist of Justice
				[105809] = 12,		-- Holy Avenger
				[115750] = 11,		-- Blinding Light
				[498] = 10,			-- Divine Protection
				[114039] = 9,		-- Hand of Purity
				[152262] = 8,		-- Seraphim
				[1044] = 7,			-- Hand of Freedom
				[20066] = 6,		-- Repentance
				[114157] = 5,		-- Execution Sentence
				[114158] = 4,		-- Light's Hammer
				[85499] = 3,		-- Speed of Light
				[114165] = 2,		-- Holy Prism		
				[96231] = 1,		-- Rebuke
				[4987] = 1,			-- Cleanse
			},
		},
		["PRIEST"] = {
			[0] = { -- Unskilled
				[64843] = 30,		-- Divine Hymn
				[62618] = 30,		-- Power Word: Barrier
				[126135] = 29,		-- Light Well
				[34433] = 28,		-- Shadow Fiend
				[19236] = 27,		-- Desperate Prayer
				[33206] = 26,		-- Pain Suppression
				[47585] = 26,		-- Dispersion
				[47788] = 26,		-- Guardian Spirit
				[10060] = 25,		-- Power Infusion
				[114214] = 23, 		-- Angelic Bulwark
				[73325] = 22,		-- Leap of Faith
				[109964] = 21, 		-- Spirit Shell
				[123040] = 20, 		-- Mind Bender
				[8122] = 19,		-- Psychic Scream
				[108920] = 19,		-- Void Tendrils
				[15487] = 18,		-- Silence
				[64044] = 17,		-- Psychic Horror
				[6346] = 16,		-- Fear Ward
				[120517] = 15,		-- Halo
				[120644] = 15,		-- Halo (Shadow)
				[88685] = 14,		-- Holy Word: Sanctuary
				[81700] = 13,		-- Arch Angel
				[88625] = 12,		-- Holy Word: Chastise
				[586] = 11,			-- Fade
				[112833] = 10, 		-- Shadow Guise
				[121536] = 9,		-- Angelic Feather
				[121135] = 8,		-- Cascade
				[127632] = 8,		-- Cascade (Shadow)
				[110744] = 7,		-- Divine Star
				[122121] = 7,		-- Divine Star (Shadow)
				[34861] = 6,		-- Circle of Healing
				[14914] = 5,		-- Holy Fire
				[88684] = 4,		-- Holy Word: Serenity
				[33076] = 3,		-- Prayer of Mending
				[129176] = 2,		-- Shadow Word: Death
				[32375] = 1,		-- Mass Dispel
				[527] = 1,			-- Purify
			},
			[256] = { -- Disc
				[62618] = 22,		-- Power Word: Barrier
				[33206] = 21,		-- Pain Suppression
				[19236] = 20,		-- Desperate Prayer
				[10060] = 19,		-- Power Infusion
				[8122] = 18,		-- Psychic Scream
				[108920] = 18,		-- Void Tendrils
				[112833] = 17, 		-- Shadow Guise
				[15487] = 16,		-- Silence
				[34433] = 15,		-- Shadow Fiend
				[114214] = 14, 		-- Angelic Bulwark
				[73325] = 13,		-- Leap of Faith
				[109964] = 12, 		-- Spirit Shell
				[123040] = 11, 		-- Mind Bender
				[6346] = 10,		-- Fear Ward
				[120517] = 9,		-- Halo
				[81700] = 8,		-- Arch Angel
				[586] = 7,			-- Fade
				[121536] = 6,		-- Angelic Feather
				[121135] = 5,		-- Cascade
				[110744] = 4,		-- Divine Star
				[14914] = 3,		-- Holy Fire
				[33076] = 2,		-- Prayer of Mending
				[527] = 1,			-- Purify
			},
			[257] = { -- Holy
				[64843] = 25,		-- Divine Hymn
				[126135] = 24,		-- Light Well
				[47788] = 23,		-- Guardian Spirit
				[19236] = 22,		-- Desperate Prayer
				[10060] = 21,		-- Power Infusion
				[8122] = 20,		-- Psychic Scream
				[108920] = 20,		-- Void Tendrils
				[112833] = 19, 		-- Shadow Guise
				[34433] = 18,		-- Shadow Fiend
				[114214] = 17, 		-- Angelic Bulwark
				[73325] = 16,		-- Leap of Faith
				[109964] = 15, 		-- Spirit Shell
				[123040] = 14, 		-- Mind Bender
				[6346] = 13,		-- Fear Ward
				[120517] = 12,		-- Halo
				[88685] = 11,		-- Holy Word: Sanctuary
				[88625] = 10,		-- Holy Word: Chastise
				[586] = 9,			-- Fade
				[121536] = 8,		-- Angelic Feather
				[121135] = 7,		-- Cascade
				[110744] = 6,		-- Divine Star
				[34861] = 5,		-- Circle of Healing
				[14914] = 4,		-- Holy Fire
				[88684] = 3,		-- Holy Word: Serenity
				[33076] = 2,		-- Prayer of Mending
				[527] = 1,			-- Purify
			},
			[258] = { -- Shadow
				[47585] = 20,		-- Dispersion
				[19236] = 19,		-- Desperate Prayer
				[64044] = 18,		-- Psychic Horror
				[10060] = 17,		-- Power Infusion
				[8122] = 16,		-- Psychic Scream
				[108920] = 16,		-- Void Tendrils
				[15487] = 15,		-- Silence
				[34433] = 14,		-- Shadow Fiend
				[114214] = 13, 		-- Angelic Bulwark
				[73325] = 12,		-- Leap of Faith
				[123040] = 11, 		-- Mind Bender
				[6346] = 10,		-- Fear Ward
				[120644] = 9,		-- Halo (Shadow)
				[586] = 8,			-- Fade
				[112833] = 7, 		-- Shadow Guise
				[121536] = 6,		-- Angelic Feather
				[127632] = 5,		-- Cascade (Shadow)
				[122121] = 4,		-- Divine Star (Shadow)
				[33076] = 3,		-- Prayer of Mending
				[129176] = 2,		-- Shadow Word: Death
				[32375] = 1,		-- Mass Dispel
			},
		},		
		["ROGUE"] = {
			[0] = { -- Unskilled
				--[114018] = 98,	-- Shroud of Concealment
				[14185] = 19,		-- Preparation
				[76577] = 18,		-- Smoke Bomb
				[13750] = 17,		-- Adrenaline Rush
				[74001] = 16,		-- Combat Readiness
				[5277] = 15,		-- Evasion
				[1856] = 14,		-- Vanish
				[51690] = 13,		-- Killing Spree
				[79140] = 13,		-- Vendetta
				[152151] = 12,		-- Shadow Reflection
				[2094] = 11,		-- Blind
				[31224] = 10,		-- Cloak of Shadows
				[137619] = 9,		-- Marked for Death
				[51713] = 8,		-- Shadow Dance
				[2983] = 7,			-- Sprint
				[408] = 6,			-- Kidney Shot
				[152150] = 5,		-- Death form Above
				[36554] = 4,		-- Shadow Step
				[1776] = 3,			-- Gouge
				[5938] = 2,			-- Shiv		
				[1766] = 1,			-- Kick
			},
			[259] = { -- Assassination
				[5277] = 15,		-- Evasion
				[31224] = 10,		-- Cloak of Shadows
				[76577] = 18,		-- Smoke Bomb
				[79140] = 13,		-- Vendetta
				[14185] = 19,		-- Preparation
				[74001] = 16,		-- Combat Readiness
				[1856] = 14,		-- Vanish
				[152151] = 12,		-- Shadow Reflection
				[2094] = 11,		-- Blind
				[137619] = 9,		-- Marked for Death
				[51713] = 8,		-- Shadow Dance
				[2983] = 7,			-- Sprint
				[408] = 6,			-- Kidney Shot
				[152150] = 5,		-- Death form Above
				[36554] = 4,		-- Shadow Step
				[1776] = 3,			-- Gouge
				[5938] = 2,			-- Shiv		
				[1766] = 1,			-- Kick
			},
			[260] = { -- Combat
				[5277] = 18,		-- Evasion
				[31224] = 17,		-- Cloak of Shadows
				[76577] = 16,		-- Smoke Bomb
				[51690] = 15,		-- Killing Spree
				[14185] = 14,		-- Preparation
				[13750] = 13,		-- Adrenaline Rush
				[74001] = 12,		-- Combat Readiness
				[1856] = 11,		-- Vanish
				[152151] = 10,		-- Shadow Reflection
				[2094] = 9,			-- Blind
				[137619] = 8,		-- Marked for Death
				[2983] = 7,			-- Sprint
				[408] = 6,			-- Kidney Shot
				[152150] = 5,		-- Death form Above
				[36554] = 4,		-- Shadow Step
				[1776] = 3,			-- Gouge
				[5938] = 2,			-- Shiv		
				[1766] = 1,			-- Kick
			},
			[261] = { -- Subtlety
				[5277] = 17,		-- Evasion
				[31224] = 16,		-- Cloak of Shadows
				[76577] = 15,		-- Smoke Bomb
				[51713] = 14,		-- Shadow Dance
				[14185] = 13,		-- Preparation
				[74001] = 12,		-- Combat Readiness
				[1856] = 11,		-- Vanish
				[152151] = 10,		-- Shadow Reflection
				[2094] = 9,			-- Blind
				[137619] = 8,		-- Marked for Death
				[2983] = 7,			-- Sprint
				[408] = 6,			-- Kidney Shot
				[152150] = 5,		-- Death form Above
				[36554] = 4,		-- Shadow Step
				[1776] = 3,			-- Gouge
				[5938] = 2,			-- Shiv		
				[1766] = 1,			-- Kick
			},
		},		
		["SHAMAN"] = {
			[0] = { -- Unskilled
				[2894] = 33,		-- Fire Elemental Totem
				[98008] = 32,		-- Spirit Link Totem
				--[108280] = 32,	-- Healing Tide Totem
				[114050] = 31,		-- Ascendance: Elemental
				[114051] = 31,		-- Ascendance: Enhancement
				[114052] = 31,		-- Ascendance: Restoration
				[108281] = 30,		-- Ancestral Guidance
				[16166] = 29,		-- Elemental Mastery
				[51533] = 28,		-- Feral Spirit
				[108271] = 27,		-- Astral Shift
				[16188] = 26,		-- Ancestral Swiftness
				[30823] = 25,		-- Shamanistic Rage
				[58875] = 24,		-- Spirit Walk
				[108273] = 23,		-- Windwalk Totem
				[108270] = 22,		-- Stone Bulwark Totem
				[108269] = 21,		-- Capacitor Totem
				[51514] = 20,		-- Hex		
				[157153] = 19,		-- Cloud Burst Totem
				[51485] = 18,		-- Earth Grab Totem
				[2062] = 17,		-- Earth Elemental Totem
				[152256] = 16,		-- Storm Elemental Totem
				[108285] = 15,		-- Call of the Elements (Might change that to Defensive/Offensive)
				[79206] = 14,		-- Spirit Walker's Grace
				[8143] = 13,		-- Tremor Totem
				[5394] = 12,		-- Healing Stream Totem
				[2484] = 11,		-- Earthbind Totem
				[152255] = 10,		-- Liquid Magma
				[51490] = 9,		-- Thunderstorm
				[8177] = 8,			-- Grounding Totem
				[165462] = 7,		-- Unleash Flame
				[117014] = 6,		-- Elemental Blast
				[73920] = 5,		-- Healing Rain
				[108287] = 4,		-- Totemic Projection
				[370] = 3,			-- Purge (Glyphed)
				[61295] = 2,		-- Riptide		
				[57994] = 1,		-- Windshear
				[51886] = 1,		-- Cleanse Spirit
				[77130] = 1,		-- Purify Spirit
			},
			[262] = { -- Elemental
				[108281] = 29,		-- Ancestral Guidance
				[30823] = 28,		-- Shamanistic Rage
				[114050] = 27,		-- Ascendance: Elemental
				[16166] = 26,		-- Elemental Mastery
				[108271] = 25,		-- Astral Shift
				[16188] = 24,		-- Ancestral Swiftness
				[51514] = 23,		-- Hex
				[2894] = 22,		-- Fire Elemental Totem
				[58875] = 21,		-- Spirit Walk
				[108273] = 20,		-- Windwalk Totem
				[108270] = 19,		-- Stone Bulwark Totem
				[108269] = 18,		-- Capacitor Totem
				[51485] = 17,		-- Earth Grab Totem
				[2062] = 16,		-- Earth Elemental Totem
				[152256] = 15,		-- Storm Elemental Totem
				[108285] = 14,		-- Call of the Elements
				[79206] = 13,		-- Spiritwalker's Grace
				[8143] = 12,		-- Tremor Totem
				[5394] = 11,		-- Healing Stream Totem
				[2484] = 10,		-- Earthbind Totem
				[152255] = 9,		-- Liquid Magma
				[51490] = 8,		-- Thunderstorm
				[8177] = 7,			-- Grounding Totem
				[165462] = 6,		-- Unleash Flame
				[117014] = 5,		-- Elemental Blast
				[73920] = 4,		-- Healing Rain
				[108287] = 3,		-- Totemic Projection
				[370] = 2,			-- Purge (Glyphed)
				[57994] = 1,		-- Wind Shear
				[51886] = 1,		-- Cleanse Spirit
			},
			[263] = { -- Enhancement
				[108281] = 29,		-- Ancestral Guidance
				[30823] = 28,		-- Shamanistic Rage
				[114051] = 27,		-- Ascendance: Enhancement
				[51533] = 26,		-- Feral Spirit
				[58875] = 25,		-- Spirit Walk
				[108271] = 24,		-- Astral Shift
				[51514] = 13,		-- Hex
				[2894] = 22,		-- Fire Elemental Totem
				[16166] = 21,		-- Elemental Mastery	
				[16188] = 20,		-- Ancestral Swiftness	
				[108273] = 19,		-- Windwalk Totem
				[108270] = 18,		-- Stone Bulwark Totem
				[108269] = 17,		-- Capacitor Totem
				[51485] = 16,		-- Earth Grab Totem
				[2062] = 15,		-- Earth Elemental Totem
				[152256] = 14,		-- Storm Elemental Totem
				[108285] = 13,		-- Call of the Elements
				[8143] = 12,		-- Tremor Totem
				[5394] = 11,		-- Healing Stream Totem
				[2484] = 10,		-- Earthbind Totem
				[152255] = 9,		-- Liquid Magma
				[8177] = 7,			-- Grounding Totem
				[165462] = 6,		-- Unleash Flame
				[117014] = 5,		-- Elemental Blast
				[73920] = 4,		-- Healing Rain
				[108287] = 3,		-- Totemic Projection
				[370] = 2,			-- Purge (Glyphed)	
				[57994] = 1,		-- Wind Shear
				[51886] = 1,		-- Cleanse Spirit
			},
			[264] = { -- Restoration
				[98008] = 28,		-- Spirit Link Totem
				[114052] = 27,		-- Ascendance: Restoration
				[108281] = 26,		-- Ancestral Guidance
				[108273] = 25,		-- Windwalk Totem
				[16188] = 24,		-- Ancestral Swiftness
				[16166] = 23,		-- Elemental Mastery
				[108271] = 22,		-- Astral Shift
				[51514] = 21,		-- Hex
				[2894] = 20,		-- Fire Elemental Totem
				[108270] = 19,		-- Stone Bulwark Totem
				[108269] = 18,		-- Capacitor Totem
				[157153] = 17,		-- Cloud Burst Totem
				[51485] = 16,		-- Earth Grab Totem
				[2062] = 15,		-- Earth Elemental Totem
				[152256] = 14,		-- Storm Elemental Totem
				[108285] = 13,		-- Call of the Elements
				[79206] = 12,		-- Spiritwalker's Grace
				[8143] = 11,		-- Tremor Totem
				[5394] = 10,		-- Healing Stream Totem
				[2484] = 9,		-- Earthbind Totem
				[8177] = 8,			-- Grounding Totem
				[165462] = 7,		-- Unleash Flame
				[117014] = 6,		-- Elemental Blast
				[73920] = 5,		-- Healing Rain
				[108287] = 4,		-- Totemic Projection
				[370] = 3,			-- Purge (Glyphed)
				[61295] = 2,		-- Riptide		
				[57994] = 1,		-- Windshear
				[77130] = 1,		-- Purify Spirit
			},
		},
		["WARLOCK"] = {
			[0] = { -- Unskilled
				[110913] = 24,		-- Dark Bargain
				[104773] = 23,		-- Unending Resolve
				[108359] = 22,		-- Dark Regeneration
				[108482] = 21,		-- Unbound Will
				[113858] = 20,		-- Dark Soul: Instability
				[113861] = 19,		-- Dark Soul: Knowledge
				[113860] = 18,		-- Dark Soul: Misery
				[108501] = 17,		-- Grimoire of Service
				[108416] = 16,		-- Sacrificial Pact
				[152108] = 15,		-- Cataclysm
				[108508] = 14,		-- Mannoroth's Fury
				[5484] = 11,		-- Howl of Terror
				[6789] = 11,		-- Mortal Coil
				[30283] = 11,		-- Shadowfury
				[120451] = 10,		-- Flames of Xoroth
				[111397] = 9,		-- Blood Horror
				[137587] = 8,		-- Kil'jaeden's Cunning
				[108503] = 7,		-- Grimoire of Sacrifice
				[80240] = 6,		-- Havoc
				[105174] = 5,		-- Hand of Gul'dan
				[17962] = 4,		-- Conflagrate
				[103958] = 3,		-- Metamorphosis
				[109151] = 2,		-- Demonic Leap		
				[132409] = 1,		-- Spell lock (Warlock)
			},
			[265] = { -- Affliction
				[104773] = 13,		-- Unending Resolve
				[108359] = 12,		-- Dark Regeneration
				[113860] = 11,		-- Dark Soul: Misery
				[5484] = 10,		-- Howl of Terror
				[6789] = 10,		-- Mortal Coil
				[30283] = 10,		-- Shadowfury
				[110913] = 9,		-- Dark Bargain
				[108416] = 9,		-- Sacrificial Pact
				[108482] = 8,		-- Unbound Will
				[108501] = 7,		-- Grimoire of Service
				[152108] = 6,		-- Cataclysm
				[108508] = 5,		-- Mannoroth's Fury
				[111397] = 4,		-- Blood Horror
				[137587] = 3,		-- Kil'jaeden's Cunning
				[108503] = 2,		-- Grimoire of Sacrifice
				[132409] = 1,		-- Spell lock (Warlock)
			},
			[266] = { -- Demonology
				[104773] = 18,		-- Unending Resolve
				[108359] = 17,		-- Dark Regeneration
				[113861] = 16,		-- Dark Soul: Knowledge
				[5484] = 15,		-- Howl of Terror
				[6789] = 14,		-- Mortal Coil
				[30283] = 13,		-- Shadowfury
				[110913] = 12,		-- Dark Bargain
				[108416] = 11,		-- Sacrificial Pact
				[108482] = 10,		-- Unbound Will
				[108501] = 9,		-- Grimoire of Service
				[152108] = 8,		-- Cataclysm
				[108508] = 7,		-- Mannoroth's Fury
				[111397] = 6,		-- Blood Horror
				[105174] = 5,		-- Hand of Gul'dan
				[137587] = 4,		-- Kil'jaeden's Cunning
				[103958] = 3,		-- Metamorphosis
				[109151] = 2,		-- Demonic Leap		
				[132409] = 1,		-- Spell lock (Warlock)
			},
			[267] = { -- Destruction
				[104773] = 16,		-- Unending Resolve
				[108359] = 15,		-- Dark Regeneration
				[113858] = 14,		-- Dark Soul: Instability
				[5484] = 13,		-- Howl of Terror
				[6789] = 13,		-- Mortal Coil
				[30283] = 13,		-- Shadowfury
				[110913] = 12,		-- Dark Bargain
				[108416] = 12,		-- Sacrificial Pact
				[108482] = 11,		-- Unbound Will
				[108501] = 10,		-- Grimoire of Service
				[152108] = 9,		-- Cataclysm
				[108508] = 8,		-- Mannoroth's Fury
				[120451] = 7,		-- Flames of Xoroth
				[111397] = 6,		-- Blood Horror
				[137587] = 5,		-- Kil'jaeden's Cunning
				[108503] = 4,		-- Grimoire of Sacrifice
				[80240] = 3,		-- Havoc
				[17962] = 2,		-- Conflagrate	
				[132409] = 1,		-- Spell lock (Warlock)
			},
		},
		["WARRIOR"] = {
			[0] = { -- Unskilled
				[871] = 32,			-- Shield Wall
				[97462] = 32,		-- Rallying Cry
				[12975] = 31,		-- Last Stand
				[1719] = 30,		-- Recklessness
				[118038] = 29,		-- Die by the Sword
				[114030] = 28,		-- Vigilance
				[107574] = 27,		-- Avatar
				[12292] = 27,		-- Bloodbath
				[46924] = 27,		-- Blade Storm
				[5246] = 26,		-- Intimidating Shout
				[176289] = 26,		-- Siegebreaker
				[55694] = 25,		-- Enraged Regeneration
				[1160] = 24,		-- Demoralizing Shout
				[118000] = 22,		-- Dragon Roar
				[46968] = 22,		-- Shockwave
				[114029] = 21,		-- Safeguard
				[107570] = 20,		-- Storm Bolt
				[64382] = 19,		-- Shattering Throw
				[152277] = 18;		-- Ravager
				[6544] = 17,		-- Heroic Leap
				[114028] = 15,		-- Mass Spell Reflection
				[18499] = 14,		-- Berserker Rage
				[3411] = 13,		-- Intervene
				[23920] = 12,		-- Spell Reflection
				[100] = 11,			-- Charge
				[167105] = 10,		-- Colossus Smash
				[156321] = 9,		-- Shield Charge
				[2565] = 8,			-- Shield Block
				[12328] = 7,		-- Sweeping Strikes
				[6572] = 6,			-- Revenge
				[57755] = 5,		-- Heroic Throw
				[23922] = 4,		-- Shield Slam
				[6343] = 3,			-- Thunderclap
				[23881] = 2,		-- Blood Thirst		
				[6552] = 1,			-- Pummel
			},
			[71] = { -- Arms
				[97462] = 22,		-- Rallying Cry
				[118038] = 21,		-- Die by the Sword
				[1719] = 20,		-- Recklessness
				[107574] = 19,		-- Avatar
				[12292] = 19,		-- Bloodbath
				[46924] = 19,		-- Blade Storm
				[55694] = 18,		-- Enraged Regeneration
				[114030] = 17,		-- Vigilance
				[107570] = 17,		-- Storm Bolt
				[5246] = 16,		-- Intimidating Shout
				[176289] = 16,		-- Siegebreaker
				[118000] = 15,		-- Dragon Roar
				[46968] = 15,		-- Shockwave
				[114029] = 14,		-- Safeguard
				[64382] = 13,		-- Shattering Throw
				[152277] = 12;		-- Ravager
				[6544] = 11,		-- Heroic Leap
				[114028] = 10,		-- Mass Spell Reflection
				[23920] = 10,		-- Spell Reflection
				[18499] = 9,		-- Berserker Rage
				[3411] = 8,			-- Intervene
				[100] = 7,			-- Charge
				[167105] = 6,		-- Colossus Smash
				[156321] = 5,		-- Shield Charge
				[12328] = 4,		-- Sweeping Strikes
				[57755] = 3,		-- Heroic Throw
				[6343] = 2,			-- Thunderclap
				[6552] = 1,			-- Pummel
			},
			[72] = { -- Fury
				[97462] = 22,		-- Rallying Cry
				[118038] = 21,		-- Die by the Sword
				[1719] = 20,		-- Recklessness
				[107574] = 19,		-- Avatar
				[12292] = 19,		-- Bloodbath
				[46924] = 19,		-- Blade Storm
				[5246] = 18,		-- Intimidating Shout
				[176289] = 18,		-- Siegebreaker
				[55694] = 17,		-- Enraged Regeneration
				[114030] = 16,		-- Vigilance
				[118000] = 15,		-- Dragon Roar
				[46968] = 15,		-- Shockwave
				[114029] = 14,		-- Safeguard
				[107570] = 13,		-- Storm Bolt
				[64382] = 12,		-- Shattering Throw
				[152277] = 11;		-- Ravager
				[6544] = 10,		-- Heroic Leap
				[114028] = 9,		-- Mass Spell Reflection
				[18499] = 8,		-- Berserker Rage
				[3411] = 7,		-- Intervene
				[23920] = 6,		-- Spell Reflection
				[100] = 5,			-- Charge
				[156321] = 4,		-- Shield Charge
				[57755] = 3,		-- Heroic Throw
				[23881] = 2,		-- Bloodthirst		
				[6552] = 1,			-- Pummel
			},
			[73] = { -- Protection
				[871] = 27,			-- Shield Wall
				[12975] = 26,		-- Last Stand
				[1719] = 25,		-- Recklessness
				[107574] = 24,		-- Avatar
				[12292] = 24,		-- Bloodbath
				[46924] = 24,		-- Blade Storm
				[5246] = 23,		-- Intimidating Shout
				[55694] = 22,		-- Enraged Regeneration
				[114030] = 21,		-- Vigilance
				[1160] = 20,		-- Demoralizing Shout
				[118000] = 19,		-- Dragon Roar
				[46968] = 18,		-- Shockwave
				[114029] = 17,		-- Safeguard
				[107570] = 16,		-- Storm Bolt
				[64382] = 15,		-- Shattering Throw
				[152277] = 14;		-- Ravager
				[6544] = 13,		-- Heroic Leap
				[114028] = 12,		-- Mass Spell Reflection
				[18499] = 11,		-- Berserker Rage
				[3411] = 10,		-- Intervene
				[23920] = 9,		-- Spell Reflection
				[100] = 8,			-- Charge
				[156321] = 7,		-- Shield Charge
				[2565] = 6,			-- Shield Block
				[6572] = 5,			-- Revenge
				[57755] = 4,		-- Heroic Throw
				[23922] = 3,		-- Shield Slam
				[6343] = 2,			-- Thunderclap
				[6552] = 1,			-- Pummel
			},
		},
	},
	["SpecIDToDispelOrInterrupt"] = {
		[250] = 47528,		-- Deathknight: Blood
		[251] = 47528,		-- Deathknight: Frost
		[252] = 47528,		-- Deathknight: Unholy
		
		[102] = 78675,		-- Druid: Balance
		[103] = 106839,		-- Druid: Feral
		[104] = 106839,		-- Druid: Guardian
		[105] = 88423,		-- Druid: Restoration
		
		[253] = 147362,		-- Hunter: Beast Mastery
		[254] = 147362,		-- Hunter: Marksmanship
		[255] = 147362,		-- Hunter: Survival
		
		[62] = 2139,		-- Mage: Arcane
		[63] = 2139,		-- Mage: Fire
		[64] = 2139,		-- Mage: Frost
		
		[268] = 116705,		-- Monk: Brewmaster
		[269] = 116705,		-- Monk: Windwalker
		[270] = 115450,		-- Monk: Mistweaver
		
		[65] = 4987,		-- Paladin: Holy
		[66] = 96231,		-- Paladin: Protection
		[70] = 96231,		-- Paladin: Retribution
		
		[256] = 527,		-- Priest: Discipline
		[257] = 527,		-- Priest: Holy
		[258] = 32375,		-- Priest: Shadow
		
		[259] = 1766,		-- Rogue: Assassination
		[260] = 1766,		-- Rogue: Combat
		[261] = 1766,		-- Rogue: Sublety
		
		[263] = 57994,		-- Shaman: Elemental
		[263] = 57994,		-- Shaman: Enhancement
		[264] = 77130,		-- Shaman: Restoration
		
		[265] = 132409,		-- Warlock: Affliction 
		[266] = 132409, 	-- Warlock: Demonology
		[267] = 132409,		-- Warlock: Destruction

		[71] = 6552,		-- Warrior: Arms
		[72] = 6552,		-- Warrior: Furry
		[73] = 6552,		-- Warrior: Protection		
	},
	["CooldownClassSpecInfo"] = {
		["DEATHKNIGHT"] = {
			[0] = { -- Unskilled
				[47568] = 300,		-- Empowered Rune Weapon
				[48792] = 180,		-- Icebound Fortitude
				[77606] = 60,		-- Dark Simulacrum
				[77575] = 60,		-- Outbreak
				[47476] = 60,		-- Strangulate
				[48707] = 45,		-- Anti-Magic Shell
				[43265] = 30,		-- Death and Decay
				[49576] = 25,		-- Death Grip
				[47528] = 15,		-- Mind Freeze		
			},
			[250] = { -- Blood
				[47568] = 300,		-- Empowered Rune Weapon
				[48792] = 180,		-- Icebound Fortitude
				[49028] = 90,		-- Dancing Rune Weapon
				[49222] = 60,		-- Bone Shield
				[77606] = 60,		-- Dark Simulacrum
				[77575] = 60,		-- Outbreak
				[47476] = 60,		-- Strangulate
				[55233] = 60,		-- Vampiric Blood
				[48707] = 45,		-- Anti-Magic Shell
				[43265] = 30,		-- Death and Decay
				[48982] = {30, 2},	-- Runetap (with Enhanced Rune Tap Passive)
				[49576] = 20,		-- Death Grip (with Enhanced Death Grip Passive)
				[47528] = 15,		-- Mind Freeze
			},
			[251] = { -- Frost
				[47568] = 300,		-- Empowered Rune Weapon
				[48792] = 180,		-- Icebound Fortitude
				[77606] = 60,		-- Dark Simulacrum
				[51271] = 60,		-- Pillar of Frost
				[77575] = 60,		-- Outbreak
				[47476] = 60,		-- Strangulate
				[48707] = 45,		-- Anti-Magic Shell
				[43265] = 30,		-- Death and Decay
				[49576] = 25,		-- Death Grip
				[47528] = 15,		-- Mind Freeze
			},
			[252] = { -- Unholy
				[47568] = 300,		-- Empowered Rune Weapon
				[48792] = 180,		-- Icebound Fortitude
				[49206] = 180,		-- Summon Gargoyle
				[77606] = 60,		-- Dark Simulacrum
				[77575] = 60,		-- Outbreak
				[47476] = 60,		-- Strangulate
				[48707] = 45,		-- Anti-Magic Shell
				[43265] = 30,		-- Death and Decay
				[49576] = 25,		-- Death Grip
				[47528] = 15,		-- Mind Freeze
			},
		},		
		["DRUID"] = {
			[0] = {
				[1850] = 180,		-- Dash
				[106898] = 120,		-- Stampeding Roar
			},
			[102] = { -- Balance
				[112071] = 180,		-- Celestial Alignment
				[1850] = 180,		-- Dash
				[106898] = 120,		-- Stampeding Roar
				[22812] = 60,		-- Bark Skin
				[78675] = 60,		-- Solar Beam
				[48505] = {30, 3},	-- Starfall
				[78674] = {30, 3},	-- Starsurge
				[2782] = 8,			-- Remove Corruption
			},
			[103] = { -- Feral
				[106951] = 180,		-- Berserk
				[1850] = 180,		-- Dash
				[61336] = {180, 2},	-- Survival Instincts
				[106898] = 120,		-- Stampeding Roar
				[5217] = 30,		-- Tiger's Fury
				[106839] = 15,		-- Skull Bash
				[2782] = 8,			-- Remove Corruption
			},
			[104] = { -- Guardian
				[106952] = 180,		-- Berserk (Guardian?)
				[1850] = 180,		-- Dash
				[61336] = {180, 2},	-- Survival Instincts
				[106898] = 120,		-- Stampeding Roar
				[22812] = 60,		-- Bark Skin
				[106839] = 15,		-- Skull Bash
				[62606] = {12, 2}, 	-- Savage Defense
				[2782] = 8,			-- Remove Corruption
				
			},
			[105] = { -- Resto
				[740] = 180,		-- Tranquility (With Malfurion's Gift Passive)
				[1850] = 180,		-- Dash
				[106898] = 120,		-- Stampeding Roar
				[22812] = 60,		-- Bark Skin
				[102342] = 60,		-- Ironbark
				[132158] = 60,		-- Nature's Swiftness
				[18562] = 15,		-- Swiftmend
				[48438] = 8,		-- Wild Growth
				[88423] = 8,		-- Nature's Cure
				
			},
		},		
		["HUNTER"] = {
			[0] = { -- Unskilled
				[19263] = {180, 2},		-- Deterrence
				[51753] = 60,			-- Camouflage
				[53480] = 60,			-- Roar of Sacrifice
				[53271] = 45,			-- Master's Call
				[5384] = 30,			-- Feign Death
				[147362] = 24,			-- Counter Shot
				[781] = 20,				-- Disengage
				[13813] = 15,			-- Explosive Trap
				[1499] = 30,			-- Freezing Trap
				[13809] = 15,			-- Ice Trap
			},
			[253] = { -- Beast Mastery
				[19263] = {180, 2},		-- Deterrence
				[19574] = 60,			-- Bestial Wrath
				[51753] = 60,			-- Camouflage
				[53480] = 60,			-- Roar of Sacrifice
				[53271] = 45,			-- Master's Call
				[5384] = 30,			-- Feign Death
				[147362] = 24,			-- Counter Shot
				[781] = 20,				-- Disengage
				[13813] = 15,			-- Explosive Trap
				[1499] = 30,			-- Freezing Trap
				[13809] = 15,			-- Ice Trap
			},
			[254] = { -- Marksmanship
				[19263] = {180, 2},		-- Deterrence
				[3045] = 120,			-- Rapid Fire
				[51753] = 60,			-- Camouflage
				[53480] = 60,			-- Roar of Sacrifice
				[53271] = 45,			-- Master's Call
				[5384] = 30,			-- Feign Death
				[147362] = 24,			-- Counter Shot
				[781] = 20,				-- Disengage
				[13813] = 15,			-- Explosive Trap
				[1499] = 30,			-- Freezing Trap
				[13809] = 15,			-- Ice Trap
			},
			[255] = { -- Survival
				[19263] = {180, 2},		-- Deterrence
				[51753] = 60,			-- Camouflage
				[53480] = 60,			-- Roar of Sacrifice
				[53271] = 45,			-- Master's Call
				[3674] = 30,			-- Black Arrow
				[5384] = 30,			-- Feign Death
				[147362] = 24,			-- Counter Shot
				[781] = 20,				-- Disengage
				[13813] = 12,			-- Explosive Trap
				[1499] = 20,			-- Freezing Trap
				[13809] = 12,			-- Ice Trap
			},
		},
		["MAGE"] = {
			[0] = { -- Unskilled
				[45438] = 300,			-- Ice Block
				[66] = 300,				-- Invisibility
				[159916] = 120,			-- Amplify Magic
				[122] = 30,				-- Frost Nova
				[2139] = 24,			-- Counterspell
				[1953] = 15,			-- Blink
				[120] = 12,				-- Cone of Cold
				[2136] = 8,				-- Fireblast
			},
			[62] = { -- Arcane
				[45438] = 300,			-- Ice Block
				[66] = 300,				-- Invisibility
				[159916] = 120,			-- Amplify Magic
				[12051] = 90,			-- Evocation (With Improved Evocation Passive)
				[12042] = 90,			-- Arcane Power
				[12043] = 90,			-- Presence of Mind
				[122] = 30,				-- Frost Nova
				[2139] = 24,			-- Counterspell
				[1953] = 15,			-- Blink
				[120] = 12,				-- Cone of Cold
				[2136] = 8,				-- Fireblast
			},
			[63] = { -- Fire
				[45438] = 300,			-- Ice Block
				[66] = 300,				-- Invisibility
				[159916] = 120,			-- Amplify Magic
				[11129] = 45,			-- Combustion
				[122] = 30,				-- Frost Nova
				[2139] = 24,			-- Counterspell
				[31661] = 20,			-- Dragon's Breath
				[1953] = 15,			-- Blink
				[120] = 12,				-- Cone of Cold
				[108853] = 8,			-- Inferno Blast
			},
			[64] = { -- Frost
				[45438] = 300,			-- Ice Block
				[66] = 300,				-- Invisibility
				[12472] = 180,			-- Icy Veins
				[159916] = 120,			-- Amplify Magic
				[84714] = 60,			-- Frozen Orb
				[44572] = 30,			-- Deep Freeze
				[122] = 30,				-- Frost Nova
				[2139] = 24,			-- Counterspell
				[1953] = 15,			-- Blink
				[120] = 12,				-- Cone of Cold
				[2136] = 8,				-- Fireblast
			},
		},
		["MONK"] = {
			[0] = { -- Unskilled
				[115203] = 180,			-- Fortifying Brew
				[137562] = 120,			-- Nimble Brew
				[115080] = 90,			-- Touch of Death
				[119996] = 25,			-- Transcendence: Transfer
				[109132] = {20, 2},		-- Roll
				[115072] = 15,			-- Expel Harm
				[115078] = 15,			-- Paralysis
				[116705] = 15,			-- Spear Hand Strike
				[115450] = 8,			-- Detox
			},
			[268] = { -- Brewmaster
				[115203] = 180,			-- Fortifying Brew
				[137562] = 120,			-- Nimble Brew
				[115080] = 90,			-- Touch of Death
				[115295] = {30, 2},		-- Guard
				[119996] = 25,			-- Transcendence: Transfer
				[109132] = {20, 2},		-- Roll
				[115072] = 15,			-- Expel Harm
				[115078] = 15,			-- Paralysis
				[116705] = 15,			-- Spear Hand Strike
				[115450] = 8,			-- Detox
			},
			[269] = { -- Windwalker
				[115176] = 180,			-- Zen Meditation
				[115203] = 180,			-- Fortifying Brew
				[137562] = 120,			-- Nimble Brew
				[122470] = 90,			-- Touch of Karma
				[115080] = 90,			-- Touch of Death
				[115288] = 60,			-- Energizing Brew
				[113656] = 25,			-- Fists of Fury
				[101545] = 25,			-- Flying Serpent Kick
				[119996] = 25,			-- Transcendence: Transfer
				[109132] = {20, 2},		-- Roll
				[115072] = 15,			-- Expel Harm
				[115078] = 15,			-- Paralysis
				[116705] = 15,			-- Spear Hand Strike
				[115450] = 8,			-- Detox
			},
			[270] = { -- Mistweaver
				[115310] = 180,			-- Revival
				[115203] = 180,			-- Fortifying Brew
				[137562] = 120,			-- Nimble Brew
				[116849] = 100,			-- Life Cocoon
				[115080] = 90,			-- Touch of Death
				[116680] = 45,			-- Thunder Focus Tea
				[119996] = 25,			-- Transcendence: Transfer
				[109132] = {20, 2},		-- Roll
				[115072] = 15,			-- Expel Harm
				[115078] = 15,			-- Paralysis
				[116705] = 15,			-- Spear Hand Strike
				[115450] = 8,			-- Detox
			},
		},		
		["PALADIN"] = {
			[0] = { -- Unskilled
				[642] = 300,			-- Divine Shield
				[1022] = 300,			-- Hand of Protection
				[6940] = 90,			-- Hand of Sacrifice
				[498] = 60,				-- Divine Protection
				[853] = 60,				-- Hammer of Justice
				[1044] = 25,			-- Hand of Freedom
				[96231] = 15,			-- Rebuke
			},
			[65] = { -- Holy
				[642] = 300,			-- Divine Shield
				[1022] = 300,			-- Hand of Protection
				[31842] = 180,			-- Avenging Wrath: Holy
				[31821] = 180,			-- Devotion Aura
				[6940] = 90,			-- Hand of Sacrifice
				[498] = 60,				-- Divine Protection
				[853] = 60,				-- Hammer of Justice
				[1044] = 25,			-- Hand of Freedom
				[96231] = 15,			-- Rebuke
				[4987] = 8,				-- Cleanse
			},
			[66] = { -- Protection
				[642] = 300,			-- Divine Shield
				[1022] = 300,			-- Hand of Protection
				[31850] = 180,			-- Ardent Defender
				[86659] = 180,			-- Guardian of the Ancient Kings
				[6940] = 90,			-- Hand of Sacrifice
				[498] = 60,				-- Divine Protection
				[853] = 60,				-- Hammer of Justice
				[1044] = 25,			-- Hand of Freedom
				[96231] = 15,			-- Rebuke
			},
			[70] = { -- Retribution
				[642] = 300,			-- Divine Shield
				[1022] = 300,			-- Hand of Protection
				[31884] = 120,			-- Avenging Wrath: Retribution
				[6940] = 90,			-- Hand of Sacrifice
				[498] = 60,				-- Divine Protection
				[853] = 60,				-- Hammer of Justice
				[1044] = 25,			-- Hand of Freedom
				[96231] = 15,			-- Rebuke
			},
		},
		["PRIEST"] = {
			[0] = { -- Unskilled
				[6346] = 180,			-- Fear Ward (Unglyhed)
				[34433] = 180,			-- Shadow Fiend
				[73325] = 90,			-- Leap of Faith
				[586] = 30,				-- Fade (Unglyhed)
				[32375] = 15,			-- Mass Dispel (Mass Dispel only for Shadow)
				[33076] = 10,			-- Prayer of Mending
			},
			[256] = { -- Disc
				[6346] = 180,			-- Fear Ward (Unglyhed)
				[34433] = 180,			-- Shadow Fiend
				[62618] = 180,			-- Power Word: Barrier
				[33206] = 120,			-- Pain Suppression (with Setbonus)
				[73325] = 90,			-- Leap of Faith
				[15487] = 45,			-- Silence (Unglyphed)
				[586] = 30,				-- Fade (Unglyhed)
				[81700] = 30,			-- Arch Angel
				--[32375] = 15,			-- Mass Dispel
				[14914] = 10,			-- Holy Fire
				[33076] = 10,			-- Prayer of Mending
				[527] = 8,				-- Purify
			},
			[257] = { -- Holy
				[6346] = 180,			-- Fear Ward (Unglyhed)
				[34433] = 180,			-- Shadow Fiend
				[64843] = 180,			-- Divine Hymn
				[126135] = 180,			-- Light Well
				[47788] = 120,			-- Guardian Spirit
				[73325] = 90,			-- Leap of Faith
				[88685] = 40,			-- Holy Word: Sanctuary
				[586] = 30,				-- Fade (Unglyhed)
				[88625] = 30,			-- Holy Word: Chastise
				--[32375] = 15,			-- Mass Dispel
				[34861] = 12,			-- Circle of Healing
				[14914] = 10,			-- Holy Fire
				[88684] = 10,			-- Holy Word: Serenity
				[33076] = 10,			-- Prayer of Mending
				[527] = 8,				-- Purify
			},
			[258] = { -- Shadow
				[6346] = 180,			-- Fear Ward (Unglyhed)
				[34433] = 180,			-- Shadow Fiend
				[47585] = 120,			-- Dispersion (Unglyphed)
				[73325] = 90,			-- Leap of Faith
				[64044] = 45,			-- Psychic Horror
				[15487] = 45,			-- Silence (Unglyphed)
				[586] = 30,				-- Fade (Unglyhed)
				[32375] = 15,			-- Mass Dispel
				[33076] = 10,			-- Prayer of Mending
				[129176] = 8,			-- Shadow Word: Death
			},
		},		
		["ROGUE"] = {
			[0] = { -- Unskilled
				--[114018] = 300,			-- Shroud of Concealment
				[14185] = 300,			-- Preparation
				[76577] = 180,			-- Smoke Bomb
				[2094] = 120,			-- Blind
				[5277] = 120,			-- Evasion
				[1856] = 120,			-- Vanish
				[31224] = 60,			-- Cloak of Shadows
				[2983] = 60,			-- Sprint
				[408] = 20,				-- Kidney Shot
				[1766] = 15,			-- Kick
				[1776] = 10,			-- Gouge
				[5938] = 10,			-- Shiv
			},
			[259] = { -- Assassination
				--[114018] = 300,			-- Shroud of Concealment
				[14185] = 300,			-- Preparation
				[76577] = 180,			-- Smoke Bomb
				[2094] = 120,			-- Blind
				[5277] = 120,			-- Evasion
				[1856] = 120,			-- Vanish
				[79140] = 120,			-- Vendetta
				[31224] = 60,			-- Cloak of Shadows
				[2983] = 60,			-- Sprint
				[408] = 20,				-- Kidney Shot
				[1766] = 15,			-- Kick
				[1776] = 10,			-- Gouge
				[5938] = 10,			-- Shiv
			},
			[260] = { -- Combat
				--[114018] = 300,			-- Shroud of Concealment
				[14185] = 300,			-- Preparation
				[13750] = 180,			-- Adrenaline Rush
				[76577] = 180,			-- Smoke Bomb
				[2094] = 120,			-- Blind
				[5277] = 120,			-- Evasion
				[51690] = 120,			-- Killing Spree
				[1856] = 120,			-- Vanish
				[31224] = 60,			-- Cloak of Shadows
				[2983] = 60,			-- Sprint
				[408] = 20,				-- Kidney Shot
				[1766] = 15,			-- Kick
				[1776] = 10,			-- Gouge
				[5938] = 10,			-- Shiv
			},
			[261] = { -- Subtlety
				--[114018] = 300,			-- Shroud of Concealment
				[14185] = 300,			-- Preparation
				[76577] = 180,			-- Smoke Bomb
				[2094] = 120,			-- Blind
				[5277] = 120,			-- Evasion
				[1856] = 120,			-- Vanish
				[31224] = 60,			-- Cloak of Shadows
				[51713] = 60,			-- Shadow Dance
				[2983] = 60,			-- Sprint
				[408] = 20,				-- Kidney Shot
				[1766] = 15,			-- Kick
				[1776] = 10,			-- Gouge
				[5938] = 10,			-- Shiv
			},
		},		
		["SHAMAN"] = {
			[0] = { -- Unskilled
				[2894] = 300,			-- Fire Elemental Totem
				[2062] = 300,			-- Earth Elemental Totem
				[8143] = 60,			-- Tremor Totem
				[5394] = 30,			-- Healing Stream Totem
				[2484] = 30,			-- Earthbind Totem
				[51514] = 45,			-- Hex
				[108269] = 45,			-- Capacitor Totem
				[8177] = 25,			-- Grounding Totem
				[57994] = 15,			-- Wind Shear		
				[73920] = 10,			-- Healing Rain
				[51886] = 8,			-- Cleanse Spirit
			},
			[262] = { -- Elemental
				[2894] = 300,			-- Fire Elemental Totem
				[2062] = 300,			-- Earth Elemental Totem
				[114050] = 180,			-- Ascendance: Elemental
				[79206] = 120,			-- Spirit Walker's Grace
				[8143] = 60,			-- Tremor Totem
				[30823] = 60,			-- Shamanistic Rage
				[5394] = 30,			-- Healing Stream Totem
				[2484] = 30,			-- Earthbind Totem
				[51514] = 45,			-- Hex
				[108269] = 45,			-- Capacitor Totem
				[51490] = 45,			-- Thunderstorm
				[8177] = 25,			-- Grounding Totem
				[57994] = 15,			-- Wind Shear		
				[165462] = 15,			-- Unleash Flame
				[73920] = 10,			-- Healing Rain
				[51886] = 8,			-- Cleanse Spirit
			},
			[263] = { -- Enhancement
				[2894] = 300,			-- Fire Elemental Totem
				[2062] = 300,			-- Earth Elemental Totem
				[114051] = 180,			-- Ascendance: Enhancement
				[51533] = 120,			-- Feral Spirit
				[58875] = 60,			-- Spirit Walk
				[30823] = 60,			-- Shamanistic Rage
				[8143] = 60,			-- Tremor Totem
				[5394] = 30,			-- Healing Stream Totem
				[2484] = 30,			-- Earthbind Totem
				[51514] = 45,			-- Hex
				[108269] = 45,			-- Capacitor Totem
				[8177] = 25,			-- Grounding Totem
				[57994] = 15,			-- Wind Shear
				[73920] = 10,			-- Healing Rain
				[51886] = 8,			-- Cleanse Spirit
			},
			[264] = { -- Restoration
				[2894] = 300,			-- Fire Elemental Totem
				[2062] = 300,			-- Earth Elemental Totem
				[114052] = 180,			-- Ascendance: Restoration
				--[108280] = 180,			-- Healing Tide Totem
				[98008] = 180,			-- Spirit Link Totem
				[79206] = 120,			-- Spirit Walker's Grace
				[8143] = 60,			-- Tremor Totem
				[5394] = 30,			-- Healing Stream Totem
				[2484] = 30,			-- Earthbind Totem
				[51514] = 45,			-- Hex
				[108269] = 45,			-- Capacitor Totem
				[8177] = 25,			-- Grounding Totem
				[57994] = 15,			-- Wind Shear	
				[73920] = 10,			-- Healing Rain
				[77130] = 8,			-- Purify Spirit
				[61295] = 5,			-- Riptide (with Improved Riptide Passive)
			},
		},
		["WARLOCK"] = {
			[0] = { -- Unskilled
				[104773] = 180,			-- Unending Resolve
				[132409] = 24,			-- Spell lock (Warlock)
			},
			[265] = { -- Affliction
				[104773] = 180,			-- Unending Resolve
				[113860] = 120,			-- Dark Soul: Misery
				[132409] = 24,			-- Spell lock (Warlock)
			},
			[266] = { -- Demonology
				[104773] = 180,			-- Unending Resolve
				[113861] = 120,			-- Dark Soul: Knowledge
				[105174] = 15,			-- Hand of Gul'dan 
				[109151] = 10,			-- Demonic Leap
				[103958] = 10,			-- Metamorphosis
				[132409] = 24,			-- Spell lock (Warlock)
			},
			[267] = { -- Destruction
				[104773] = 180,			-- Unending Resolve
				[113858] = 120,			-- Dark Soul: Instability
				[120451] = 60,			-- Flames of Xoroth
				[80240] = 20,			-- Havoc (With Enhanced Havoc Passive)
				[17962] = {12, 2},		-- Conflagrate
				[132409] = 24,			-- Spell lock (Warlock)
			},
		},
		["WARRIOR"] = {
			[0] = { -- Unskilled
				[64382] = 300,			-- Shattering Throw
				[5246] = 90,			-- Intimidating Shout
				[6544] = 45,			-- Heroic Leap
				[18499] = 30,			-- Berserker Rage
				[3411] = 30,			-- Intervene
				[23920] = 25,			-- Spell Reflection
				[100] = 20,				-- Charge
				[6552] = 15,			-- Pummel
				[156321] = {15,	2},		-- Shield Charge
				[57755] = 6,			-- Heroic Throw
			},
			[71] = { -- Arms
				[64382] = 300,			-- Shattering Throw
				[97462] = 180,			-- Rallying Cry
				[1719] = 180,			-- Recklessness
				[118038] = 120,			-- Die by the Sword
				[5246] = 90,			-- Intimidating Shout
				[6544] = 45,			-- Heroic Leap
				[18499] = 30,			-- Berserker Rage
				[3411] = 30,			-- Intervene
				[23920] = 25,			-- Spell Reflection
				[100] = 20,				-- Charge
				[167105] = 20, 			-- Colossus Smash
				[6552] = 15,			-- Pummel
				[156321] = {15,	2},		-- Shield Charge
				[12328] = 10,			-- Sweeping Strikes
				[57755] = 6,			-- Heroic Throw
				[6343] = 6,				-- Thunder Clap
			},
			[72] = { -- Fury
				[64382] = 300,			-- Shattering Throw
				[97462] = 180,			-- Rallying Cry
				[1719] = 180,			-- Recklessness
				[118038] = 120,			-- Die by the Sword
				[5246] = 90,			-- Intimidating Shout
				[6544] = 45,			-- Heroic Leap
				[18499] = 30,			-- Berserker Rage
				[3411] = 30,			-- Intervene
				[23920] = 25,			-- Spell Reflection
				[100] = 20,				-- Charge
				[6552] = 15,			-- Pummel
				[156321] = {15,	2},		-- Shield Charge
				[57755] = 6,			-- Heroic Throw
				[23881] = 4.5,			-- Bloodthirst
			},
			[73] = { -- Protection
				[64382] = 300,			-- Shattering Throw
				[12975] = 180,			-- Last Stand
				[871] = 180,			-- Shield Wall
				[5246] = 90,			-- Intimidating Shout
				[1160] = 60,			-- Demoralizing Shout
				[6544] = 45,			-- Heroic Leap
				[18499] = 30,			-- Berserker Rage
				[3411] = 30,			-- Intervene
				[23920] = 25,			-- Spell Reflection
				[100] = 20,				-- Charge
				[6552] = 15,			-- Pummel
				[156321] = {15,	2},		-- Shield Charge
				[2565] = 12,			-- Shield Block
				[6572] = 9,				-- Revenge
				[23922] = 6,			-- Shield Slam
				[6343] = 6,				-- Thunder Clap
			},
		},
	},
	["CooldownTalentInfo"] = {
		["DEATHKNIGHT"] = {
			[19166] = { -- Plague Leech
				["action"] = "ADD",
				["spellID"] = 123693,
				["value"] = 25,
			},
			[19217] = { -- Unholy Blight
				["action"] = "ADD",
				["spellID"] = 115989,
				["value"] = 90,
			},
			[19218] = { -- Lichborne
				["action"] = "ADD",
				["spellID"] = 49039,
				["value"] = 120,
			},
			[19219] = { -- Anti-Magic Zone
				["action"] = "ADD",
				["spellID"] = 51052,
				["value"] = 120,
			},
			[19221] = { -- Death's Advance
				["action"] = "ADD",
				["spellID"] = 96268,
				["value"] = 30,				
			},
			[19223] = { -- Asphyxiate
				["action"] = "REPLACE",
				["spellID"] = 108194,
				["replace"] = 47476,
				["value"] = 30,				
			},  
			[19226] = { -- Death Pact
				["action"] = "ADD",
				["spellID"] = 48743,
				["value"] = 120,				
			}, 
			[19230] = { -- Gorefiend's Grasp
				["action"] = "ADD",
				["spellID"] = 108199,
				["value"] = 60,				
			},
			[19231] = { -- Remorseless Winter
				["action"] = "ADD",
				["spellID"] = 108200,
				["value"] = 60,				
			}, 
			[19232] = { -- Desecrated Ground
				["action"] = "ADD",
				["spellID"] = 108201,
				["value"] = 120,				
			}, 
			[21208] = { -- Defile
				["action"] = "ADD",
				["spellID"] = 152280,
				["value"] = 30,				
			},
			[21209] = { -- Breath of Sindragosa
				["action"] = "ADD",
				["spellID"] = 152279,
				["value"] = 120,				
			},
		},
		["DRUID"] = { 
			[18570] = { -- Displacer Beast
				["action"] = "ADD",
				["spellID"] = 102280,
				["value"] = 30,				
			},
			[18571] = { -- Wild Charge
				["action"] = "ADD",
				["spellID"] = 132302,
				["value"] = 15,				
			},  
			[19283] = { -- Renewal
				["action"] = "ADD",
				["spellID"] = 108238,
				["value"] = 120,				
			},
			[18574] = { -- Cenarion Ward
				["action"] = "ADD",
				["spellID"] = 102351,
				["value"] = 30,				
			},  
			[18576] = { -- Mass Entanglement
				["action"] = "ADD" ,
				["spellID"] = 102359,
				["value"] = 30,				
			}, 
			[18577] = { -- Typhoon
				["action"] = "ADD",
				["spellID"] = 132469,
				["value"] = 30,				
			},
			[18579] = { -- Incarnation: Chosen of Elune
				["action"] = "ADD",
				["spellID"] = 102560,
				["value"] = 180,				
			},
			[21705] = { -- Incarnation: King of the Jungle
				["action"] = "ADD",
				["spellID"] = 102543,
				["value"] = 180,				
			}, 
			[21706] = { -- Incarnation: Son of Ursoc
				["action"] = "ADD",
				["spellID"] = 102558,
				["value"] = 180,				
			},
			[21707] = { -- Incarnation: Tree of Life
				["action"] = "ADD",
				["spellID"] = 33891,
				["value"] = 180,				
			}, 
			[21710] = { -- Force of Nature
				["action"] = "ADD",
				["spellID"] = 102693,
				["value"] = {20, 3},				
			},
			[18581] = { -- Incapacitating Shout
				["action"] = "ADD",
				["spellID"] = 99,
				["value"] = 30,				
			},
			[18582] = { -- Ursol's Vortex
				["action"] = "ADD",
				["spellID"] = 102793,
				["value"] = 60,				
			}, 
			[18583] = { -- Mighty Bash
				["action"] = "ADD",
				["spellID"] = 5211,
				["value"] = 50,				
			}, 
			[18584] = { -- Heart of the Wild: Balance
				["action"] = "ADD",
				["spellID"] = 108291,
				["value"] = 360,				
			},
			[21714] = { -- Heart of the Wild: Feral
				["action"] = "ADD",
				["spellID"] = 108292,
				["value"] = 360,				
			}, 
			[21715] = { -- Heart of the Wild: Guardian
				["action"] = "ADD",
				["spellID"] = 108293,
				["value"] = 360,				
			}, 
			[21716] = { -- Heart of the Wild: Restoration
				["action"] = "ADD",
				["spellID"] = 108294,
				["value"] = 360,				
			}, 
			[18568] = { -- Nature's Vigil
				["action"] = "ADD",
				["spellID"] = 124974,
				["value"] = 90,				
			}, 	
		},  
		["HUNTER"] = { 
			[19364] = { -- Crouching Tiger, Hidden Chimaera
				["action"] = {"MODIFY_COOLDOWN", "REPLACE"},
				["spellID"] = {781, 148467},
				["replace"] = { nil, 19263},
				["value"] = {-10, {120, 2}},
			},  
			[19347] = { -- Binding Shot
				["action"] = "ADD",
				["spellID"] = 109248,
				["value"] = 45,				
			}, 
			[19348] = { -- Wyvern Sting
				["action"] = "ADD",
				["spellID"] = 19386,
				["value"] = 45,				
			}, 
			[19359] = { -- Intimidation
				["action"] = "ADD",
				["spellID"] = 19577,
				["value"] = 60,				
			}, 
			[19350] = { -- Exhilaration
				["action"] = "ADD",
				["spellID"] = 109304,
				["value"] = 120,				
			},    
			[19353] = { -- Dire Beast
				["action"] = "ADD",
				["spellID"] = 120679,
				["value"] = 30,				
			},
			[19360] = { -- A Murder of Crows
				["action"] = "ADD",
				["spellID"] = 131894,
				["value"] = 60,				
			},
			[19362] = { -- Stampede
				["action"] = "ADD",
				["spellID"] = 121818,
				["value"] = 300,				
			},  
			[19357] = { -- Glaive Toss
				["action"] = "ADD",
				["spellID"] = 117050,
				["value"] = 15,				
			},
			[19358] = { -- Powershot
				["action"] = "ADD",
				["spellID"] = 109259,
				["value"] = 45,				
			},
			[19349] = { -- Barrage
				["action"] = "ADD",
				["spellID"] = 120360,
				["value"] = 20,				
			},			
		},
		["MAGE"] = {
			[21689] = { -- Evanesce
				["action"] = "REPLACE",
				["spellID"] = 157913,
				["replace"] = 45438,
				["value"] = 45,			
			},
			[21689] = { -- Blazing Speed
				["action"] = "ADD",
				["spellID"] = 108843,
				["value"] = 25,			
			},
			[16023] = { -- Alter Time
				["action"] = "ADD",
				["spellID"] = 108978,
				["value"] = 90,			
			},
			[16025] = { -- Ice Barrier
				["action"] = "ADD",
				["spellID"] = 11426,
				["value"] = 25,			
			},
			[16019] = { -- Ring of Frost
				["action"] = "ADD",
				["spellID"] = 113724,
				["value"] = 45,			
			},
			[16020] = { -- Ice Ward
				["action"] = "ADD",
				["spellID"] = 111264,
				["value"] = 20,			
			},
			[16021] = { -- Frostjaw
				["action"] = "ADD",
				["spellID"] = 102051,
				["value"] = 20,			
			},
			[16027] = { -- Greater Invisibility
				["action"] = "REPLACE",
				["spellID"] = 110959,
				["replace"] = 66,
				["value"] = 90,			
			},
			[16029] = { -- Cold Snap
				["action"] = "ADD",
				["spellID"] = 11958,
				["value"] = 180,			
			},
			[21692] = { -- Blast Wave
				["action"] = "REPLACE",
				["spellID"] = 157981,
				["replace"] = 122,
				["value"] = 25,			
			},
			[19301] = { -- Supernova
				["action"] = "REPLACE",
				["spellID"] = 157980,
				["replace"] = 122,
				["value"] = 25,			
			},
			[21693] = { -- Ice Nova
				["action"] = "REPLACE",
				["spellID"] = 157997,
				["replace"] = 122,
				["value"] = 25,			
			},
			[16031] = { -- Mirror Images
				["action"] = "ADD",
				["spellID"] = 55342,
				["value"] = 120,			
			},
			[21144] = { -- Prismatic Crystal
				["action"] = "ADD",
				["spellID"] = 152087,
				["value"] = 90,			
			},
			[21145] = { -- Arcane Orb
				["action"] = "ADD",
				["spellID"] = 153626,
				["value"] = 15,			
			},
			[21633] = { -- Meteor
				["action"] = "ADD",
				["spellID"] = 153561,
				["value"] = 45,			
			},
			[21634] = { -- Comet Storm
				["action"] = "ADD",
				["spellID"] = 153595,
				["value"] = 30,			
			},

		},		
		["MONK"] = {   
			[19302] = { -- Celerity
				["action"] = {"MODIFY_COOLDOWN", "MODIFY_CHARGES" },
				["spellID"] = {115008, 115008},
				["value"] = {-5, 1},			
			},
			[19818] = { -- Tiger's Lust
				["action"] = "ADD",
				["spellID"] = 116841,
				["value"] = 30,			
			},
			[20185] = { -- Chi Wave
				["action"] = "ADD",
				["spellID"] = 115098,
				["value"] = 15,			
			},
			[19820] = { -- Zen Sphere
				["action"] = "ADD",
				["spellID"] = 124081,
				["value"] = 10,			
			},
			[19823] = { -- Chi Burst
				["action"] = "ADD",
				["spellID"] = 123986,
				["value"] = 30,			
			},
			[19772] = { -- Chi Brew
				["action"] = "ADD",
				["spellID"] = 115399,
				["value"] = {60, 2},			
			},
			[19993] = { -- Ring of Peace
				["action"] = "ADD",
				["spellID"] = 116844,
				["value"] = 45,			
			},
			[19994] = { -- Charging Ox Wave
				["action"] = "ADD",
				["spellID"] = 119392,
				["value"] = 30,			
			},
			[19995] = { -- Leg Sweep
				["action"] = "ADD",
				["spellID"] = 119381,
				["value"] = 45,			
			}, 
			[20175] = { -- Dampen Harm
				["action"] = "ADD",
				["spellID"] = 122278,
				["value"] = 90,			
			},
			[20173] = { -- Diffuse Magic
				["action"] = "ADD",
				["spellID"] = 122783,
				["value"] = 90,			
			},  
			[19819] = { -- Rushing Jade Wind
				["action"] = "ADD",
				["spellID"] = 116847,
				["value"] = 6,			
			},
			[20184] = { -- Invoke Xuen, the White Tiger
				["action"] = "ADD",
				["spellID"] = 123904,
				["value"] = 180,			
			},
			[19313] = { -- Chi Torpedo
				["action"] = "REPLACE",
				["spellID"] = 115008,
				["replace"] = 109132,
				["value"] = {20, 2},			
			},
			[21189] = { -- Hurricane Strike
				["action"] = "ADD",
				["spellID"] = 152175,
				["value"] = 45,			
			},
			[21191] = { -- Serenity
				["action"] = "ADD",
				["spellID"] = 152173,
				["value"] = 90,			
			},
			[21676] = { -- Breath of the Serpent
				["action"] = "ADD",
				["spellID"] = 157535,
				["value"] = 90,			
			},			
		},
		["PALADIN"] = {
			[17565] = { -- Speed of Light
				["action"] = "ADD",
				["spellID"] = 85499,
				["value"] = 45,			
			},
			[17573] = { -- Fist of Justice
				["action"] = "REPLACE",
				["spellID"] = 105593,
				["replace"] = 853,
				["value"] = 30,
			},
			[17575] = { -- Repentence
				["action"] = "ADD",
				["spellID"] = 20066,
				["value"] = 15,
			},
			[17577] = { -- Blinding Light
				["action"] = "ADD",
				["spellID"] = 115750,
				["value"] = 120,
			},
			[17589] = { -- Hand of Purity
				["action"] = "ADD",
				["spellID"] = 114039,
				["value"] = 30,
			},
			[17591] = { -- Unbreakable Will
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = {498, 642},
				["value"] = function(baseValue) return baseValue * 0.5; end,
			},
			[17593] = { -- Clemency
				["action"] = "MODIFY_CHARGES",
				["spellID"] = {1044, 1022, 6940},
				["value"] = 1,
			},
			[17597] = { -- Holy Avenger 
				["action"] = "ADD",
				["spellID"] = 105809,
				["value"] = 120,				
			},
			[17605] = { -- Holy Prism
				["action"] = "ADD",
				["spellID"] = 114165,
				["value"] = 20,	
			},
			[17607] = { -- Light's Hammer
				["action"] = "ADD",
				["spellID"] = 114158,
				["value"] = 60,	
			},
			[17609] = { -- Execution Sentence
				["action"] = "ADD",
				["spellID"] = 114157,
				["value"] = 60,	
			},
			[21202] = { -- Seraphim
				["action"] = "ADD",
				["spellID"] = 152262,
				["value"] = 30,
			},
		},
		["PRIEST"] = {
			[19752] = { -- Desperate Prayer
				["action"] = "ADD",
				["spellID"] = 19236,
				["value"] = 120,
			},
			[19753] = { -- Spectral Guise
				["action"] = "ADD",
				["spellID"] = 112833,
				["value"] = 30,
			},		
			[19754] = { -- Angelic Bulwark
				["action"] = "ADD",
				["spellID"] = 114214,
				["value"] = 90,
			},
			[19757] = { -- Angelic Feather
				["action"] = "ADD",
				["spellID"] = 121536,
				["value"] = {10, 3},
			},
			[19769] = { -- Mind Bender
				["action"] = "REPLACE",
				["spellID"] = 123040,
				["replace"] = 34433,
				["value"] = 60,
			},
			[19762] = { -- Void Tendrils
				["action"] = "ADD",
				["spellID"] = 108920,
				["value"] = 30,
			},		
			[19768] = { -- Psychic Scream
				["action"] = "ADD",
				["spellID"] = 8122,
				["value"] = 30,				-- With PvP-Glove Bonus
			},								
			[19765] = { -- Power Infusion
				["action"] = "ADD",
				["spellID"] = 10060,
				["value"] = 120,
			},
			[21754] = { -- Spirit Shell
				["action"] = "ADD",
				["spellID"] = 109964,
				["value"] = 60,
			},
			[19767] = { -- Cascade
				["action"] = "ADD",
				["spellID"] = 121135,
				["value"] = 25,
			},					
			[19760] = { -- Divine Star
				["action"] = "ADD",
				["spellID"] = 110744,
				["value"] = 15,
			},					
			[19763] = { -- Halo
				["action"] = "ADD",
				["spellID"] = 120517,
				["value"] = 40,
			},					
			[21718] = { -- Cascade (Shadow)
				["action"] = "ADD",
				["spellID"] = 127632,
				["value"] = 25,
			},					
			[21719] = { -- Divine Star (Shadow)
				["action"] = "ADD",
				["spellID"] = 122121,
				["value"] = 15,
			},					
			[21720] = { -- Halo (Shadow)
				["action"] = "ADD",
				["spellID"] = 120644,
				["value"] = 40,
			},
		},
		["ROGUE"] = {
			[19238] = { -- Combat Readiness
				["action"] = "ADD",
				["spellID"] = 74001,
				["value"] = 120,
			},
			[19243] = { -- Shadowstep
				["action"] = "ADD",
				["spellID"] = 36554,
				["value"] = 20,
			},
			[19249] = { -- Marked for Death
				["action"] = "ADD",
				["spellID"] = 137619,
				["value"] = 60,
			},
			[21187] = { -- Shadow Reflection
				["action"] = "ADD",
				["spellID"] = 152151,
				["value"] = 60,
			},
			[21188] = { -- Death from Above
				["action"] = "ADD",
				["spellID"] = 152150,
				["value"] = 60,
			},
		},
		["SHAMAN"] = {
			[19263] = { -- Stone Bulwark Totem
				["action"] = "ADD",
				["spellID"] = 108270,
				["value"] = 60,
			},
			[19264] = { -- Astral Shift
				["action"] = "ADD",
				["spellID"] = 108271,
				["value"] = 90,
			},
			[19260] = { -- Earthgrab Totem
				["action"] = "ADD",
				["spellID"] = 51485,
				["value"] = 30,
			},
			[19261] = { -- Windwalk Totem
				["action"] = "ADD",
				["spellID"] = 108273,
				["value"] = 10,
			}, 
			[19275] = { -- Call of the Elements
				["action"] = "ADD",
				["spellID"] = 108285,
				["value"] = 180,
			},	
			[19276] = { -- Totemic Projection
				["action"] = "ADD",
				["spellID"] = 108287,
				["value"] = 10,
			}, 
			[19271] = { -- Elemental Mastery
				["action"] = "ADD",
				["spellID"] = 16166,
				["value"] = 120,
			},
			[19272] = { -- Ancestral Swiftness
				["action"] = "ADD",
				["spellID"] = 16188,
				["value"] = 90,
			},
			[19273] = { -- Echo of the Elements
				["action"] = "MODIFY_CHARGES",
				["spellID"] = {61295, 98008},
				["value"] = 1,
			},
			[19269] = { -- Ancestral Guidance
				["action"] = "ADD",
				["spellID"] = 108281,
				["value"] = 120,
			},
			[19267] = { -- Elemental Blast
				["action"] = "ADD",
				["spellID"] = 117014,
				["value"] = 120,
			},
			[21674] = { -- Cloudburst Totem
				["action"] = "ADD",
				["spellID"] = 157153,
				["value"] = 30,
			},
			[21199] = { -- Storm Elemental Totem
				["action"] = "ADD",
				["spellID"] = 152256,
				["value"] = 300,
			},
			[21200] = { -- Liquid Magma
				["action"] = "ADD",
				["spellID"] = 152255,
				["value"] = 45,
			},
		}, 		
		["WARLOCK"] = {
			[19279] = { -- Dark Regeneration
				["action"] = "ADD",
				["spellID"] = 108359,
				["value"] = 120,
			},
			[19284] = { -- Howl of Terror
				["action"] = "ADD",
				["spellID"] = 5484,
				["value"] = 40,
			},
			[19285] = { -- Mortal Coil
				["action"] = "ADD",
				["spellID"] = 6789,
				["value"] = 45,
			},
			[19286] = { -- Shadowfury
				["action"] = "ADD",
				["spellID"] = 30283,
				["value"] = 30,
			},
			[19288] = { -- Sacrificial Pact
				["action"] = "ADD",
				["spellID"] = 108416,
				["value"] = 60,
			},
			[19289] = { -- Dark Bargain
				["action"] = "ADD",
				["spellID"] = 110913,
				["value"] = 180,
			},
			[19290] = { -- Blood Horror
				["action"] = "ADD",
				["spellID"] = 111397,
				["value"] = 60,
			},
			[19292] = { -- Unbound Will
				["action"] = "ADD",
				["spellID"] = 108482,
				["value"] = 120,
			}, 
			[19294] = { -- Grimoire of Service
				["action"] = "ADD",
				["spellID"] = 108501,
				["value"] = 120,
			},
			[19295] = { -- Grimoire of Sacrifice
				["action"] = "ADD",
				["spellID"] = 108503,
				["value"] = 30,
			},
			[19296] = { -- Archimonde's Darkness
				["action"] = "MODIFY_CHARGES",
				["spellID"] = {113861, 113860, 113858},
				["value"] = 1,
			}, 
			[19297] = { -- Kil'jaeden's Cunning
				["action"] = "ADD",
				["spellID"] = 137587,
				["value"] = 60,
			},
			[19298] = { -- Mannoroth's Fury
				["action"] = "ADD",
				["spellID"] = 108508,
				["value"] = 30,
			},
			[21181] = { -- Cataclysm
				["action"] = "ADD",
				["spellID"] = 152108,
				["value"] = 60,
			},
		},
		["WARRIOR"] = {
			[15775] = { -- Juggernaut
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 100,
				["value"] = -8,
			},
			[16035] = { -- Double Time
				["action"] = "MODIFY_CHARGES",
				["spellID"] = 100,
				["value"] = 1,
			},
			[16036] = { -- Enraged Regeneration
				["action"] = "ADD",
				["spellID"] = 55694,
				["value"] = 60,
			},  
			[15759] = { -- Storm Bolt
				["action"] = "ADD",
				["spellID"] = 107570,
				["value"] = 30,
			},
			[15760] = { -- Shockwave
				["action"] = "ADD",
				["spellID"] = 46968,
				["value"] = 40,
			},
			[16037] = { -- Dragon Roar
				["action"] = "ADD",
				["spellID"] = 118000,
				["value"] = 60,
			},
			[15765] = { -- Mass Spell Reflection
				["action"] = "ADD",
				["spellID"] = 114028,
				["value"] = 30,
			},
			[15766] = { -- Safeguard
				["action"] = "ADD",
				["spellID"] = 114029,
				["value"] = 30,
			},
			[19676] = { -- Vigilance
				["action"] = "ADD",
				["spellID"] = 114030,
				["value"] = 30,
			},  
			[19138] = { -- Avatar
				["action"] = "ADD",
				["spellID"] = 107574,
				["value"] = 90,
			},   
			[19139] = { -- Bloodbath
				["action"] = "ADD",
				["spellID"] = 12292,
				["value"] = 60,
			},
			[19140] = { -- Bladestorm
				["action"] = "ADD",
				["spellID"] = 46924,
				["value"] = 60,
			}, 
			[21205] = { -- Ravager
				["action"] = "ADD",
				["spellID"] = 152277,
				["value"] = 60,
			},
			[21760] = { -- Siegebreaker
				["action"] = "ADD",
				["spellID"] = 176289,
				["value"] = 45,
			},
		},
	},
	["CooldownGlyphInfo"] = {
		["DEATHKNIGHT"] = {
			[63331] = { -- Glyph of Dark Simulacrum
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 77606,
				["value"] = -30,
			},
			[58673] = { -- Glyph of Icebound Fortitude
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 48792,
				["value"] = function(baseValue) return baseValue * 0.5; end,
			},
			[58686] = { -- Glyph of Mind Freeze
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 47528,
				["value"] = -1,
			},
			[59332] = { -- Glyph of Outbreak
				["action"] = "REMOVE",
				["spellID"] = 77575,
			},
			[159428] = { -- Glyph of Rune Tap
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 48982,
				["value"] = -10,
			},
		},		
		["DRUID"] = {
			[116216] = { -- Glyph of Skull Bash
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 106839,
				["value"] = 5,
			},
			[114223] = { -- Glyph of Survival Instincts
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 61336,
				["value"] = -40,
			},
			[59219] = { -- Glyph of Dash
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 1850,
				["value"] = -60,
			},
		},
		["HUNTER"] = {
			[119384] = { -- Glyph of Tranquilizing Shot (it adds a 10 sec cooldown to a spell normally not having a CD. That's why I use "ADD" here)
				["action"] = "ADD",
				["spellID"] = 1850,
				["value"] = 19801,
			},
		},
		["MAGE"] = {
			[62210] = { -- Glyph of Arcane Power
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 12042,
				["value"] = function(baseValue) return baseValue * 2; end,
			},
			[56368] = { -- Glyph of Combustion
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 11129,
				["value"] = function(baseValue) return baseValue * 2; end,
			},
			[115703] = { -- Glyph of Counterspell
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 2139,
				["value"] = 4,
			},
			[115703] = { -- Glyph of Frost Nova
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 122,
				["value"] = -5,
			},
		},
		["MONK"] = {
			[123761] = { -- Glyph of Mana Tea
				["action"] = "REPLACE",
				["spellID"] = 123761,
				["replace"] = 115294,
				["value"] = 10,
			},
			[123391] = { -- Glyph of Touch of Death
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 1850,
				["value"] = 120,
			},
			[123023] = { -- Glyph of Transcendence
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 119996,
				["value"] = -5,
			},
		},
		["PALADIN"] = {
			[146955] = { -- Glyph of Devotion Aura
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 31821,
				["value"] = -60,
			},
			[162604] = { -- Glyph of Merciful Wrath
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 31842,
				["value"] = function(baseValue) return baseValue * 0.5; end,
			},
		},
		["PRIEST"] = {
			[55678] = {	-- Glyph of Fear Ward
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 6346,
				["value"] = -60,
			},
			[159628] = { -- Glyph of Shadow Magic
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 586,
				["value"] = 60,
				["newPriority"] = 23,
			},
			[63229] = { -- Glyph of Dispersion
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 47585,
				["value"] = -15,
			},
			[55688] = { -- Glyph of Psychic Horror
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 64044,
				["value"] = -10,
			},
			
		},
		["ROGUE"] = {
			[56810] = { -- Glyph of Shiv
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 152150,
				["value"] = -3,
			},
			[159635] = { -- Glyph of Elusiveness
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 5277,
				["value"] = -30,
			},
			[56805] = { -- Glyph of Kick
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 1766,
				["value"] = 4,
			},
			[159638] = { -- Glyph of Disappearance
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 1856,
				["value"] = -60,
			},
		},
		["SHAMAN"] = {
			[159643] = { -- Glyph of Grounding
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 8177,
				["value"] = -3,
			},
			[55441] = { -- Glyph of Grounding Totem
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 8177,
				["value"] = 20,
			},
			[63291] = { -- Glyph of Hex
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 51514,
				["value"] = -10,
			},
			[55439] = { -- Glyph of Purge
				["action"] = "ADD",
				["spellID"] = 370,
				["value"] = 6,
			},
			[63273] = { -- Glyph of Riptide
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 61295,
				["value"] = function(baseValue) return 0; end,
			},
			[159648] = { -- Glyph of Shamanistic Resolve
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 30823,
				["value"] = 60,
			},
			[55454] = { -- Glyph of Spirit Walk
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 58875,
				["value"] = function(baseValue) return baseValue * 0.75; end,
			},
			[159650] = { -- Glyph of Spiritwalker's Focus
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 79206,
				["value"] = -60,
			},
			[63270] = { -- Glyph of Thunder
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 63270,
				["value"] = -10,
			},
			[55451] = { -- Glyph of Wind Shear
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 57994,
				["value"] = 3,
			},
			[159640] = { -- Glyph of Ephemeral Spirits
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 51533,
				["value"] = -60,
			},
			[55455] = { -- Glyph of Disappearance
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 2894,
				["value"] = function(baseValue) return baseValue * 0.5; end,
			},
		},
		["WARLOCK"] = {
			[159665] = { -- Glyph of Dark Soul
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = {113861, 113860, 113858},
				["value"] = function(baseValue) return baseValue * 0.5; end,
			},
			[146964] = { -- Glyph of Unending Resolve
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 104773,
				["value"] = -60,
			},
			[159697] = { -- Glyph of Strengthened Resolve
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 104773,
				["value"] = 60,
			},
			[146962] = { -- Glyph of Havoc
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 80240,
				["value"] = 35,
			},
			[148683] = { -- Glyph of Eternal Resolve
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 148688,
				["value"] = function(baseValue) return 0; end,
			},
			[63309] = { -- Glyph of Demonic Circle
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 48020,
				["value"] = -4,
			},
		},
		["WARRIOR"] = {
			[63325] = { -- Glyph of Death from Above (Heroic Leap)
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 6544,
				["value"] = -15,
			},
			[58356] = { -- Glyph of Resonating Power
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 6343,
				["value"] = function(baseValue) return baseValue * 1.5; end,
			},
			[63329] = { -- Glyph of Shield Wall
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 871,
				["value"] = 120,
			},
			[63328] = { -- Glyph of Spell Reflection
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 23920,
				["value"] = -5,
			},
		},
	},
};
function ArenaLiveSpectator:GetCooldownPriority (spellID, class, specID)
	
	if ( ArenaLiveSpectator.SpellDB.CooldownPriorities[spellID] ) then
		return ArenaLiveSpectator.SpellDB.CooldownPriorities[spellID];
	elseif ( not class or not specID or not spellID ) then
		ArenaLive:Message(L["%s: Usage %s"], "error", "ArenaLiveSpectator:GetCooldownPriority()", "ArenaLiveSpectator:GetCooldownPriority(class, specID, spellID)");
	else
		return ArenaLiveSpectator.SpellDB.CooldownPriorities[class][specID][spellID];
	end
end

function ArenaLiveSpectator:GetCooldownInfo (class, infoType, id)

	local tableMod;
	if ( infoType == "glyph" ) then
		tableMod = "CooldownGlyphInfo";
	elseif ( infoType == "talent" ) then
		tableMod = "CooldownTalentInfo";
	else
		return nil;
	end

	if ( ArenaLiveSpectator.SpellDB[tableMod][class] and ArenaLiveSpectator.SpellDB[tableMod][class][id] ) then
		return ArenaLiveSpectator.SpellDB[tableMod][class][id].action, ArenaLiveSpectator.SpellDB[tableMod][class][id].spellID, ArenaLiveSpectator.SpellDB[tableMod][class][id].value, ArenaLiveSpectator.SpellDB[tableMod][class][id].replace, ArenaLiveSpectator.SpellDB[tableMod][class][id].newPriority;
	else
		return nil;
	end
end