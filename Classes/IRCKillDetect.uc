Class IRCKillDetect extends GameRules;


function PostBeginPlay() {
    NextGameRules = Level.Game.GameRulesModifiers;
    Level.Game.GameRulesModifiers = Self;
}

function ircSend(string msg) {
	KFIRC(Owner).irc.ircSend(msg);
}

function string col(int cor) {
	return chr(3) $ cor;
}

function ScoreKill(Controller Killer, Controller Killed) {
	if (KFGameType(Level.Game).bWaveBossInProgress == True && KFGameType(Level.Game).WaveNum >= KFGameType(Level.Game).FinalWave) {
		if (Killer != None && Killed.Pawn.IsA('ZombieBoss')) {
			ircSend(col(KFIRC(Owner).Default.Color3) $ "~!~" @ col(KFIRC(Owner).Default.Color1) $ Killer.PlayerReplicationInfo.PlayerName @ col(KFIRC(Owner).Default.Color2) $ "killed Patriarch!");
		}
	}
    Super.ScoreKill(Killer, Killed);
}

defaultproperties
{
}