//Modified from serverext PlayerJoinLog
class IRCPlayerJoin extends info;

/** player cache record */
struct PlayerCache
{
  var string name;
  var string ip;
  /** magic number to find parted players */
  var int magic;
  /** is spectator */
  var bool spec;
};

var array<PlayerCache> cache;
var int lastID;


function ircSend(String msg)
{
	KFIRC(Owner).irc.ircSend(msg);
}

function string coloring(int cor) {
	return chr(3) $ cor;
}

function PreBeginPlay()
{
    Disable('Tick');
	setTimer(1, true);
    lastID = -1;
}

function Tick(float DeltaTime)
{
    CheckPlayerList();
}

event Timer()
{
    CheckPlayerList();
}

function CheckPlayerList()
{
    local int pLoc, magicint;
    local string ipstr, pip, ts;
    local PlayerController PC;
    local Controller C;

    lastID = Level.Game.CurrentID;

    if (lastID > cache.length) cache.length = lastID+1; // make cache larger
    magicint = Rand(MaxInt);

    for (C = Level.ControllerList; C != None; C = C.NextController)
    {
        PC = PlayerController(C);
        if (PC == none) continue;

        pLoc = PC.PlayerReplicationInfo.PlayerID;
        ipstr = PC.GetPlayerNetworkAddress();
		
		if (KFIRC(Owner).Default.hideIP)
		{
			pip = "?";
		}
		else
		{
			pip = ipstr;
		}		
				
        if (ipstr != "")
        {
            if (cache[pLoc].ip != ipstr)
            {
                if (ts == "") ts = Timestamp();
                cache[pLoc].spec = PC.PlayerReplicationInfo.bOnlySpectator;
                cache[pLoc].ip = ipstr;
                cache[pLoc].name = PC.PlayerReplicationInfo.PlayerName;
                //LogLine("["$Eval(cache[pLoc].spec,"SPECTATOR","PLAYER")$"_JOIN] "$ts$chr(9)$PC.PlayerReplicationInfo.PlayerName$chr(9)$ipstr$chr(9)$PC.Player.CurrentNetSpeed$chr(9)$PC.GetPlayerIDHash());
				ircSend(coloring(KFIRC(Owner).Default.Color1) $ "Player joins:" @ coloring(KFIRC(Owner).Default.Color2) $ PC.PlayerReplicationInfo.PlayerName @ coloring(KFIRC(Owner).Default.Color1) $ "IP:" @ coloring(KFIRC(Owner).Default.Color2) $ pip);
            }
            else if (cache[pLoc].name != PC.PlayerReplicationInfo.PlayerName)
            {
                if (ts == "") ts = Timestamp();
                //LogLine("["$Eval(cache[pLoc].spec,"SPECTATOR","PLAYER")$"_NAME_CHANGE] "$ts$chr(9)$cache[pLoc].name$chr(9)$PC.PlayerReplicationInfo.PlayerName);
				ircSend(coloring(KFIRC(Owner).Default.Color1) $ "Player joins:" @ coloring(KFIRC(Owner).Default.Color2) $ PC.PlayerReplicationInfo.PlayerName @ coloring(KFIRC(Owner).Default.Color1) $ "IP:" @ coloring(KFIRC(Owner).Default.Color2) $ pip);
                cache[pLoc].name = PC.PlayerReplicationInfo.PlayerName;
            }
            cache[pLoc].magic = magicint;
        }
    }

    // check parts
    for (pLoc = 0; pLoc < cache.length; pLoc++)
    {
        if ((cache[pLoc].magic != magicint) && (cache[pLoc].magic > -1) && (cache[pLoc].ip != ""))
        {
            if (ts == "") ts = Timestamp();
            cache[pLoc].magic = -1;
            //LogLine("["$Eval(cache[pLoc].spec,"SPECTATOR","PLAYER")$"_PART] "$ts$chr(9)$cache[pLoc].name);
			ircSend(coloring(KFIRC(Owner).Default.Color1) $ "Player left:" @ coloring(KFIRC(Owner).Default.Color2) $ cache[pLoc].name);
        }
    }
}


function string GetServerPort()
{
    local string S;
    local int i;
    S = Level.GetAddressURL();
    i = InStr(S, ":");
    return Mid(S,i+1);
}

function string GetServerIP()
{
    local string S;
    local int i;
    S = Level.GetAddressURL();
    i = InStr(S, ":");
    return Left(S,i);
}

/** put out a time stamp */
function string Timestamp()
{
    return Level.Year$"/"$Level.Month$"/"$Level.Day$" "$Level.Hour$":"$Level.Minute$":"$Level.Second;
}

defaultproperties
{
}
