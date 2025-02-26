local addonName, L = ...;

if not (GetLocale() == "deDE") then return end

-- Key Bindings:
_G["BINDING_HEADER_ARENALIVESPECTATOR_TARGETING_MACROS"] = "Zielfunktionen";

_G["BINDING_NAME_CLICK ALSPEC_LeftSideFramesFrame1:LeftButton"] = "Erstes linkes Teammitglied anvisieren";
_G["BINDING_NAME_CLICK ALSPEC_LeftSideFramesFrame2:LeftButton"] = "Zweites linkes Teammitglied anvisieren";
_G["BINDING_NAME_CLICK ALSPEC_LeftSideFramesFrame3:LeftButton"] = "Drittes linkes Teammitglied anvisieren";
_G["BINDING_NAME_CLICK ALSPEC_LeftSideFramesFrame4:LeftButton"] = "Viertes linkes Teammitglied anvisieren";
_G["BINDING_NAME_CLICK ALSPEC_LeftSideFramesFrame5:LeftButton"] = "Fünftes linkes Teammitglied anvisieren";

_G["BINDING_NAME_CLICK ALSPEC_RightSideFramesFrame1:LeftButton"] = "Erstes rechtes Teammitglied anvisieren";
_G["BINDING_NAME_CLICK ALSPEC_RightSideFramesFrame2:LeftButton"] = "Zweites rechtes Teammitglied anvisieren";
_G["BINDING_NAME_CLICK ALSPEC_RightSideFramesFrame3:LeftButton"] = "Drittes rechtes Teammitglied anvisieren";
_G["BINDING_NAME_CLICK ALSPEC_RightSideFramesFrame4:LeftButton"] = "Viertes rechtes Teammitglied anvisieren";
_G["BINDING_NAME_CLICK ALSPEC_RightSideFramesFrame5:LeftButton"] = "Fünftes rechtes Teammitglied anvisieren";

L["2v2"] = "Arena (2v2)"
L["3v3"] = "Arena (3v3)"
L["5v5"] = "Arena (5v5)"
L["All Arenas"] = "Alle Arenen"
L["Alterac Valley"] = "Alteractal"
L["Arathi Basin"] = "Arathibecken"
L["ArenaLive [Spectator] Match Statistic"] = "ArenaLive [Spectator] Spielstatistik"
L["ArenaLiveSpectatorMatchStatistic:SetMatch(id): id too high."] = "ArenaLiveSpectatorMatchStatistic:SetMatch(id): id zu hoch."
L["ArenaLive [Spectator] %s"] = "ArenaLive [Spectator] %s"
L["ArenaLiveSpectator.UnitCache:GetNumPlayers(): teamID too low or too high. Value must be 1 or 2."] = "ArenaLiveSpectator.UnitCache:GetNumPlayers(): teamID zu niedrig oder zu hoch. Wert muss 1 oder 2 sein."
L["Available Slash Commands for ArenaLive [Spectator] are:"] = "Verfügbare Slashkommandos für ArenaLive [Spectator] sind:"
L["Battleground"] = "Schlachtfeld"
L["Blade's Edge Arena"] = "Arena des Schergrats"
L["Bracket:"] = "Bracket:"
L["Broadcast Team Data"] = "Teamdaten senden"
L["Choose a Match"] = "Wähle ein Spiel"
L["Choose a Player"] = "Wähle einen Spieler"
L["Choose the map the war game will take place on."] = "Wähle die Karte, auf der das Kräftemessen stattfinden soll."
L["Choose the number of players per team."] = "Wähle die Anzahl an Spielern pro Team."
L["Clear Database"] = "Datenbank leeren"
L["Clearing the nickname database will delete all player nicknames. Do you want to proceed?"] = "Durch das leeren der Spitznamen-Datenbank werden alle Spitznamen für Spieler gelöscht. Möchtest du fortfahren?"
L["|c%s%s|r disconnected."] = "|c%ss%s|r Verbindung wurde unterbrochen."
L["|c%s%s|r has low health."] = "|c%s%s|r hat wenig Leben."
L["|c%s%s|r reconnected."] = "|c%ss%s|r Verbindung wurde wiederhergestellt."
L["|c%s%s|r tries to resurrect |c%s%s|r."] = "|c%s%s|r versucht |c%s%s|r widerzubeleben."
L["Current Player:"] = "Momentaner Spieler:"
L["Dalaran Sewers"] = "Kanalisation von Dalaran"
L["Damage Dealt:"] = "Verursachter Schaden:"
L["%d:%d"] = "%d:%d"
L["Deepwind Gorge"] = "Tiefenwindschlucht"
L["Delete Match"] = "Spiel löschen"
L["Player Information"] = "Spielerinformationen";
L["Talents:"] = "Talente:";
L["Glyphs:"] = "Glyphen:";
L["Disable"] = "Ausschalten"
L["Drag from the player list"] = "Spieler aus der Liste ziehen"
L["%d:%s"] = "%d:%s"
L["%s vs %s (%d:%d)"] = "%s vs %s (%d:%d)";
L["%d. %s"] = "%d. %s";
L["Enable Castbar"] = "Zauberleiste aktivieren"
L["Enable Casthistory"] = "Vergangene Zauber anzeigen"
L["Enable Scoreboard"] = "Punktetafel aktivieren"
L["Enter the name of the team. The name will be shown on the scoreboard and on the match statistic."] = "Gib den Namen des Teams ein. Der Name wird auf der Punktetafel und in der Spielstatistik angezeigt."
L["Enter the score of the team. It will be shown on the scoreboard."] = "Gib die Punktezahl des Teams ein. Sie wird auf der Punktetafel angezeigt."
L["Eye of the Storm"] = "Auge des Sturms"
L["Fifteen"] = "fünfzehn"
L["Follow Target"] = "Ziel verfolgen"
L["Healing Done:"] = "Gewirkte Heilung:"
L["Hide normal UI"] = "Verstecke normale Benutzeroberfläche"
L["If checked, ArenaLive will fixate the camera on your current target. Note: When following a player, nameplates are disabled by the WoW client."] = "Wenn diese Option gewählt ist, fixiert ArenaLive die Kamera auf das momentane Ziel. Hinweis: Wenn einen Spieler gefolgt wird, werden die Namensplaketten durch den WoW-Client deaktiviert."
L["If checked, a scoreboard with match timer, team name, team score and dampening tracker will be shown during matches."] = "Wenn diese Option aktiviert ist, wird eine Punktetafel mit Spielzeit, Teamnamen, Punkten und einer Dämpfungsanzeige angezeigt."
L["If checked, participants will only be allowed to use Tournament Gear. Other equipment will be disabled."] = "Wenn diese Option aktiviert ist, können Spieler nur Turniergegenstände tragen. Alle anderen Gegenstände werden inaktiv."
L["If checked, target and target-of-target frames will be disabled and the width of the current target's side frame will be increased dynamically instead."] = "Wenn diese Option aktiviert ist, werden das Ziel und das Ziel-des-Ziels ausgeblendet und stattdessen wird die Größe des Seitenframes dynamisch angepasst, der das momentane Ziel anzeigt."
L["If checked, team names and scores will be broadcast to the spectator group, when queuing for a war game."] = "Wenn diese Option aktiviert ist, werden Teamnamen und Punkte an die Zuschauergruppe gesendet, sobald für ein Kräftemessen angemeldet wird."
L["If enabled, spell tooltips will be shown when moving the mouse over a cooldown button."] = "Wenn diese Option aktiviert ist, werden Zauberinformationen für die Abklinganzeige eingeblendet, sobald der Cursor auf einem Symbol liegt."
L["Isle of Conquest"] = "Insel der Eroberung"
L["Joined a spectated battleground. Displaying a spectator UI in spectated battlegrounds requires BGLive."] = "Beobachtetem Schlachtfeld beigetreten. Um eine Zuschaueroberfläche anzuzeigen benötigen Sie BGLive."
L["Leave Arena"] = "Arena verlassen"
L["Map:"] = "Karte:"
L["Match:"] = "Spiel:"
L["Nagrand Arena"] = "Arena von Nagrand"
L["Nicknames:"] = "Spitznamen:"
L["No Nickname Assigned"] = "Kein Spitzname festgelegt"
L["Not logged into WoW"] = "Nicht in WoW eingeloggt"
L["Offline"] = "Offline"
L["One minute until the Arena battle begins!"] = "Noch eine Minute bis der Arenakampf beginnt!"
L["Player Nickname:"] = "Spitzname des Spielers:"
L["Random Battleground"] = "Zufälliges Schlachtfeld"
L["Received team data from group leader (%s). Updating team entries... (%s)"] = "Teamdaten von Gruppenleiter (%s) erhalten. Aktualisiere Teameinträge... (%s)"
L["Reset Nickname"] = "Spitznamen entfernen"
L["Ruins of Lordaeron"] = "Ruinen von Lordaeron"
L["Score:"] = "Punkte:"
L["(.+) seconds until the Arena battle begins!"] = "Noch (.+) Sekunden bis der Arenakampf beginnt!"
L["SET_CUSTOM_TOURNAMENT_ICON_TITLE"] = "Turniersymbol:"
L["SET_CUSTOM_TOURNAMENT_ICON_TOOLTIP"] = "Lege eine benutzerdefinierte Turniersymbol-Textur fest, welche die VS-Textur auf der Punktetafel ersetzt. Die Textur muss entweder dem .blp, .tga oder .png Format entsprechend. Sie muss eine Breite von 64 Pixeln und eine Höhe von 32 Pixeln haben. Außerdem muss die Textur im Unterordner \"TournamentIcons\" im Ordner \"ArenaLiveSpectator3\"innerhalb des AddOn-Verzeichnisses abgespeichert sein."
L["Settings"] = "Einstellungen"
L["Shows the Match Statistic"] = "Zeigt die Spielstatistik"
L["Shows the War Game Menu"] = "Zeigt das Menü für Kräftemessen"
L["Shows this info message."] = "Zeigt diese Nachricht"
L["Show Tooltip"] = "Tooltip anzeigen"
L["Silvershard Mines"] = "Silberbruchmine"
L["%s: Invalid team %s. Use \"TeamA\"  or \"TeamB\""] = "%s: Ungültiges Team %s. Benutze \"TeamA\" oder \"TeamB\""
L["Southshore vs Tarren Mill"] = "Vorgebirge des Hügellands"
L["Spectated War Games"] = "Beobachtetes Kräftemessen"
L["Spectator addon has been loaded successfully! Type /alspec to open the spectator war game menu or /alspec help for a list of available commands."] = "Zuschaueraddon erfolgreich geladen! Schreibe /alspec, um das Menü für beobachtetes Kräftemessen zu öffnen oder /alspec help für eine Liste an verfügbaren Kommandos."
L["%s: %s"] = "%s: %s"
L["Start Spectated War Game"] = "Starte beobachtetes Kräftemessen"
L["Strand of the Ancients"] = "Strand der Uralten"
L["%s: Usage %s"] = "%s: Verwendung %s"
L["Team Leader:"] = "Teamleiter:"
L["Team Name:"] = "Teamname:"
L["Temple of Kotmogu"] = "Tempel von Kotmogu"
L["The Arena battle has begun!"] = "Der Arenakampf hat begonnen!"
L["The Battle for Gilneas"] = "Die Schlacht um Gilneas"
L["The Ring of Valor"] = "Der Ring der Ehre"
L["The Tiger's Peak"] = "Tigergipfel"
L["Thirty"] = "dreißig"
L["Time in CC:"] = "Zeit im CC:"
L["Tol'Viron Arena"] = "Arena der Tol'vir"
L["Tournament Rules"] = "Turnierregeln"
L["Twin Peaks"] = "Zwillingsgipfel"
L["Unable to queue spectated wargame, because either team leader's or bracket number wasn't found."] = "Konnte nicht für beobachtetes Kräftemessen anmelden, da entweder einer der Beiden Gruppenleiter oder der Spielmodus nicht gefunden wurde."
L["WARNING! Couldn't register addon message prefix for ArenaLive [Spectator]. You won't be able to receive broadcast data during this session."] = "WARNUNG! Konnte das Addon-Nachrichten-Prefix für ArenaLive [Spectator] nicht registrieren. Du wirst nicht in der Lage sein, gesendete Daten während dieser Session zu erhalten."
L["Warsong Gulch"] = "Kriegshymnenschlucht"