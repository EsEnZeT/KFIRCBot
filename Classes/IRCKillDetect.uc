Class IRCKillDetect extends MonsterController;


function ircSend(string msg) {
	KFIRC(Owner).irc.ircSend(msg);
}

function string col(int cor) {
	return chr(3) $ cor;
}

function NotifyKilled(Controller Killer, Controller Killed, pawn KilledPawn) {
	if (KFGameType(Level.Game).bWaveBossInProgress == True && KFGameType(Level.Game).WaveNum >= KFGameType(Level.Game).FinalWave) {
		if (InStr(KilledPawn, "ZombieBoss") != -1) {
			ircSend(col(KFIRC(Owner).Default.Color3) $ "~!~" @ col(KFIRC(Owner).Default.Color1) $ Killer.PlayerReplicationInfo.PlayerName @ col(KFIRC(Owner).Default.Color2) $ "killed Patriarch!");
		}
	}
	Super.NotifyKilled(Killer, Killed, KilledPawn);
}

defaultproperties
{
}