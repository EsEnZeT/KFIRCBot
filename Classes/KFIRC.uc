Class KFIRC extends Actor Config;

var IRCLink irc;
var IRCSpec spec;
var IRCVariousDetect vdct;
var IRCBroadcastHandler bhand;
var IRCKillDetect kdct;
var bool ircConnected, needReconnection, needRejoin;
var config string ircServer, ircNick, ircChannel, ircPassword, botChar;
var config int ircPort, Color1, Color2, Color3;
var config bool hideIP, aO, aV, aAll, fLog, bDebug, rDemo;
const VERSION = "107";


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
	
	vdct = Spawn(Class'IRCVariousDetect');
	vdct.SetOwner(Self);

	bhand = Spawn(Class'IRCBroadcastHandler');
	bhand.SetOwner(Self);

	kdct = Spawn(Class'IRCKillDetect');
	kdct.SetOwner(Self);
	
	irc.Resolve(Default.ircServer);
}

defaultproperties
{
	ircServer="irc.freenode.net"
	ircPort=6667
	ircNick="KFIRCBot"
	ircChannel="#KFIRCBot"
	ircPassword=""
	botChar="DAR"
	hideIP=0
	color1=04
	color2=12
	color3=09
	aO=1
	aV=1
	aAll=1
	fLog=1
	bDebug=0
	rDemo=0
}