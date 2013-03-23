class IRCLink extends TCPLink;

var int stats;


Function PreBeginPlay()
{
	stats = 0;
	ReceiveMode = RMODE_Event;
	LinkMode = MODE_Line;
}

function ircsendIRCInfo() {
	SendText("NICK" @ KFIRC(Owner).Default.ircNick $ Chr(10));
	SendText("USER" @ KFIRC(Owner).Default.ircNick @ KFIRC(Owner).Default.ircNick @ KFIRC(Owner).Default.ircNick @ ":" $ KFIRC(Owner).Default.ircNick $ Chr(10));
	stats = 1;
}

function ircConnect(IpAddr ipAddress) {
	ipAddress.Port = KFIRC(Owner).Default.ircPort;
	BindPort();
	open(ipAddress);
}

function ircJoinChannel() {
	stats = 2;
	SendText("JOIN" @ KFIRC(Owner).Default.ircChannel @ KFIRC(Owner).Default.ircPassword $ chr(10));
}

Event Resolved(IpAddr ipAddress)
{
	ircConnect(ipAddress);
}

function opened() {
	stats = 0;
	SetTimer(5,True);
	KFIRC(Owner).ircConnected = True;
}

function Timer()
{
	if (Stats == 0)
		ircSendIRCInfo();
	if (Stats == 1)
		ircJoinChannel();
}

function ircSend(string msg) {
	if (stats == 2)
		SendText("PRIVMSG" @ KFIRC(Owner).Default.ircChannel @ ":" $ msg $ chr(10));
}

Function ReceivedLine(string Line)
{
	Local Array<String> Data;
	Local Int i;

	Split(Line, Chr(10), Data);
	if (Data.Length > 0)
		For (i = 0; i < Data.Length; i++)	
			ProcessLine(Data[i]);
	else
		ProcessLine(Line);
}

function ProcessLine(string msg)
{
	Local Array<String> Data;
	Local string ircNick;
	Local string bmsg;
	Split(msg," ",Data);

	if (InStr(msg, "PING") != -1)
	{
		SendText("PONG :" $ Right(msg, Len(msg) - 6) $ chr(10));
	}
	if (InStr(msg,"PRIVMSG") != -1)
	{
		Split(msg,":",Data);
		Split(Data[1],"!",Data);
		ircNick = Data[0];
		Split(msg,":",Data);
		Split(Data[2]," ",Data);
		if (Locs(Data[0]) == "!status")
		{
			KFIRC(Owner).Spect.SStatus();
		}
		if (Locs(Data[0]) == "!s")
		{
			bmsg = Mid(msg, InStr(Locs(msg), ":!s") + 4);
			KFIRC(Owner).Spect.MsgSend(bmsg);
		}
	}
	//Got this from another script.
	Split(msg," ",Data);
	if (Data[1] ~= "KICK")
	{
		KFIRC(Owner).needRejoin = True;
		KFIRC(Owner).SetTimer(20, True);
	}
	if (Data[1] == "451")
		Stats = 0;

	if (Data[1] == "001")
		Stats = 1;
	
	if (Data[1] == "JOIN")
		Stats = 2;
}

defaultproperties
{
}
