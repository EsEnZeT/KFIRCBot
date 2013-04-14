Class IRCPlayerJoin extends Info;

struct PlayerCache {
	var string name, ip;
	var int magic;
	var bool spec;
};

var array<PlayerCache> cache;
var int lastID;


function PreBeginPlay() {
	Disable('Tick');
	setTimer(1, True);
	lastID = -1;
}

function ircSend(string msg) {
	KFIRC(Owner).irc.ircSend(msg);
}

function string col(int cor) {
	return chr(3) $ cor;
}

function Tick(float DeltaTime) {
	CheckPlayerList();
}

event Timer() {
	CheckPlayerList();
}

function CheckPlayerList() {
	local int pLoc, magicint;
	local string ipstr, pip, ts;
	local PlayerController PC;
	local Controller C;

	lastID = Level.Game.CurrentID;

	if (lastID > cache.length) {
		cache.length = lastID + 1; // make cache larger
	}
	magicint = Rand(MaxInt);

	for (C = Level.ControllerList; C != None; C = C.NextController) {
		PC = PlayerController(C);

		if (PC == None) {
			continue;
		}
		
		pLoc = PC.PlayerReplicationInfo.PlayerID;
		ipstr = PC.GetPlayerNetworkAddress();
		
		if (KFIRC(Owner).Default.hideIP) {
			pip = "?";
		} else {
			pip = ipstr;
		}		
				
		if (ipstr != "") {
			if (cache[pLoc].ip != ipstr) {
				if (ts == "") {
					ts = Timestamp();
				}
				cache[pLoc].spec = PC.PlayerReplicationInfo.bOnlySpectator;
				cache[pLoc].ip = ipstr;
				cache[pLoc].name = PC.PlayerReplicationInfo.PlayerName;
				ircSend(col(KFIRC(Owner).Default.Color1) $ "Player joins:" @ col(KFIRC(Owner).Default.Color2) $ PC.PlayerReplicationInfo.PlayerName @ col(KFIRC(Owner).Default.Color1) $ "IP:" @ col(KFIRC(Owner).Default.Color2) $ pip);
			}
			else if (cache[pLoc].name != PC.PlayerReplicationInfo.PlayerName) {
				if (ts == "") {
					ts = Timestamp();
				}
				ircSend(col(KFIRC(Owner).Default.Color1) $ "Player joins:" @ col(KFIRC(Owner).Default.Color2) $ PC.PlayerReplicationInfo.PlayerName @ col(KFIRC(Owner).Default.Color1) $ "IP:" @ col(KFIRC(Owner).Default.Color2) $ pip);
				cache[pLoc].name = PC.PlayerReplicationInfo.PlayerName;
			}
			cache[pLoc].magic = magicint;
		}
	}

	// check parts
	for (pLoc = 0; pLoc < cache.length; pLoc++) {
		if ((cache[pLoc].magic != magicint) && (cache[pLoc].magic > -1) && (cache[pLoc].ip != "")) {
			if (ts == "") {
				ts = Timestamp();
			}
			cache[pLoc].magic = -1;
			ircSend(col(KFIRC(Owner).Default.Color1) $ "Player left:" @ col(KFIRC(Owner).Default.Color2) $ cache[pLoc].name);
		}
	}
}

function string Timestamp() {
	return Level.Year$"/"$Level.Month$"/"$Level.Day$" "$Level.Hour$":"$Level.Minute$":"$Level.Second;
}

defaultproperties
{
}
