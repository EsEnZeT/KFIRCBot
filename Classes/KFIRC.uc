Class KFIRC extends Actor Config;

var IRCLink irc;
var IRCSpec spec;
var IRCPlayerJoin pjoin;
var IRCBroadcastHandler bhand;
var IRCKillDetect kdct;
var bool ircConnected, needReconnection, needRejoin;
var config string ircServer, ircNick, ircChannel, ircPassword, botChar;
var config int ircPort, Color1, Color2, Color3;
var config bool hideIP, aO, aV, aAll, fLog, bDebug;
const VERSION = "106";


function postBeginPlay() {
	Super.postBeginPlay();
	log("[+] Starting KFIRCBot version:" @ VERSION);
	log("[+] SnZ - snz@spinacz.org");
	log("[+] Fox - http://www.epnteam.net/");
	ircMakeConnection();
}

Function Timer() {
	if (needReconnection) {
		ircMakeConnection();
		needReconnection = False;
	}

	if (needRejoin) {
		irc.ircJoinChannel();
		needRejoin = False;
	}
}

function ircMakeConnection() {
	spec = Spawn(Class'IRCSpec');
	spec.SetOwner(Self);
	spec.SetTimer(1.00, True);

	irc = Spawn(Class'IRCLink');
	irc.SetOwner(Self);
	
	pjoin = Spawn(Class'IRCPlayerJoin');
	pjoin.SetOwner(Self);

	bhand = Spawn(Class'IRCBroadcastHandler');
	bhand.SetOwner(Self);

	kdct = Spawn(Class'IRCKillDetect');
	kdct.SetOwner(Self);
	
	irc.Resolve(Default.ircServer);
}

defaultproperties
{
}