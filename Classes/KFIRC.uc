class KFIRC extends Actor Config;

var IRCLink irc;
var IRCSpec Spect;
var IRCPlayerJoin pjoin;
var string mapName;
var bool ircConnected;
var bool needReconnection;
var bool needRejoin;

var config string ircServer;
var config int ircPort;
var config string ircNick;
var config string ircChannel;
var config string ircPassword;
var config int Color1;
var config int Color2;
var config bool hideIP;
const VERSION = "102";


Function Timer()
{
	if (needReconnection)
	{
		ircMakeConnection();
		needReconnection = False;
	}

	If (needRejoin) {
		IRC.ircJoinChannel();
		needRejoin = False;
	}
}

function ircSend(String msg)
{
	irc.ircSend(msg);
}

function postBeginPlay() {
	super.postBeginPlay();
	log("[+] Starting KFIRCBot version:" @ VERSION);
	log("[+] Fox - http://www.epnteam.net/");
	log("[+] SnZ - snz@spinacz.org");
	ircMakeConnection();
}

function ircMakeConnection() {
	Spect = Spawn(Class'IRCSpec');
	Spect.SetOwner(Self);
	Spect.SetTimer(1.00, True);

	irc = Spawn(Class'IRCLink');
	irc.SetOwner(Self);
	
	pjoin = Spawn(Class'IRCPlayerJoin');
	pjoin.SetOwner(Self);

	irc.Resolve(Default.ircServer);
}

defaultproperties
{
}
