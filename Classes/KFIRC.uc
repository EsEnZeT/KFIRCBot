Class KFIRC extends Actor Config;

var IRCLink irc;
var IRCSpec spec;
var IRCPlayerJoin pjoin;
var IRCBroadcastHandler bhand;
var bool ircConnected, needReconnection, needRejoin;
var config string ircServer, ircNick, ircChannel, ircPassword, botChar;
var config int ircPort, Color1, Color2, Color3;
var config bool hideIP;
const VERSION = "104";


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

	bhand = Spawn(Class'IRCBroadcastHandler');
	bhand.SetOwner(Self);
	
	irc = Spawn(Class'IRCLink');
	irc.SetOwner(Self);
	
	pjoin = Spawn(Class'IRCPlayerJoin');
	pjoin.SetOwner(Self);

	irc.Resolve(Default.ircServer);
}

defaultproperties
{
}
