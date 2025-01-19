ArenaLive.spellDB = {
			["Trinket"] = { 42292, 120 }, -- SpellID and cooldown of the PvP-Trinket
			["Racials"] = {
					-- First Number is the SpellID, 2nd one is the CD and 3rd is the shared CD with the PvP-Trinket. Use 0 if they don't have a shared CD.
					["Human"] = { 59752, 120, 120 },
					["Dwarf"] = { 20594, 120, 0 },
					["NightElf"] = { 58984, 120, 0 },
					["Gnome"] = { 20589, 90, 0 },
					["Draenei"] = { -- For some reason, as a Draenei every class has it's own "Gift of the Naaru" spell. So we have to add them all into the table
						["WARRIOR"] =  { 28880, 180, 0 },
						["PALADIN"] = { 59542, 180, 0 },
						["HUNTER"] = { 59543, 180, 0 },
						["PRIEST"] = { 59544, 180, 0 },
						["DEATHKNIGHT"] = { 59545, 180, 0 },
						["SHAMAN"] = { 59547, 180, 0 },
						["MAGE"] = { 59548, 180, 0 },
						["MONK"] = { 121093, 180, 0 } -- Need to test this as soon as MoP is out.
					},
					["Worgen"] = { 68992, 120, 0 },
					["Orc"] = { -- Since Orcs also have class-specific racials, we need to add all of them
						["WARRIOR"] = { 20572, 120, 0 },
						["HUNTER"] = { 20572, 120, 0 },
						["ROGUE"] = { 20572, 120, 0 },
						["SHAMAN"] = { 33697, 120, 0 },
						["MAGE"] = { 33702, 120, 0 },
						["WARLOCK"] = { 33702, 120, 0 },
						["DEATHKNIGHT"] = { 20572, 120, 0 },
						["MONK"] = { 33697, 120, 0 } -- I guess Monks will get the same racial version as Shamans, since it increases AP+Spell Power. Test this as soon as MoP is out
					},
					["Scourge"] = { 7744, 120, 30 },
					["Tauren"] = { 20549, 120, 0 },
					["Troll"] = { 26297, 180, 0 },
					["BloodElf"] = {
						["WARRIOR"] = { 69179, 120, 0},
						["PALADIN"] = { 28730, 120, 0 },
						["HUNTER"] = { 80483, 120, 0},
						["ROGUE"] = { 25046, 120, 0 },
						["PRIEST"] = { 28730, 120, 0 },
						["MAGE"] = { 28730, 120, 0 },
						["WARLOCK"] = { 28730, 120, 0 },
						["DEATHKNIGHT"] = { 50613, 120, 0 },
						["MONK"] = { 129597, 120, 0 }
					},
					["Goblin"] = { 69070, 120, 0 },
					["Pandaren"] = { 107079, 120, 0 }
			},
			
			["CCIndicator"] = { -- This table is used to track those spells, that are shown in the cc indcator.
				-- The order is [spellID] = Priority-Type.
				-- TODO: match to https://github.com/ManneN1/BigDebuffs-MoP/blob/main/BigDebuffs.lua

				-- Death Knight
				[48707] = "defCD",			-- Anti-Magic Shell
				[48792] = "defCD",			-- Icebound Fortitude
				[49039] = "defCD",			-- Lichborne
				[51271] = "offCD", 			-- Pillar of Frost
				[49016] = "offCD",			-- Unholy Frenzy
				[91800] = "stun",			-- Gnaw (Petstun)
				[91797] = "stun", 			-- Monstrous Blow (Petstun)
				[115001] = "stun",			-- Remorseless Winter (stun)
				[108194] = "stun",			-- Asphyxiate
				[47476] = "silence",		-- Strangulate
				[96294] = "root",			-- Chains of Ice (root)
				[91807] = "root", 			-- Pet Leap Root
				[115001] = "stun",			-- Remorseless
				
				-- Druid
				[33786] = "defCD",			-- Cyclone (Made that one a def CD, because the enemy is immune to everything during cyclone)
				[110617] = "defCD",			-- Deterrence (Symbiosis)
				[102795] = "stun",			-- Bear Hug
				[22570] = "stun",			-- Maim
				[5211] = "stun",			-- Mighty Bash
				[9005] = "stun",			-- Pounce (stun)
				[102546] = "stun",			-- Pounce (stun, maybe the nonferalversion or something)
				[113801] = "stun",			-- Bash (Treant)
				[78675] = "silence",		-- Solar Beam
				[114238] = "silence",		-- Fae Silence (Glyph of Fae Silence)
				[2637] = "crowdControl",	-- Hibernate
				[99] = "crowdControl",		-- Disorienting Roar
				[113056] = "crowdControl",	-- Intimidating Roar (cower)
				[113004] = "crowdControl",	-- Intimidating Roar (flee)
				[339] = "root",				-- Entangling roots
				[19975] = "root",			-- Entangling roots (Nature's Grasp)
				[113770] = "root",			-- Treant root
				[16979] = "root",			-- Feral Charge (root)
				[102359] = "root",			-- Mass Entanglement
				[29166] = "usefulBuffs",	-- Innervate
				[106951] = "offCD",			-- Berserk
				[108291] = "offCD", 		-- Heart of the Wild
				[108292] = "offCD", 		-- Heart of the Wild
				[108293] = "offCD", 		-- Heart of the Wild
				[108294] = "offCD", 		-- Heart of the Wild
				[132158] = "offCD", 		-- Nature's Swiftness

				-- Hunter
				[5384] = "defCD",			-- Feign Death
				[19263] = "defCD",			-- Deterrence
				[117526] = "stun",			-- Binding Shot
				[19577] = "stun",			-- Intimidation (stun)			
				[90337] = "stun",			-- Bad Manner (Monkey Pet)
				[126246] = "stun",			-- Lullaby (Crane Pet)
				[126423] = "stun",			-- Petrifying Gaze (Basilisk Pet)
				[126355] = "stun",			-- Paralyzing Quill (Porcupine Pet)
				[56626] = "stun",			-- Sting (Wasp Pet)
				[50519] = "stun",			-- Sonic Blast (Bat Pet)
				[96201] = "stun",			-- Web Wrap (Spider-Pet Stun)
				[34490] = "silence",		-- Silencing Shot
				[3355] = "crowdControl",	-- Freezing Trap
				[19503] = "crowdControl",	-- Scatter Shot
				[19386] = "crowdControl",	-- Wyvern Sting
				[1513] = "crowdControl",	-- Scare Beast
				[50541] = "disarm",			-- Clench (Scorpid Pet)
				[91644] = "disarm",			-- Snatch (Bird of Prey Pet)
				[53148] = "root",			-- Charge (Tenacity Pet)
				[64803] = "root",			-- Entrapment (trap-roots)
				[136634] = "root",			-- Narrow Escape
				[50245] = "root";			-- Pin (Crab Pet)
				[90327] = "root",			-- Lock Jaw (Dog Pet)
				[4167] = "root",			-- Web (Spider Pet)
				[54706] = "root",			-- Venom Web Spray (Silithid Pet)
				[90361] = "usefulBuffs"	,	-- Spirit Mend (Spirit Pet)
				[53271] = "defCD",			-- Master's Call
				
				-- Mage
				[45438] = "defCD",			-- Ice Block
				[12472] = "offCD",			-- Icy Veins
				[44461] = "usefulDebuffs", 	-- Living Bomb
				[102051] = "stun",			-- Frost Jaw
				[44572] = "stun",			-- Deep Freeze
				[118271] = "stun";			-- Combustion Impact
				[55021] = "silence",		-- Counterspell silence
				[118] = "crowdControl",		-- Standard Polymorph
				[61305] = "crowdControl",	-- Polymorph Cat
				[28272] = "crowdControl",	-- Polymorph Pig
				[61721] = "crowdControl",	-- Polymorph Rabbit
				[61780] = "crowdControl",	-- Polymorph Turkey (woot?!)
				[28271] = "crowdControl",	-- Polymorph Turtle
				[82691] = "crowdControl",	-- Ring of Frost
				[31661] = "crowdControl",	-- Dragon's Breath
				[122] = "root",				-- Frost Nova
				[33395] = "root",			-- Freeze (Pet Nova)
				[111340] = "root",			-- Ice Ward Root
				[110909] = "usefulBuffs",	-- Alter Time

				-- Monk
				[120086] = "stun",			-- Fists of Fury
				[122242] = "stun",			-- Clash (stun)
				[126451] = "stun",			-- Clash (stun)
				[119392] = "stun",			-- Charging Ox Wave
				[119381] = "stun",			-- Leg Sweep
				[116709] = "silence",		-- Spear Hand Strike
				[137460] = "silence",		-- Silence (Ring of Peace)
				[115078] = "crowdControl",	-- Paralysis
				[123407] = "crowdControl",	-- Glyph of Breath of Fire
				[117368] = "disarm",		-- Grapple Weapon
				[137461] = "disarm",		-- Disarm (Ring of Peace)
				[116706] = "root",			-- Disable (root)
				[123393] = "root",			-- Spinning Fire Blossom
				[116841] = "usefulBuffs",	-- Tiger's Lust

				-- Paladin
				[642] = "defCD",			-- Divine Shield
				[31884] = "offCD",			-- Avenging Wrath
				[105593] = "stun",			-- Fist of Justice
				[853] = "stun",				-- Hammer of Justice
				[119072] = "stun",			-- Holy Wrath
				[31935] = "silence",		-- Avenger's Shield
				[145067] = "crowdControl",	-- Turn Evil
				[105421] = "crowdControl",	-- Blinding Light
				[20066] = "crowdControl",	-- Repentance
				
				-- Priest
				[113506] = "defCD", 		-- Cyclone (Symbiosis) (Made that one a def CD, because the enemy is immune to everything during cyclone)
				[33206] = "defCD",			-- Pain Suppression
				[47788] = "defCD",			-- Guardian Spirit
				[47585] = "defCD",			-- Dispersion
				[10060] = "offCD",			-- Power Infusion
				[64044] = "stun",			-- Psychic Horror
				[15487] = "silence",		-- Silence
				[87204] = "crowdControl",	-- Sin and Punishment(Vampiric Touch dispel fear)
				[8122] = "crowdControl",	-- Psychic Scream
				[113792] = "crowdControl",	-- Psychic Terror (Psyfiend)
				[605] = "crowdControl",		-- Dominate Mind
				[88625] = "crowdControl",	-- Holy Word: Chastise
				[9484] = "crowdControl",	-- Shackle Undead
				[114404] = "root",			-- Void Tendrils
				[87194] = "root",			-- Glyph of Mindblast
				[6346] = "usefulBuffs",		-- Fear Ward
				[34914] = "usefulDebuffs",	-- Vampiric Touch
				
				-- Rogue	
				[5277] = "defCD",			-- Evasion
				[31224] = "defCD",			-- Cloak of Shadows
				[121471] = "offCD",			-- Shadow Blades
				[51713] = "offCD",			-- Shadow Dance
				[408] = "stun", 			-- Kidney Shot
				[1833] = "stun",			-- Cheap Shot
				-- [76577] = 90,			-- Smokebomb
				[113953] = "stun",			-- Paralysis (Paralitic Poison Stun)
				[1330] = "silence",			-- Garrote - Silence
				[2094] = "crowdControl", 	-- Blind
				[1776] = "crowdControl", 	-- Gouge
				[6770] = "crowdControl", 	-- Sap
				[51722] = "disarm", 		-- Dismantle
				[115197] = "root", 			-- Partial Paralysis (Paralitic Poison Shiv)
				
				-- Shaman
				[113288] = "silence", 		-- Solar Beam (Symbiosis)
				[16166] = "offCD",			-- Elemental Mastery
				[118905] = "stun",			-- Static Charge
				[118345] = "stun",			-- Pulverize (Primal Earth Elemental)
				[77505] = "stun",			-- Earthquake Stun
				[51514] = "crowdControl",	-- Hex
				[76780] = "crowdControl",	-- Bind Elemental
				[63685] = "root",			-- Frost Shock (including Frozen Power)
				[64695] = "root",			-- Earthgrab Totem
				
				-- Warlock
				[710] = "defCD",			-- Banish (It is marked as def CD for the same reason as Cyclone)
				[113858] = "offCD",			-- Dark Soul: Instability
				[113861] = "offCD",			-- Dark Soul: Knowledge
				[113860] = "offCD",			-- Dark Soul: Misery
				[6789] = "stun",			-- Mortal Coil
				[30283] = "stun",			-- Shadowfury
				[89766] = "stun",			-- Axe Toss	(Pet-stun)
				[22703] = "stun",			-- Infernal Awakening
				[24259] = "silence",		-- Spell lock (Pet-silence)
				[115782] = "silence",		-- Optical Blast (Pet-silence)
				[137143] = "crowdControl",	-- Blood Horror
				[5484] = "crowdControl",	-- Howl of Terror
				[118699] = "crowdControl",	-- Fear
				[115268] = "crowdControl",	-- Mesmerize (Pet-Charm)
				[6358] = "crowdControl",	-- Seduce (Pet-Charm)
				[30108] = "usefulDebuffs",	-- Unstable Affliction		
				
				-- Warrior
				[871] = "defCD",			-- Shield Wall
				[1719] = "offCD",			-- Recklessness
				[50622] = "offCD", 			-- Bladestorm
				[7922] = "stun",			-- Charge Stun
				[132168] = "stun",			-- Shockwave
				[118000] = "stun",			-- Dragon Roar
				[132169] = "stun",			-- Storm Bolt
				[58357] = "silence",		-- Heroic Throw silence ?
				[5246] = "crowdControl",	-- Intimidating Shout
				[20511] = "crowdControl", 	-- Intimidating Shout
				[95199] = "crowdControl",	-- Intimidating Shout
				[676] = "disarm",			-- Disarm
				[107566] = "root",			-- Staggering Shout
				[105771] = "root",			-- Warbringer
				[23920] = "usefulBuffs",	-- Spell Reflection
				[114028] = "usefulBuffs",	-- Mass Spell Reflection
			},
			
			["FilteredSpells"] = { --[[This list blocks spells that cause bugs in the casthistory.]]--

					[127797] = "Ursol's Vortex", -- This ability is no channel, but the UNIT_SPELLCAST_SUCCEEDED event fires for it multiple times, if an enemy player stands inside of it.
					[102794] = "Ursol's Vortex",
					[75] = "Auto Shot", -- For every autoshot a hunter casts, the cast history will create a button. So we filter it.
					[107270] = "Spinning Crane Kick",
					[5374] = "Mutilate", -- The real Mutilate-Spell triggers these two spells. We don't need to show all three of them in the CastHistory, so we block them too.
					[27576] = "Mutilate Off-Hand",
					[110745] = "Divine Star (Holy)",
					[122128] = "Divine Star (Shadow)",
					[120692] = "Halo (Holy)",
					[120696] = "Halo (Shadow)",
					[93217] = "Launch Quest",
					[93079] = "Launch Quest",
					[102470] = "Launch Quest",
					[100775] = "Trophy Collector",
					[836] = "LOGINEFFECT",
					[121473] = "Shadow Blade",
					[121474] = "Shadow Blade Off-hand",
					[137584] = "Shuriken Toss (Autoattack Mainhand)",
					[137585] = "Shuriken Toss Off-hand",
					[126526] = "Healing Sphere Charge Removal",
					[124040] = "Chi Torpedo",
					[166646] = "Wind Walking",
					[126137] = "Lightspring Trigger",
			},
			
			["CooldownResets"] = {
			},
			["Cooldowns"] = { -- Captain Obvious: Cooldowns for our Cooldowntracker. Table order is: [spellID] = cooldownInSeconds.
			
				-- Druid
				--[22812] = 60,			-- Barkskin
				[106952] = 180,			-- Berserk
				--[1850] = 180,			-- Dash
				[22842] = 90,			-- Frenzied Regeneration
				[29166] = 180,			-- Innervate
				[106922] = 180,			-- Might of Ursoc
				--[16689] = 60,			-- Nature's Grasp
				--[106839] = 15,		-- Skull Bash
				[61336] = 180,			-- Survival Instincts
				[740] = 480,			-- Tranquility
				--[77764] = 120,		-- Stampeding Roar
				--[77761] = 120,		-- Stampeding Roar
				--[106898] = 120,		-- Stampeding Roar
				--[112071] = 180,		-- Celestial Alignment
				--[78675] = 60,			-- Solar Beam
				--[48505] = 90,			-- Starfall
				--[102795] = 60,		-- Bear Hug
				[102342] = 30,			-- Ironbark
				--[102280] = 30,		-- Displacer Beast
				--[132158] = 60,		-- Nature's Swiftness
				[108238] = 120,			-- Renewal
				--[102352] = 30,		-- Cenarion Ward
				--[102359] = 120,		-- Mass Entanglement
				[81098] = 180,			-- Incarnation: Tree of Life
				[102560] = 180,			-- Incarnation: Chosen of Elune	
				[102543] = 180,			-- Incarnation: King of the Jungle
				[102558] = 180,			-- Incarnation: Son of Ursoc
				--[37846] = 60,			-- Force of Nature
				--[99] = 30,			-- Disorienting Roar
				--[102793] = 60,		-- Ursol's Vortex
				--[5211] = 50,			-- (Mighty) Bash
				[108294] = 360,			-- Heart of the Wild
				[108293] = 360,			-- Heart of the Wild
				[108292] = 360,			-- Heart of the Wild
				[108291] = 360,			-- Heart of the Wild
				[124974] = 180,			-- Nature's Vigil
			
				-- Death Knight
				[48707] = 45,			-- Anti-Magic Shell
				[48792] = 180,			-- Icebound Fortitude
				--[77606] = 60,			-- Dark Simulacrum
				--[47528] = 15,			-- Mind Freeze
				[49039] = 120,			-- Lichborne
				--[47568] = 300,		-- Empower Rune Weapon
				--[51271] = 60,			-- Pillar of Frost
				[47476] = 120,			-- Strangulate
				[48743] = 120,			-- Death Pact
				--[46584] = 120,		-- Raise Dead
				--[115989] = 90,		-- Unholy Blight
				--[49206] = 180,		-- Summon Gargoyle
				[49016] = 180,			-- Unholy Frenzy
				--[49222]= 90,			-- Bone Shield
				--[48982] = 30,			-- Rune Tap
				--[55233] = 60,			-- Vampiric Blood
				[51052] = 120,			-- Anti-Magic Zone
				[114556] = 180,			-- Purgatory
				[108194] = 60,			-- Asphyxiate
				--[108199] = 60,		-- Gorefiend's Grip
				--[115000] = 60,		-- Remorseless Winter
				[118009] = 120,			-- Desecrated Ground
				--[91800] = 60,			-- Gnaw (Petstun)
				--[77575] = 60,			-- Outbreak
				--[49028] = 90,			-- Dancing Rune Weapons

				-- Paladin
				--[853] = 60,			-- Hammer of Justice
				[642] = 300,			-- Divine Shield
				--[498] = 60,			-- Divine Protection
				--[96231] = 15,			-- Rebuke
				[1022] = 300,			-- Hand of Protection
				--[1044] = 25,			-- Hand of Freedom
				[31821] = 180,			-- Devotion Aura
				[31884] = 180,			-- Avenging Wrath
				[6940] = 120,			-- Hand of Sacrifice
				--[115750] = 120,		-- Blinding Light
				--[85499] = 45,			-- Speed of Light
				--[105593] = 30,		-- Fist of Justice
				--[20066] = 15,			-- Repentance
				--[114039] = 30,		-- Hand of Purity
				[105809] = 120,			-- Holy Avenger
				--[114157] = 60,		-- Execution Sentence
				--[114158] = 60,		-- Light's Hammer
				--[114165] = 20,		-- Holy Prism
				[31850] = 180,			-- Ardent Defender
				[31842] = 180,			-- Divine Favor
				[54428] = 120,			-- Divine Plea
				--[86659] = 180,		-- Guardian of Ancient Kings
				--[86669] = 300,		-- Guardian of Ancient Kings
				--[86698] = 300,		-- Guardian of Ancient Kings
				
				
				-- Priest
				[139] = 30,
				--[81700] = 30,			-- Archangel
				--[586] = 30,			-- Fade
				[6346] = 180,			-- Fear Ward
				[64901] = 360,			-- Hymn of Hope
				--[89485] = 45,			-- Inner Focus
				--[73325] = 90,			-- Leap of Faith
				[32375] = 15,			-- Mass Dispel
				[33206] = 180,			-- Pain Suppression
				[62618] = 180,			-- Power Word: Barrier
				--[8122] = 27,			-- Psychic Scream (with PvP-Glove-Bonus)
				[34433] = 180,			-- Shadowfiend
				--[109964] = 60,		-- Spirit Shell
				[108968] = 300,			-- Void Shift	
				[64843] = 180,			-- Divine Hymn
				[47788] = 180,			-- Guardian Spirit
				--[88625] = 30,			-- Holy Word: Chastise
				--[724] = 180,			-- Lightwell
				[47585] = 120,			-- Dispersion
				--[64044] = 45,			-- Psychic Horror
				--[15487] = 45,			-- Silence
				[15286] = 180,			-- Vampiric Embrace
				--[108920] = 30,		-- Void Tendrils
				--[108921] = 45,		-- Psyfiend
				--[605] = 30,			-- Dominate Mind
				--[123040] = 60,		-- Mindbender
				[19236] = 120,			-- Desperate Prayer
				--[112833] = 30,		-- Spectral Guise
				--[108945] = 90,		-- Angelic Bulwark
				[10060] = 120,			-- Power Infusion
				--[120692] = 40,		-- Halo
				--[121135] = 25			-- Cascade (?)
				--[110744] = 15,		-- Divine Star
				
				-- Rogue
				[2094] = 120, 			-- Blind
				--[51722] = 60, 		-- Dismantle
				[76577] = 180,			-- Smokebomb
				--[2983] = 60,			-- Sprint
				--[1856] = 180,			-- Vanish
				--[1766] = 15,			-- Kick
				[51713] = 60,			-- Shadow Dance
				[31224] = 60,			-- Cloak of Shadows
				[74001] = 120,			-- Combat Readiness
				[79140] = 120,			-- Vendetta
				[121471] = 180,			-- Shadow Blades
				--[36554] = 24,			-- Shadow Step
				--[114018] = 300, 		-- Shroud of Concealment
				[5277] = 180,			-- Evasion
				--[73981] = 60,			-- Redirect without Talent
				
				-- Mage
				[44572] = 30,			-- Deep Freeze
				--[2139] = 25,			-- Counter Spell
				[12472] = 180,			-- Icy Veins
				[11958] = 180,			-- Cold Snap
				--[12043] = 90,			-- Presence of Mind
				--[1953] = 15,			-- Blink
				[45438] = 300,			-- Ice Block
				--[113724] = 30,		-- Ring of Frost
				--[84714] = 60,			-- Frozen Orb
				--[66] = 300,			-- Invisibility
				--[108839] = 60,		-- Ice Floes
				--[115610] = 25,		-- Temporal Shield
				--[108843] = 25,		-- Blazing Speed
				--[111264] = 20,		-- Ice Ward
				--[102051] = 20,		-- Frost Jaw
				--[110959] = 150, 		-- Greater Invisibility
				[86949] = 120,			-- Cauterize
				[12042] = 90,			-- Arcane Power
				--[55342] = 180,		-- Mirror Image
				[11129] = 45,			-- Combustion
				--[31661] = 20,			-- Dragon's Breath
				[108978] = 180,			-- Alter Time
				
				-- Shaman
				[108271] = 120,			-- Astral Shift
				--[108270] = 60,		-- Stone Bulwark Totem
				--[51485] = 30,			-- Earthgrab Totem
				--[108273] = 60,		-- Windwalk Totem
				[108285] = 180,			-- Call of the Elements
				--[16188] = 60,			-- Ancestral Swiftness
				[16166] = 120,			-- Elemental Mastery
				[108281] = 120,			-- Ancestral Guidance
				[108280] = 180,			-- Healing Tide Totem
				--[117014] = 12,		-- Elemental Blast
				[51533] = 120,			-- Feral Spirit
				[16190] = 180,			-- Mana Tide Totem
				--[30823] = 60,			-- Shamanistic Rage
				[98008] = 180,			-- Spirit Link Totem
				[58875] = 120,			-- Spirit Walk
				--[51490] = 45,			-- Thunderstorm
				--[73685] = 15,			-- Unleash Life
				--[57994] = 12,			-- Wind Shear
				--[2484] = 30,			-- Earthbind Totem
				--[5394] = 30,			-- Healing Stream Totem
				--[8177] = 25,			-- Grounding Totem
				--[8143] = 60,			-- Tremor Totem
				--[108269] = 45,		-- Capacitor Totem
				--[120668] = 300,		-- Stormlash Totem
				--[51514] = 45,			-- Hex
				--[73680] = 15,			-- Unleash Elements
				[114049] = 180,			-- Ascendance
				[79206] = 120,			-- Spiritwalker's Grace
				
				
				-- Warrior
				--[18499] = 30,			-- Berserker Rage
				--[85730] = 60,			-- Deadly Calm
				--[100] = 20,			-- Charge
				[118038] = 120,			-- Die by the Sword
				--[676] = 60,			-- Disarm
				--[3411] = 30,			-- Intervene
				--[5246] = 60,			-- Intimidating Shout
				--[6544] = 45,			-- Heroic Leap
				--[57755] = 30,			-- Heroic Throw
				--[6552] = 15,			-- Pummel
				[97462] = 180,			-- Rallying Cry
				--[23920] = 25,			-- Spell Reflection
				[1719] = 300,			-- Recklessness
				--[64382] = 300,		-- Shattering Throw
				[871] = 300,			-- Shield Wall
				--[55694] = 60,			-- Enraged Regeneration
				--[103840] = 30,		-- Impending Victory
				--[107566] = 40,		-- Staggering Shout
				--[102060] = 40,		-- Disrupting Shout
				[46924] = 150,			-- Blade Storm
				--[46968] = 20,			-- Shockwave
				--[118000] = 60,		-- Dragon Roar
				--[114028] = 60,		-- Mass Spell Reflect
				--[114029] = 30,		-- Safeguard
				[114030] = 120, 		-- Vigilance
				[12975] = 180,			-- Last Stand
				[107574] = 180, 		-- Avatar
				--[12292] = 60,			-- Bloodbath
				--[107570] = 30,		-- Storm Bolt
				[114203] = 180,			-- Demoralizing Banner
				[114192] = 180,			-- Mocking Banner
				[114207] = 180,			-- Skull Banner
				
				-- Warlock
				[108359] = 120,			-- Dark Regeneration
				--[5484] = 40,			-- Howl of Terror
				--[6789] = 45,			-- Mortal Coil
				--[30283] = 30,			-- Shadowfury
				--[108415] = 10,		-- Soul Link
				--[108416] = 60,		-- Sacrificial Pact
				[110913] = 180,			-- Dark Bargain
				--[111397] = 10,		-- Blood Fear
				--[108482] = 60,		-- Unbound Will
				[113858] = 120,			-- Dark Soul: Instability
				[113861] = 120,			-- Dark Soul: Knowledge
				[113860] = 120,			-- Dark Soul: Misery
				-- [103958] = 10,		-- Metamorphosis
				--[120451] = 60,		-- Flames of Xoroth
				--[109151] = 10,		-- Demonic Leap
				[108559] = 120,			-- Demonic Rebirth
				[104773] = 180,			-- Unending Resolve
				--[19647] = 24,			-- Spell lock
				--[115781] = 24,		-- Optical Blast
				
				-- Hunter
				--[3355] = 30,			-- Freezing Trap
				--[19503] = 30,			-- Scatter Shot
				[19263] = 120,			-- Deterrence
				[128594] = 120,			-- Exhilaration
				[131894] = 120,			-- A Murder of Crows
				--[120697] = 90			-- Lynx Rush
				[3045] = 180,			-- Rapid Fire
				[23989] = 300,			-- Readiness
				[121818] = 300,			-- Stampede
				[19574] = 60,			-- Bestial Wrath
				
				-- Monk
				[115176] = 180,			-- Zen Meditation
				[115310] = 180,			-- Revival
				-- [119996] = 25,			-- Transcendence: Transfer
				[116680] = 45,			-- Thunder Focus Tea
				[115203] = 180,			-- Fortifying Brew
				[116849] = 120,			-- Life Cocoon
				[122057] = 35,			-- Clash
				[119381] = 45,			-- Leg Sweep
				[119392] = 60,			-- Charging Ox Wave
				[116841] = 30,			-- Tiger's Lust
				[122278] = 90,			-- Dampen Harm
				[122783] = 90,			-- Diffuse Magic
				[123904] = 180,			-- Invoke Xuen, the White Tiger
				[122470] = 90,			-- Touch of Karma
			},
			
			["ShownBuffs"] = { -- I've decided to just show certain Buffs on the Buff-frame. Here is the List.
			-- Order is [SpellID] = "Castname",
			
				--Rogue
				[51713] = "Shadow Dance",
				[121471] = "Shadow Blades",
				[5277] = "Evasion",
				[2983] = "Sprint",
				[73651] = "Recuperate",
				[5171] = "Slice and Dice",
				[8679] = "Wound Poison",
				[2823] = "Deadly Poison",
				[5761] = "Mind-numbing Poison",
				[3408] = "Crippling Poison",
				[108215] = "Paralytic Poison",
				[108211] = "Leeching Poison",
				[74001] = "Combat Readiness",
				[74002] = "Combat Insight", -- Combat Readiness Stacks
				[1966] = "Feint",
				
				--Death Knight
				[48707] = "Anti-Magic Shell",
				[48263] = "Blood Presence",
				[48266] = "Frost Presence",
				[48265] = "Unholy Presence",
				[48792] = "Icebound Fortitude",
				[49016] = "Unholy Frenzy",
				[49222] = "Bone Shield",
				[55233] = "Vampiric Blood",
				[51271] = "Pillar of Frost",
				[115989] = "Unholy Blight",
				[49039] = "Lichborne",
				[51052] = "Anti-Magic Zone",
				[114556] = "Purgatory",
				[118009] = "Desecrated Ground",

				--Priest
				[17] = "Power Word: Shield",
				[123258] = "Power Word: Shield (Divine Insight Procc)",
				[81700] = "Archangel",
				[6346] = "Fear Ward",
				[33206] = "Pain Suppression",
				[47788] = "Guardian Spirit",
				[96267] = "Inner Focus",
				[120587] = "Glyph of Mind Flay",
				[15473] = "Shadowform",
				[10060] = "Power Infusion",
				[47585] = "Dispersion",
				[112833] = "Spectral Guise",
				[109964] = "Spirit Shell",
				[114908] = "Spirit Shell: Absorb",
				[77613] = "Grace",
				[41637] = "Prayer of Mending",
				[81209] = "Chakra: Chastise",
				[81206] = "Chakra: Sanctuary",
				[81208] = "Chakra: Serenity",

				--Druid
				[22812] = "Barkskin",
				[1850] = "Dash",
				[106922] = "Might of Ursoc",
				[77764] = "Stampeding Roar",
				[77761] = "Stampeding Roar",
				[106898] = "Stampeding Roar",
				[48505] = "Starfall",
				[61336] = "Survival Instincts",
				[5217] = "Tiger's Fury",
				[106951] = "Berserk",
				[50334] = "Berserk",
				[29166] = "Innervate",
				[102342] = "Ironbark",
				[33763] = "Lifebloom",
				[59990] = "Lifebloom",
				[94447] = "Lifebloom",
				[774] = "Rejuvenation",
				[8936] = "Regrowth",
				[132158] = "Nature's Swiftness",
				[102352] = "Cenarion Ward",
				[102560] = "Incarnation: Chosen of Elune",
				[102543] = "Incarnation: King of the Jungle",
				[102558] = "Incarnation: Son of Ursoc",
				[33891] = "Incarnation: Tree of Life",
				[124974] = "Nature's Vigil",

				--Shaman
				[324] = "Lightning Shield",
				[79206] = "Spiritwalker's Grace",
				[52127] = "Water Shield",
				[30823] = "Shamanistic Rage",
				[108271] = "Astral Shift",
				[16166] = "Elemental Mastery",
				[16188] = "Ancestral Swiftness",
				[108281] = "Ancestral Guidance",
				[974] = "Earth Shield",
				[61295] = "Riptide",
				[119523] = "Healing Stream Totem",

				--Paladin
				[53563] = "Beacon of Light",
				[31884] = "Avenging Wrath",
				[31821] = "Devotion Aura",
				[31842] = "Divine Favor",
				[54428] = "Divine Plea",
				[498] = "Divine Protection",
				[642] = "Divine Shield",
				[86698] = "Guardian of Ancient Kings",
				[86669] = "Guardian of Ancient Kings",
				[86659] = "Guardian of Ancient Kings",
				[1044] = "Hand of Freedom",
				[1022] = "Hand of Protection",
				[85499] = "Speed of Light",
				[20925] = "Sacred Shield",
				[114039] = "Hand of Purity",
				[105809] = "Holy Avenger",

				--Mage
				[108839] = "Ice Floes",
				[7302] = "Frost Armor",
				[30482] = "Molten Armor",
				[6117] = "Mage Armor",
				[12042] = "Arcane Power",
				[45438] = "Ice Block",
				[12472] = "Icy Veins",
				[66] = "Invisibility",
				[113862] = "Greater Invisibility",
				[110909] = "Alter Time",

				--Warlock
				[114168] = "Dark Apotheosis",
				[103958] = "Metamorphosis",
				[109773] = "Dark Intent",
				[113861] = "Dark Soul: Knowledge",
				[113860] = "Dark Soul: Misery",
				[113858] = "Dark Soul: Instability",
				[6229] = "Twilight Ward",
				[108415] = "Soul Link",
				[108416] = "Sacrificial Pact",
				[110913] = "Dark Bargain",
				[108503] = "Grimoire of Sacrifice",
				[108505] = "Archimonde's Vengeance",
				[119049] = "Kil'jaeden's Cunning",

				--Warrior
				[18499] = "Berserker Rage",
				[85730] = "Deadly Calm",
				[118038] = "Die by the Sword",
				[97463] = "Rallying Cry",
				[1719] = "Recklessness",
				[871] = "Shield Wall",
				[23920] = "Spell Reflection",
				[12328] = "Sweeping Strikes",
				[114206] = "Skull Banner",
				[55694] = "Enraged Regeneration",
				[16491] = "Second Wind",
				[29842] = "Second Wind",
				[128749] = "Bladestorm",
				[114028] = "Mass Spell Reflection",
				[107574] = "Avatar",
				[12292] = "Bloodbath",

				-- Hunter
				[13165] = "Aspect of the Hawk",
				[82661] = "Aspect of the Fox",
				[19263] = "Deterrence",
				[5384] = "Feign Death",
				[62305] = "Master's Call",
				[54216] = "Master's Call",
				[3045] = "Rapid Fire",
				[51755] = "Camouflage",
				[119449] = "Glyph of Camouflage",
				[109260] = "Aspect of the Iron Hawk",
				
				-- Monk
				[119611] = "Renewing Mist",
				
				-- Other:
				[121279] = "Lifeblood",
			},
		["Dispels"] =
			{
				-- TO DO: SPEC SPECIFIC SPELLS
				["DRUID"] = { 88423, 8 }, 			-- Nature's Cure
				["MAGE"] = { 475, 8 },				-- Remove Curse
				["MONK"] = { 115450, 8 }, 			-- Detox
				["PALADIN"] = { 4987, 8 }, 			-- Cleanse
				["PRIEST"] = { 527, 8 }, 			-- Purify
				["SHAMAN"] = { 51886, 8 }, 			-- Cleanse Spirit

			},
		["Interrupts"] = 
			{
				["DEATHKNIGHT"] = { 47528, 15 },	-- Mind Freeze
				["DRUID"] = { 106839, 15 }, 		-- Skull Bash
				["HUNTER"] = { 147362, 24 },		-- Counter Shot
				["MAGE"] = { 2139, 24 },			-- Counter Spell
				["PALADIN"] = { 96231, 15 }, 		-- Rebuke
				["ROGUE"] = { 1766, 15 }, 			-- Kick
				["SHAMAN"] = { 57994, 12 },			-- Wind Shear
				["WARLOCK"] = { 
					[1] = { 132409, 24 }, 			-- Spell lock Warlock
					[2] = { 115782, 24 }, 			-- Optical Blast Pet
					[3] = { 119910, 24 }, 			-- Spell lock Pet 
				},				
				["WARRIOR"] = { 6552, 15 },			-- Pummel		
			},
		["DiminishingReturns"] =
			{						
				-- Roots:
				[96294] = "root", 				-- Chains of Ice
				[339] = "root", 				-- Entangling Roots
				[19975] = "root", 				-- Entangling Roots: Nature's Grasp
				[102359] = "root",				-- Mass Entanglement
				[53148] = "root",				-- Charge (Tenacity Pet)
				[136634] = "root", 				-- Narrow Escape 
				[50245] = "root", 				-- Pin
				[90327] = "root", 				-- Lock Jaw
				[4167] = "root",  				-- Web 
				[54706] = "root",  				-- Venom Web Spray
				[33395] =  "root",  			-- Freeze
				[122] = "root",  				-- Frost Nova
				[116706] = "root",  			-- Disable
				[87194] = "root",				-- Glyph of Mindblast
				[114404] = "root", 				-- Void Tendril's Grasp
				[115197] = "root", 				-- Partial Paralysis
				[63685] = "root", 				-- Frost Shock (Frozen Power talent)
				[107566] = "root", 				-- Staggering Shout
				[105771] = "root",				-- Warbringer
				
				-- Short Roots:
				[64803] = "shortRoot",			-- Entrapment (trap-roots)
				[111340] = "shortRoot",			-- Ice Ward Root
				[123393] = "shortRoot",			-- Spinning Fire Blossom
				[64695] = "shortRoot", 			-- Earthgrab Totem
				
				-- Stuns:
				[108194] = "stun", 				-- Asphyxiate
				[91800] = "stun", 				-- Gnaw
				[91797] = "stun", 				-- Monstrous Blow
				[115001] = "stun", 				-- Remorseless Winter
				[113801] = "stun", 				-- Bash
				[102795] = "stun", 				-- Bear Hug
				[22570] = "stun", 				-- Maim
				[5211] = "stun", 				-- Mighty Bash
				[9005] = "stun", 				-- Pounce	
				
				[117526] = "stun",				-- Binding Shot
				[19577] = "stun",				-- Intimidation (stun)			
				[90337] = "stun",				-- Bad Manner (Monkey Pet)
				[126246] = "stun",				-- Lullaby (Crane Pet)
				[126423] = "stun",				-- Petrifying Gaze (Basilisk Pet)
				[126355] = "stun",				-- Paralyzing Quill(Porcupine Pet)
				[56626] = "stun",				-- Sting (Wasp Pet)
				[50519] = "stun",				-- Sonic Blast (Bat Pet)
				[96201] = "stun",				-- Web Wrap (Spider-Pet Stun)
				[118271] = "stun", 				-- Combustion Impact
				[44572] = "stun", 				-- Deep Freeze
				
				[119392] = "stun", 				-- Charging Ox Wave
				[122242] = "stun", 				-- Clash
				[120086] = "stun", 				-- Fists of Fury
				[119381] = "stun", 				-- Leg Sweep
				
				[54934] = "stun", 				-- TODO: Glyph of Blinding Light
				[853] = "stun",					-- Hammer of Justice
				[119072] = "stun", 				-- Holy Wrath
				[105593] = "stun", 				-- Fist of Justice
				
				[1833] = "stun", 				-- Cheap Shot
				[408] = "stun", 				-- Kidney Shot
				
				[118345] = "stun",				-- Pulverize (Primal Earth Elemental)
				[118905] = "stun", 				-- Static Charge
				
				[103131] = "stun",				-- Axe Toss (Felguard)
				[22703] = "stun",				-- Infernal Awakening
				[30283] = "stun", 				-- Shadowfury
				
				[132168] = "stun", 				-- Shockwave
				[107570] = "stun",				-- Storm Bolt
				
				[20549] = "stun", 				-- War Stomp
				
				-- Short Stuns:
				[113953] = "shortStun", 		-- Paralysis
				
				[77505] = "shortStun", 			-- Earthquake
				
				[7922] = "shortStun",			-- Charge Stun
				[118895] = "shortStun", 		-- Dragon Roar 					
		
				-- Mesmerizes:
				[2637] = "mesmerize",			-- Hibernate
				
				[3355] = "mesmerize", 			-- Freezing Trap
				[19386] = "mesmerize", 			-- Wyvern Sting
				
				[118] = "mesmerize", 			-- Polymorph
				[113724] = "mesmerize", 		-- Ring of Frost
				
				[115078] = "mesmerize", 		-- Paralysis
				
				[20066] = "mesmerize", 			-- Repentance
				
				[9484] = "mesmerize", 			-- Shackle Undead
				
				[1776] = "mesmerize", 			-- Gouge
				[6770] = "mesmerize", 			-- Sap
				
				[76780] = "mesmerize",			-- Bind Elemental
				[51514] = "mesmerize", 			-- Hex
				
				[710] = "mesmerize",			-- Banish
				
				[107079] = "mesmerize", 		-- Quaking Palm
				
				-- Short Mesmerizes:
				[99] = "shortMesmerize", 		-- Disorienting Roar
				
				[19503] = "shortMesmerize",		-- Scatter Shot
				
				[31661] = "shortMesmerize", 	-- Dragon's Breath
				
				[123407] = "shortMesmerize",	-- Glyph of Breath of Fire
				
				[88625] = "shortMesmerize",		-- Holy Word: Chastise
				
				-- Fears:
				[113056] = "fear",				-- Intimidating Roar (cower)
				[113004] = "fear",				-- Intimidating Roar (flee)
				
				[1513] = "fear", 				-- Scare Beast
				
				[105421] = "fear", 				-- Blinding Light
				[10326] = "fear", 				-- Turn Evil
				
				[8122] = "fear", 				-- Psychic Scream
				[113792] = "fear", 				-- Psychic Terror
				
				[2094] = "fear", 				-- Blind
				
				[118699] = "fear", 				-- Fear
				[5484] = "fear", 				-- Howl of Terror
				[115268] = "fear", 				-- Mesmerize
				[6358] = "fear", 				-- Seduction
				
				[5246] = "fear",				-- Intimidating Shout
				[20511] = "fear", 				-- Intimidating Shout
				[95199] = "fear", 				-- Intimidating Shout

				-- Horrors:
				
				[64044] = "horror", 			-- Psychic Horror
				
				[87204] = "horror", 			-- Sin and Punishment
				
				[137143] = "horror", 			-- Blood Horror
				[6789] = "horror", 				-- Mortal Coil
				
				-- Silences:
				[47476] = "silence", 			-- Strangulate
				
				[114238] = "silence",			-- Fae Silence (Glyph of Fae Silence)
				[81261] = "silence", 			-- Solar Beam
				[113288] = "silence", 			-- Solar Beam (Shaman)
				
				[34490] = "silence", 			-- Silencing Shot
				
				[55021] = "silence", 			-- Improved Counterspell
				[102051] = "silence", 			-- Frostjaw
				
				[137460] = "silence",			-- Silence (Ring of Peace)
				[116709] = "silence", 			-- Spear Hand Strike
				
				[31935] = "silence", 			-- Avenger's Shield
				
				[15487] = "silence", 			-- Silence
				
				[1330] = "silence", 			-- Garrote - Silence
				
				[24259] = "silence", 			-- Spell Lock
				[115782] = "silence", 			-- Optical Blast
				
				[129597] = "silence", 			-- Arcane Torrent
				
				-- Disarms:
				[50541] = "disarm", 			-- Clench
				[91644] = "disarm", 			-- Snatch
				
				[117368] = "disarm", 			-- Grapple Weapon
				[137461] = "disarm",			-- Disarm (Ring of Peace)
				
				[64058] = "disarm", 			-- Psychic Horror
				
				[51722] = "disarm", 			-- Dismantle
				
				[118093] = "disarm",			-- Disarm
				
				[676] = "disarm", 				-- Disarm
				
				-- Knockbacks:
				-- Gorefiend's Grasp
				-- Typhoon
				-- Ursol's Vortex
				-- Explosive Trap
				-- Thunderstorm
				-- Fellash (Shivarra)
				-- Whiplash (Succubus)
				
				-- Cyclone:
				[33786] = "cyclone", -- Cyclone
				
				-- Charms:
				[605] = "charm", -- Dominate Mind
				
			},
	};