class IRCSpec extends MessagingSpectator;

var string perkinfo[64];
var PlayerReplicationInfo PRI;
var bool startingGameAnnounced, endWaveAnnounced, lastWave;
var int waveTime;


function InitPlayerReplicationInfo() {
	PlayerReplicationInfo.PlayerName = "IRCBot";
	PlayerReplicationInfo.CharacterName = class'KFIRC'.Default.botChar;
	PlayerReplicationInfo.bOnlySpectator = True;
}

function string gMapName() {
	local int i, j;
	local string MapName;
	MapName = Level.GetLocalURL();
	i = InStr(MapName, "/") + 1;
	if (i < 0 || i > 16){
		i = 0;
	}
	j = InStr(MapName, "?");
	if (j < 0){
		j = Len(MapName);
	}
	if (Mid(MapName, j - 3, 3) ~= "rom"){
		j -= 4;
	}
	MapName = Mid(MapName, i, j - i);
	return MapName;
}

function string getPerkName(string S) {
	switch (S) {
		case "KFMod.KFVetBerserker":
			return "Berserker";
			break;
		case "KFMod.KFVetCommando":
			return "Commando";
			break;
		case "KFMod.KFVetDemolitions":
			return "Demolitions";
			break;
		case "KFMod.KFVetFieldMedic":
			return "Field Medic";
			break;
		case "KFMod.KFVetFirebug":
			return "Firebug";
			break;
		case "KFMod.KFVetSharpshooter":
			return "Sharpshooter";
			break;
		case "KFMod.KFVetSupportSpec":
			return "Support Specialist";
			break;
		case "None":
			return "None";
			break;
		Default:
			return Mid(S,11);
			break;
	}
}

function string getPerkInfo(int pid) {
	local int i;
	local KFPlayerReplicationInfo KFPRI;
	i = 0;
	ForEach DynamicActors(Class'KFPlayerReplicationInfo', KFPRI) {
		perkinfo[i] = coloring(KFIRC(Owner).Default.Color2) $ getPerkName(string(KFPRI.ClientVeteranSkill)) @ coloring(KFIRC(Owner).Default.Color1) $ "Level:" @ coloring(KFIRC(Owner).Default.Color2) $ KFPRI.ClientVeteranSkillLevel;
		i++;
	}
	return perkinfo[pid];
}

function postBeginPlay() {
	Super.postBeginPlay();
	WaveTime = 0;
	startingGameAnnounced = False;
	endWaveAnnounced = True;
	lastWave = False;
}

function string getGameLength() {
	switch (KFGameType(Level.Game).KFGameLength) {
		case 0:
			return "Short";
			break;
		case 1:
			return "Medium";
			break;
		case 2:
			return "Long";
			break;
		case 3:
			return "Custom";
			break;
	}	
}

function string getGameDifficulty() {
	if (KFGameType(Level.Game).GameDifficulty >= 7.0)
		return "Hell on Earth";
	else if (KFGameType(Level.Game).GameDifficulty >= 5.0)
		return "Suicidal";
	else if (KFGameType(Level.Game).GameDifficulty >= 4.0)
		return "Hard";
	else if (KFGameType(Level.Game).GameDifficulty >= 2.0)
		return "Normal";
	else if (KFGameType(Level.Game).GameDifficulty >= 1.0)
		return "Beginner";
}

function string coloring(int cor) {
	return chr(3) $ cor;
}

function ircSend(String msg)
{
	KFIRC(Owner).irc.ircSend(msg);
}

function string Duration(int dtime) {
	local int hrs, mins, secs;
	local string r;
	if (dtime >= 3600) {
		hrs = dtime / 60 / 60;
		mins = dtime / 60 % 60;
		secs = dtime % 60;
		r = hrs $ "hr(s)" @ mins $ "min(s)" @ secs $ "sec(s)";
	}
	if (dtime >= 60) {
		mins = dtime / 60 % 60;
		secs = dtime % 60;
		r = mins $ "min(s)" @ secs $ "sec(s)";
	}
	if (dtime < 60) {
		r = dtime $ "sec(s)";
	}
	return r;
}

function Timer() {
	Super.timer();
	if (KFGameType(Level.Game).bWaveInProgress == True && startingGameAnnounced == False) {
		ircSend(coloring(KFIRC(Owner).Default.Color1) $ "Starting Game!");
		ircSend(coloring(KFIRC(Owner).Default.Color1) $ "Map:" @ coloring(KFIRC(Owner).Default.Color2) $ gMapName() @ coloring(KFIRC(Owner).Default.Color1) $ "Game Length:" @ coloring(KFIRC(Owner).Default.Color2) $ getGameLength() $ "(" $ KFGameType(Level.Game).FinalWave $ ")" @ coloring(KFIRC(Owner).Default.Color1) $ "Difficulty:" @ coloring(KFIRC(Owner).Default.Color2) $ getGameDifficulty() @ coloring(KFIRC(Owner).Default.Color1) $ "Elapsed:" @ coloring(KFIRC(Owner).Default.Color2) $ Duration(KFGameType(Level.Game).ElapsedTime));
		startingGameAnnounced = True;
	}

	if (KFGameType(Level.Game).bWaveInProgress == True || KFGameType(Level.Game).bWaveBossInProgress == True) {
		waveTime++;
	}

	if (KFGameType(Level.Game).bWaveInProgress == False && KFGameType(Level.Game).bWaveBossInProgress == False && KFGameType(Level.Game).WaveNum > 0 && endWaveAnnounced == False && lastWave == True) {
		ircSend(coloring(KFIRC(Owner).Default.Color1) $ "FINAL Wave:" @ coloring(KFIRC(Owner).Default.Color2) $ KFGameType(Level.Game).WaveNum @ coloring(KFIRC(Owner).Default.Color1) $ "ended. Wave Time:" @ coloring(KFIRC(Owner).Default.Color2) $ Duration(waveTime));
		ircSend(" ");
		SStatus();
		ircSend(coloring(KFIRC(Owner).Default.Color1) $ "Total game time:" @ coloring(KFIRC(Owner).Default.Color2) $ Duration(KFGameType(Level.Game).ElapsedTime));
		endWaveAnnounced = True;
	}

	if (KFGameType(Level.Game).bWaveInProgress == False && KFGameType(Level.Game).bWaveBossInProgress == False && KFGameType(Level.Game).WaveNum > 0 && endWaveAnnounced == False && lastWave == False) {
		ircSend(coloring(KFIRC(Owner).Default.Color1) $ "Wave:" @ coloring(KFIRC(Owner).Default.Color2) $ KFGameType(Level.Game).WaveNum $ coloring(KFIRC(Owner).Default.Color1) $ "/" $ coloring(KFIRC(Owner).Default.Color2) $ KFGameType(Level.Game).FinalWave @ coloring(KFIRC(Owner).Default.Color1) $ "ended. Wave Time:" @ coloring(KFIRC(Owner).Default.Color2) $ Duration(waveTime));
		ircSend(" ");
		SStatus();
		endWaveAnnounced = True;
		waveTime = 0;
	}
	
	if (KFGameType(Level.Game).bWaveInProgress == True && KFGameType(Level.Game).bWaveBossInProgress == False && KFGameType(Level.Game).WaveNum < KFGameType(Level.Game).FinalWave && KFGameType(Level.Game).WaveNum >= 0 && endWaveAnnounced == True) {
		ircSend(coloring(KFIRC(Owner).Default.Color1) $ "Wave:" @ coloring(KFIRC(Owner).Default.Color2) $ KFGameType(Level.Game).WaveNum + 1 $ coloring(KFIRC(Owner).Default.Color1) $ "/" $ coloring(KFIRC(Owner).Default.Color2) $ KFGameType(Level.Game).FinalWave @ coloring(KFIRC(Owner).Default.Color1) $ "starting." @ coloring(KFIRC(Owner).Default.Color1) $ "Total Specimens:" @ coloring(KFIRC(Owner).Default.Color2) $ KFGameType(Level.Game).TotalMaxMonsters);
		endWaveAnnounced = False;
	}

	if (KFGameType(Level.Game).bWaveBossInProgress == True && KFGameType(Level.Game).WaveNum >= KFGameType(Level.Game).FinalWave && KFGameType(Level.Game).WaveNum >= 0 && endWaveAnnounced == True){
		ircSend(coloring(KFIRC(Owner).Default.Color1) $ "FINAL Wave:" @ coloring(KFIRC(Owner).Default.Color2) $ "PATRIARCH!!!" @ coloring(KFIRC(Owner).Default.Color1) $ "starting.");
		lastWave = True;
		endWaveAnnounced = False;
	}
}

Event TeamMessage(PlayerReplicationInfo PRI, coerce string S, name Type ) {
	if (Type == 'CriticalEvent') {
		Return;
	}
	if (Type == 'DeathMessage') {
		ircSend(coloring(KFIRC(Owner).Default.Color1) $ "Death:" @ coloring(KFIRC(Owner).Default.Color2) $ S);
	}
	if (Type == 'Say' || Type == 'TeamSay') {
		ircSend("[C]" @ coloring(KFIRC(Owner).Default.Color1) $ PRI.PlayerName $ ":" @ coloring(KFIRC(Owner).Default.Color2) $ S);
	}
}

function MsgSend(String bmsg) {
	Level.Game.Broadcast(self, bmsg, 'Say');
}

function SStatus() {
	local int i;

	if (startingGameAnnounced == False) {
		ircSend("Game not in progress:");
	} else {
		ircSend("Current Status:");
	}
	ircSend(coloring(KFIRC(Owner).Default.Color1) $ "Map:" @ coloring(KFIRC(Owner).Default.Color2) $ gMapName() @ coloring(KFIRC(Owner).Default.Color1) $ "Game Length:" @ coloring(KFIRC(Owner).Default.Color2) $ getGameLength() $ "(" $ KFGameType(Level.Game).FinalWave $ ")" @ coloring(KFIRC(Owner).Default.Color1) $ "Difficulty:" @ coloring(KFIRC(Owner).Default.Color2) $ getGameDifficulty() @ coloring(KFIRC(Owner).Default.Color1) $ "Elapsed:" @ coloring(KFIRC(Owner).Default.Color2) $ Duration(KFGameType(Level.Game).ElapsedTime));

	i = 0;
	ForEach DynamicActors(Class'PlayerReplicationInfo', PRI) {
		if (!PRI.bOnlySpectator) {
			ircSend(coloring(KFIRC(Owner).Default.Color1) $ "Player:" @ coloring(KFIRC(Owner).Default.Color2) $ PRI.PlayerName $ coloring(KFIRC(Owner).Default.Color1) $ "(" $ coloring(KFIRC(Owner).Default.Color2) $ getPerkInfo(i) $ coloring(KFIRC(Owner).Default.Color1) $ ")" @ coloring(KFIRC(Owner).Default.Color1) $ "Kills/Deaths:" @ coloring(KFIRC(Owner).Default.Color2) $ PRI.kills $ coloring(KFIRC(Owner).Default.Color1) $ "/" $ coloring(KFIRC(Owner).Default.Color2) $ int(PRI.deaths) @ coloring(KFIRC(Owner).Default.Color1) $ "Money:" @ coloring(KFIRC(Owner).Default.Color2) $ int(PRI.score) @ coloring(KFIRC(Owner).Default.Color1) $ "PING:" @ coloring(KFIRC(Owner).Default.Color2) $ PRI.Ping);
		}
		i++;
	}
}

defaultproperties
{
}
