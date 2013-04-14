Class IRCSpec extends MessagingSpectator;

var string perkinfo[64];
var PlayerReplicationInfo PRI;
var bool startingGameAnnounced, endWaveAnnounced, lastWave;
var int waveTime;


function InitPlayerReplicationInfo() {
	Super.InitPlayerReplicationInfo();
	PlayerReplicationInfo.PlayerName = "IRCBot";
	PlayerReplicationInfo.CharacterName = class'KFIRC'.Default.botChar;
	PlayerReplicationInfo.bAdmin = True; // hide from kick list
}

function postBeginPlay() {
	Super.postBeginPlay();
	WaveTime = 0;
	startingGameAnnounced = False;
	endWaveAnnounced = True;
	lastWave = False;
}

function ircSend(string msg) {
	KFIRC(Owner).irc.ircSend(msg);
}

function string col(int cor) {
	return chr(3) $ cor;
}

function MsgSend(string bmsg) {
	Level.Game.Broadcast(Self, bmsg, 'Say');
}

function string gMapName() {
	return Left(Level, InStr(Level, "."));
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
			return Mid(S, 11);
			break;
	}
}

function string getPerkInfo(int pid) {
	local int i;
	local KFPlayerReplicationInfo KFPRI;
	i = 0;

	ForEach DynamicActors(Class'KFPlayerReplicationInfo', KFPRI) {
		perkinfo[i] = col(KFIRC(Owner).Default.Color2) $ getPerkName(string(KFPRI.ClientVeteranSkill)) @ col(KFIRC(Owner).Default.Color1) $ "Level:" @ col(KFIRC(Owner).Default.Color2) $ KFPRI.ClientVeteranSkillLevel;
		i++;
	}
	return perkinfo[pid];
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
	else if (KFGameType(Level.Game).GameDifficulty == 1.0)
		return "Beginner";
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
	Super.Timer();
	if (KFGameType(Level.Game).bWaveInProgress == True && startingGameAnnounced == False) {
		ircSend(col(KFIRC(Owner).Default.Color1) $ "Starting Game!");
		ircSend(col(KFIRC(Owner).Default.Color1) $ "Map:" @ col(KFIRC(Owner).Default.Color2) $ gMapName() @ col(KFIRC(Owner).Default.Color1) $ "Game Length:" @ col(KFIRC(Owner).Default.Color2) $ getGameLength() $ "(" $ KFGameType(Level.Game).FinalWave $ ")" @ col(KFIRC(Owner).Default.Color1) $ "Difficulty:" @ col(KFIRC(Owner).Default.Color2) $ getGameDifficulty() @ col(KFIRC(Owner).Default.Color1) $ "Elapsed:" @ col(KFIRC(Owner).Default.Color2) $ Duration(KFGameType(Level.Game).ElapsedTime));
		startingGameAnnounced = True;
	}

	if (KFGameType(Level.Game).bWaveInProgress == True || KFGameType(Level.Game).bWaveBossInProgress == True) {
		waveTime++;
	}

	if (KFGameType(Level.Game).bWaveInProgress == False && KFGameType(Level.Game).bWaveBossInProgress == False && KFGameType(Level.Game).WaveNum > 0 && endWaveAnnounced == False && lastWave == True) {
		ircSend(col(KFIRC(Owner).Default.Color1) $ "FINAL Wave:" @ col(KFIRC(Owner).Default.Color2) $ KFGameType(Level.Game).WaveNum @ col(KFIRC(Owner).Default.Color1) $ "ended. Wave Time:" @ col(KFIRC(Owner).Default.Color2) $ Duration(waveTime));
		ircSend(" ");
		SStatus();
		ircSend(col(KFIRC(Owner).Default.Color1) $ "Total game time:" @ col(KFIRC(Owner).Default.Color2) $ Duration(KFGameType(Level.Game).ElapsedTime));
		endWaveAnnounced = True;
	}

	if (KFGameType(Level.Game).bWaveInProgress == False && KFGameType(Level.Game).bWaveBossInProgress == False && KFGameType(Level.Game).WaveNum > 0 && endWaveAnnounced == False && lastWave == False) {
		ircSend(col(KFIRC(Owner).Default.Color1) $ "Wave:" @ col(KFIRC(Owner).Default.Color2) $ KFGameType(Level.Game).WaveNum $ col(KFIRC(Owner).Default.Color1) $ "/" $ col(KFIRC(Owner).Default.Color2) $ KFGameType(Level.Game).FinalWave @ col(KFIRC(Owner).Default.Color1) $ "ended. Wave Time:" @ col(KFIRC(Owner).Default.Color2) $ Duration(waveTime));
		ircSend(" ");
		SStatus();
		endWaveAnnounced = True;
		waveTime = 0;
	}
	
	if (KFGameType(Level.Game).bWaveInProgress == True && KFGameType(Level.Game).bWaveBossInProgress == False && KFGameType(Level.Game).WaveNum < KFGameType(Level.Game).FinalWave && KFGameType(Level.Game).WaveNum >= 0 && endWaveAnnounced == True) {
		ircSend(col(KFIRC(Owner).Default.Color1) $ "Wave:" @ col(KFIRC(Owner).Default.Color2) $ KFGameType(Level.Game).WaveNum + 1 $ col(KFIRC(Owner).Default.Color1) $ "/" $ col(KFIRC(Owner).Default.Color2) $ KFGameType(Level.Game).FinalWave @ col(KFIRC(Owner).Default.Color1) $ "starting." @ col(KFIRC(Owner).Default.Color1) $ "Total Specimens:" @ col(KFIRC(Owner).Default.Color2) $ KFGameType(Level.Game).TotalMaxMonsters);
		endWaveAnnounced = False;
	}

	if (KFGameType(Level.Game).bWaveBossInProgress == True && KFGameType(Level.Game).WaveNum >= KFGameType(Level.Game).FinalWave && KFGameType(Level.Game).WaveNum >= 0 && endWaveAnnounced == True){
		ircSend(col(KFIRC(Owner).Default.Color1) $ "FINAL Wave:" @ col(KFIRC(Owner).Default.Color2) $ "PATRIARCH!!!" @ col(KFIRC(Owner).Default.Color1) $ "starting.");
		lastWave = True;
		endWaveAnnounced = False;
	}
}

function SStatus() {
	local int i;

	if (startingGameAnnounced == False) {
		ircSend("Game not in progress:");
	} else {
		ircSend("Current Status:");
	}
	ircSend(col(KFIRC(Owner).Default.Color1) $ "Map:" @ col(KFIRC(Owner).Default.Color2) $ gMapName() @ col(KFIRC(Owner).Default.Color1) $ "Game Length:" @ col(KFIRC(Owner).Default.Color2) $ getGameLength() $ "(" $ KFGameType(Level.Game).FinalWave $ ")" @ col(KFIRC(Owner).Default.Color1) $ "Difficulty:" @ col(KFIRC(Owner).Default.Color2) $ getGameDifficulty() @ col(KFIRC(Owner).Default.Color1) $ "Elapsed:" @ col(KFIRC(Owner).Default.Color2) $ Duration(KFGameType(Level.Game).ElapsedTime));

	i = 0;
	ForEach DynamicActors(Class'PlayerReplicationInfo', PRI) {
		if (!PRI.bOnlySpectator) {
			ircSend(col(KFIRC(Owner).Default.Color1) $ "Player:" @ col(KFIRC(Owner).Default.Color2) $ PRI.PlayerName $ col(KFIRC(Owner).Default.Color1) $ "(" $ col(KFIRC(Owner).Default.Color2) $ getPerkInfo(i) $ col(KFIRC(Owner).Default.Color1) $ ")" @ col(KFIRC(Owner).Default.Color1) $ "Kills/Deaths:" @ col(KFIRC(Owner).Default.Color2) $ PRI.kills $ col(KFIRC(Owner).Default.Color1) $ "/" $ col(KFIRC(Owner).Default.Color2) $ int(PRI.Deaths) @ col(KFIRC(Owner).Default.Color1) $ "Money:" @ col(KFIRC(Owner).Default.Color2) $ int(PRI.score) @ col(KFIRC(Owner).Default.Color1) $ "PING:" @ col(KFIRC(Owner).Default.Color2) $ PRI.Ping);
		}
		i++;
	}
}

defaultproperties
{
}
