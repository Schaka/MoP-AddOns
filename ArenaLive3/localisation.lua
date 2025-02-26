local addonName, L = ...;
L["Enable"] = "Enable";
L["Error in Method ArenaLive:CheckArgs! Function needs an even number of arguments. Number of arguments: %d"] = "Error in Method ArenaLive:CheckArgs! Function needs an even number of arguments. Number of arguments: %d";
L["Error in method ArenaLive:CheckArgs! Variable type expected: %s, but actual variable type is %s. checkID = %d."] = "Error in Method ArenaLive:CheckArgs! Variable type expected: %s, but actual variable type is %s. checkID = %d.";
L["Couldn't construct database, because there already is one registered for the addon %s!"] = "Couldn't construct database, because there already is one registered for the addon %s!";
L["Couldn't query if database has sub structures, because no database for the addon %s is registered!"] = "Couldn't query if database has sub structures, because no database for the addon %s is registered!";
L["Couldn't query if database has profiles, because no database for the addon %s is registered!"] = "Couldn't query if database has profiles, because no database for the addon %s is registered!";
L["Couldn't query database for value, because no database for the addon %s is registered!"] = "Couldn't query database for value, because no database for the addon %s is registered!";
L["Couldn't set database value, because no database for the addon %s is registered!"] = "Couldn't set database value, because no database for the addon %s is registered!";
L["Couldn't create option frame, because no template for the type %s is registered!"] = "Couldn't create option frame, because no template for the type %s is registered!";
L["Created option frame. Type = %s and frame = %s"] = "Created option frame. Type = %s and frame = %s";
L["Couldn't create option frame by handler, because either no handler named %s is registered or the handler hasn't an option set named %s!"] = "Couldn't create option frame by handler, because either no handler named %s is registered or the handler hasn't an option set named %s!";
L["Couldn't construct handler via method ArenaLive:ConstructHandler, because there already is a handler with the name %s registered."] = "Couldn't construct handler via method ArenaLive:ConstructHandler, because there already is a handler with the name %s registered.";
L["Couldn't delete handler via method ArenaLive:DestroyHandler, because there is no handler \"%s\" registered."] = "Couldn't delete handler via method ArenaLive:DestroyHandler, because there is no handler \"%s\" registered.";
L["Couldn't get handler via method ArenaLive:GetHandler, because there is no handler \"%s\" registered."] = "Couldn't get handler via method ArenaLive:GetHandler, because there is no handler \"%s\" registered.";
L["Couldn't create handler object of the type \"%s\" via method ArenaLive:ConstructHandlerObject, because there is no handler with that name registered."] = "Couldn't create handler object of the type \"%s\" via method ArenaLive:ConstructHandlerObject, because there is no handler with that name registered.";
L["Handler object type \"%s\" does not have a ConstructObject method. Just add name and return..."] = "Handler object type \"%s\" does not have a ConstructObject method. Just add name and return...";
L["Successfully constructed handler with the name %s!"] = "Successfully constructed handler with the name %s!";
L["Successfully destroyed handler with the name %s!"] = "Successfully destroyed handler with the name %s!";
L["Couldn't add addon via method ArenaLive:AddAddon, because there already is an addon with the name %s registered."] = "Couldn't add addon via method ArenaLive:AddAddon, because there already is an addon with the name %s registered.";
L["Couldn't destroy custom event \"%s\", because there is no custom event with that name!"] = "Couldn't destroy custom event \"%s\", because there is no custom event with that name!";
L["Enable Frame"] = "Enable Frame";
L["Anchor Point:"] = "Anchor Point:";
L["Relative to Frame:"] = "Relative to Frame:";
L["Relative Point:"] = "Relative Point:";
L["Top Left"] = "Top Left";
L["Top"] = "Top";
L["Top Right"] = "Top Right";
L["Left"] = "Left";
L["Center"] = "Center";
L["Right"] = "Right";
L["Bottom Left"] = "Bottom Left";
L["Bottom"] = "Bottom";
L["Bottom Right"] = "Bottom Right";
L["X Offset:"] = "X Offset:";
L["Y Offset:"] = "Y Offset:";
L["Couldn't register handler %s for unit frame %s, because there already is a handler of that type registered!"] = "Couldn't register handler %s for unit frame %s, because there already is a handler of that type registered!";
L["Couldn't unregister handler %s for unit frame %s, because there is no handler of that type registered!"] = "Couldn't unregister handler %s for unit frame %s, because there is no handler of that type registered!";
L["Couldn't construct new unit frame, because interface currently is in combat lockdown!"] = "Couldn't construct new unit frame, because interface currently is in combat lockdown!";
L["Successfully created new unit frame with the name %s!"] = "Successfully created new unit frame with the name %s!";
L["Tried to change %s's unit during combat lockdown. Adding it to the callback list..."] = "Tried to change %s's unit during combat lockdown. Adding it to the callback list...";
L["Changed frequent update function for status bar %s to %s"] = "Changed frequent update function for status bar %s to %s";
L["Entering arena, wiping Icon cooldown cache table..."] = "Entering arena, wiping Icon cooldown cache table...";
L["<AFK>"] = "<AFK>";
L["<DND>"] = "<DND>";
L["Added nickname %s for player %s"] = "Added nickname %s for player %s";
L["Removed nickname for player %s"] = "Removed nickname for player %s";
L["Couldn't remove nickname for player %s, because there is no nickname registered for this player!"] = "Couldn't remove nickname for player %s, because there is no nickname registered for this player!";
L["Tried to set up an invalid status bar type in Methods StatusBarText:ConstructObject. StatusBarType = %s. Valid options are \"HealthBar\" or \"PowerBar\""] = "Tried to set up an invalid status bar type in Methods StatusBarText:ConstructObject. StatusBarType = %s. Valid options are \"HealthBar\" or \"PowerBar\"";
L["DEAD"] = "Dead";
L["GHOST"] = "Ghost";
L["DISCONNECT"] = "Disconnected";
L["Purging cc cache for unit %s"] = "Purging cc cache for unit %s";
L["Lockout! (%s)"] = "Lockout! (%s)";
L["Chosen icon is already in use, searching for free icon..."] = "Chosen icon is already in use, searching for free icon...";
L["Couldn't construct new icon group, because a group with the name %s already exists!"] = "Couldn't construct new icon group, because a group with the name %s already exists!";
L["Couldn't add icon to icon group, because a group with the name %s doesn't exist!"] = "Couldn't add icon to icon group, because a group with the name %s doesn't exist!";
L["Remaining time flagged for PvP: %s"] = "Remaining time flagged for PvP: %s";
L["MINUTE_ABBR"] = "m";
L["HOUR_ABBR"] = "h";
L["Couldn't set handler \"%s\" as the class of handler \"%s\", because there is no handler with the name \"%s\" registered."] = "Couldn't set handler \"%s\" as the class of handler \"%s\", because there is no handler with the name \"%s\" registered.";
L["Couldn't create moving functionality for frame, because the given frame does not have an unique name!"] = "Couldn't create moving functionality for frame, because the given frame does not have an unique name!";
L["Couldn't set position for frame, because the given frame is not registered for ArenaLive's frame mover!"] = "Couldn't set position for frame, because the given frame is not registered for ArenaLive's frame mover!";
L["%s = %s"] = "%s = %s";
L["Tried to change %s's unit although the frame is disabled. Please enable the frame and try again..."] = "Tried to change %s's unit although the frame is disabled. Please enable the frame and try again...";

-- Unit Frame Options:
L["Enables the unit frame."] = "Enables the unit frame.";
L["Show Tooltip"] = "Show Tooltip";
L["Always"] = "Always";
L["Out of Combat"] = "Out of Combat";
L["Never"] = "Never";
L["Frame Scale (%)"] = "Frame Scale (%)";
L["Sets the scale of the unit frame."] = "Sets the scale of the unit frame.";

-- Crowd Control Indicator Options:
L["Enables the Crowd Control Indicator."] = "Enables the Crowd Control Indicator.";
L["Defensive Cooldowns"] = "Defensive Cooldowns";
L["Offensive Cooldowns"] = "Offensive Cooldowns";
L["Stuns"] = "Stuns";
L["Silences"] = "Silences";
L["Crowd Control"] = "Crowd Control";
L["Roots"] = "Roots";
L["Disarms"] = "Disarms";
L["Useful Buffs"] = "Useful Buffs";
L["Useful Debuffs"] = "Useful Debuffs";

-- Frame Mover Options:
L["Frame Lock"] = "Frame Lock";
L["Locks all movable frames of the addon."] = "Locks all movable frames of the addon.";
L["Point"] = "Point";
L["Relative Point"] = "Relative Point";
L["Choose the frame's anchor point. It will be attached to the relative frame at this point."] = "Choose the frame's anchor point. It will be attached to the relative frame at this point.";
L["Choose the relative frame's anchor point. The frame will be anchored to this point of the relative frame."] = "Choose the relative frame's anchor point. The frame will be anchored to this point of the relative frame.";
L["TOPLEFT"] = "TOPLEFT";
L["TOP"] = "TOP";
L["TOPRIGHT"] = "TOPRIGHT";
L["LEFT"] = "LEFT";
L["CENTER"] = "CENTER";
L["RIGHT"] = "RIGHT";
L["BOTTOMLEFT"] = "BOTTOMLEFT";
L["BOTTOM"] = "BOTTOM";
L["BOTTOMRIGHT"] = "BOTTOMRIGHT";
L["Relative Frame"] = "Relative Frame";
L["The relative frame the frame will be anchored to. Leave this blank to anchor it to the global interface frame."] = "The relative frame the frame will be anchored to. Leave this blank to anchor it to the global interface frame.";
L["X Offset"] = "X Offset";
L["The horizontal offset to the relative frame's anchor point."] = "The horizontal offset to the relative frame's anchor point.";
L["Y Offset"] = "Y Offset";
L["The vertical offset to the relative frame's anchor point."] = "The vertical offset to the relative frame's anchor point.";

-- ArenaHeader Options:
L["Enables Arena Frames."] = "Enables Arena Frames.";
L["Space Between Frames"] = "Space Between Frames";
L["Sets the space between the arena frames."] = "Sets the space between the arena frames.";
L["Growth Direction"] = "Growth Direction";
L["Sets the direction to which the arena frames will grow."] = "Sets the direction to which the arena frames will grow.";

-- Aura Options:
L["Enables the display of Buffs and Debuffs."] = "Enables the display of Buffs and Debuffs.";
L["Grow Upwards"] = "Grow Upwards";
L["If checked, aura rows will grow upwards, instead of downwards."] = "If checked, aura rows will grow upwards, instead of downwards.";
L["Grow from Right to Left"] = "Grow from Right to Left";
L["If checked, auras will grow from right to left, instead of from left to right."] = "If checked, auras will grow from right to left, instead of from left to right.";
L["Castable Buffs"] = "Castable Buffs";
L["Show only buffs you can cast on friendly units."] = "Show only Buffs you can cast on friendly units."
L["Dispellable Debuffs"] = "Dispellable Debuffs";
L["Show only debuffs you can dispel on friendly units."] = "Show only debuffs you can dispel on friendly units.";
L["If checked, only the debuffs that are dispellable by the player will be shown for friendly units."] = "If checked, only the debuffs that are dispellable by the player will be shown for friendly units.";
L["Player's Debuffs"] = "Player's Debuffs";
L["Show only your own debuffs on enemy units."] = "Show only your own debuffs on enemy units.";
L["Large Icon Size"] = "Large Icon Size";
L["Defines the size of buffs and debuffs that are cast by the player."] = "Defines the size of buffs and debuffs that are cast by the player.";
L["Normal Icon Size"] = "Normal Icon Size";
L["Defines the size of buffs and debuffs that are not cast by the player."] = "Defines the size of buffs and debuffs that are not cast by the player.";
L["Auras per Row"] = "Auras per Row";
L["Defines the maximal number of buffs and debuffs that will be shon in a row, before a new row is started."] = "Defines the maximal number of buffs and debuffs that will be shon in a row, before a new row is started.";
L["Shown Buffs"] = "Shown Buffs";
L["Defines the number of maximal buffs that are shown simultaneously."] = "Defines the number of maximal buffs that are shown simultaneously.";
L["Shown Debuffs"] = "Shown Debuffs"; 
L["Defines the number of maximal debuffs that are shown simultaneously."] = "Defines the number of maximal debuffs that are shown simultaneously.";

-- Border Options:
L["Enables the unit frame's border graphic."] = "Enables the unit frame's border graphic.";
L["Border Colour"] = "Border Colour";
L["Set the colour of the unit frame's border graphic."] = "Set the colour of the unit frame's border graphic.";

-- Castbar Options:
L["Enables the cast bar."] = "Enables the cast bar.";
L["Reverse Fill Castbar"] = "Reverse Fill Castbar";
L["If checked, the castbar will fill from right to left, instead of from left to right."] = "If checked, the castbar will fill from right to left, instead of from left to right.";

-- Casthistory Options:
L["Enables the cast history."] = "Enables the cast history.";
L["Icon Size"] = "Icon Size";
L["Sets the size of the cast history icons."] = "Sets the size of the cast history icons.";
L["Direction"] = "Direction";
L["Sets the moving direction of the cast history icons."] = "Sets the moving direction of the cast history icons.";
L["Up"] = "Up";
L["Right"] = "Right";
L["Down"] = "Down";
L["Left"] = "Left";
L["Icon Duration"] = "Icon Duration";
L["Sets the time in seconds until a cast history icon fades."] = "Sets the time in seconds until a cast history icon fades.";
L["Shown Icons"] = "Shown Icons";
L["Sets the maximal number of cast history icons that are shown simultaneously."] = "Sets the maximal number of cast history icons that are shown simultaneously.";

-- Cooldown Options:
L["Show Cooldown Text"] = "Show Cooldown Text";
L["Shows a timer text for cooldowns. Disable this to enable support for cooldown count addons."] = "Shows a timer text for cooldowns. Disable this to enable support for cooldown count addons.";

-- Diminishing Return Tracker Options:
L["Enables the diminishing return tracker."] = "Enables the diminishing return tracker.";
L["Sets the size of the diminishing return tracker's icons."] = "Sets the size of the diminishing return tracker's icons.";
L["Sets the growing direction of the diminishing return tracker."] = "Sets the growing direction of the diminishing return tracker.";
L["Sets the maximal number of icons that are shown simultaneously."] = "Sets the maximal number of icons that are shown simultaneously.";
L["Clearing cache for arena opponent with GUID: %s"] = "Clearing cache for arena opponent with GUID: %s";
-- Healthbar Options:
L["Colour Mode"] = "Colour Mode";
L["Set the colour mode of the unit frame's health bar."] = "Set the colour mode of the unit frame's health bar.";
L["None"] = "None";
L["Class Colour"] = "Class Colour";
L["Reaction Colour"] = "Reaction Colour";
L["Current Health"] = "Current Health";
L["Show Absorbs"] = "Show Absorbs";
L["Enables the display of absorb shields."] = "Enables the display of absorb shields.";
L["Show Predicted Healing"] = "Show Predicted Healing";
L["Enables the display of incoming heals."] = "Enables the display of incoming heals.";
L["Reverse Fill Healthbar"] = "Reverse Fill Healthbar";
L["If checked, the healthbar will fill from right to left, instead of from left to right."] = "If checked, the healthbar will fill from right to left, instead of from left to right."

-- Healthbar Text Options:
L["Show Dead"] = "Show Dead";
L["If active, the health bar text will show Dead or Ghost for dead units instead of the health value."] = "If active, the health bar text will show Dead or Ghost for dead units instead of the health value.";
L["Show Disconnect"] = "Show Disconnect";
L["If active, the health bar text will show the disconnected status for disconnected units instead of the health value."] = "If active, the health bar text will show the disconnected status for disconnected units instead of the health value.";
L["Healthbar Text:"] = "Healthbar Text:";
L["Shown Healthbar Text"] = "Shown Healthbar Text";

-- Dynamic Icon Options:
L["Cannot interact with database, because frame %s has no value set for key \"id\"!"] = "Cannot interact with database, because frame %s has no value set for key \"id\"!";
L["Icon Type"] = "Icon Type";
L["Choose Icon Type"] = "Choose Icon Type";
L["Choose Fallback Type"] = "Choose Fallback Type";
L["Fallback Type"] = "Fallback Type";
L["Sets a fallback option that will be used whenever the normal icon type is note available for the unit frame."] = "Sets a fallback option that will be used whenever the normal icon type is note available for the unit frame.";
L["Class Icon"] = "Class Icon";
L["Dispel Cooldown"] = "Dispel Cooldown";
L["Interrupt Cooldown"] = "Interrupt Cooldown";
L["Race Icon"] = "Race Icon";
L["Racial Ability Cooldown"] = "Racial Ability Cooldown";
L["Reaction Colour"] = "Reaction Colour";
L["Talent Specialisation Icon"] = "Talent Specialisation Icon";
L["PvP Insignia"] = "PvP Insignia";

-- Party Header Options:
L["Enables Party Frames."] = "Enables Party Frames.";
L["Sets the direction to which the party frames will grow."] = "Sets the direction to which the party frames will grow.";
L["Show Player"] = "Show Player";
L["Shows a frame for the player in the party frame header."] = "Shows a frame for the player in the party frame header.";
L["Show in Raid"] = "Show in Raid";
L["Sets whether the party frames are shown while in a raid group or not."] = "Sets whether the party frames are shown while in a raid group or not.";
L["Show in Arena"] = "Show in Arena";
L["Sets whether the party frames are shown while in arena or not."] = "Sets whether the party frames are shown while in arena or not.";

-- Portrait Options:
L["Portrait Type"] = "Portrait Type";
L["Choose the portrait type for the unit frame's character portrait."] = "Choose the portrait type for the unit frame's character portrait.";
L["3D Portrait"] = "3D Portrait";

-- Positioning Grid Options:
L["Show Grid"] = "Show Grid";
L["Shows a vertical and a horizontal line that can both be moved. This makes it easier to position frames accurately."] = "Shows a vertical and a horizontal line that can both be moved. This makes it easier to position frames accurately.";

-- Profile Options:
L["Active Profile"] = "Active Profile";
L["Copy Profile"] = "Copy Profile";
L["New Profile Name:"] = "New Profile Name:";
L["Create Profile"] = "Create Profile";
L["Couldn't create new profile named %s, because there already is a profile with that name for the addon %s."] = "Couldn't create new profile named %s, because there already is a profile with that name for the addon %s.";

-- Powerbar Options:
L["Reverse Fill Powerbar"] = "Reverse Fill Powerbar";
L["If checked, the powerbar will fill from right to left, instead of from left to right."] = "If checked, the powerbar will fill from right to left, instead of from left to right.";

-- Powerbar Text Options:
L["Shown Powerbar Text"] = "Shown Powerbar Text";
L["Powerbar Text:"] = "Powerbar Text:";

-- Statusbar Text Options:
L["Shown Statusbar Text"] = "Shown Statusbar Text";
L["Define the text that will be shown in the status bar. \n %PERCENT% = Percent value with 2 decimal digits \n %PERCENT_SHORT% = Percent value \n %CURR% = Current value \n %CURR_SHORT% = Abbreviated current value \n %MAX% = Maximal value \n %MAX_SHORT% = Abbreviated maximal value"] = "Define the text that will be shown in the status bar. \n %PERCENT% = Percent value with 2 decimal digits \n %PERCENT_SHORT% = Percent value \n %CURR% = Current value \n %CURR_SHORT% = Abbreviated current value \n %MAX% = Maximal value \n %MAX_SHORT% = Abbreviated maximal value";