Class IRCLink extends TCPLink;

var int stats;
var bool fLog;
var array<string> users;


Function PreBeginPlay() {
	stats = 0;
	fLog = Class'KFIRC'.Default.fLog;
	ReceiveMode = RMODE_Event;
	LinkMode = MODE_Line;
}

function ircsendIRCInfo() {
	SendText("NICK" @ KFIRC(Owner).Default.ircNick $ Chr(10));
	SendText("USER" @ KFIRC(Owner).Default.ircNick @ "localhost" @ KFIRC(Owner).Default.ircServer @ ":" $ KFIRC(Owner).Default.ircNick $ Chr(10));
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

Event Resolved(IpAddr ipAddress) {
	ircConnect(ipAddress);
}

function opened() {
	stats = 0;
	SetTimer(2, True);
	KFIRC(Owner).ircConnected = True;
}

function Timer() {
	if (stats == 0) {
		ircSendIRCInfo();
	}

	if (stats == 1) {
		ircJoinChannel();
	}
}

function ircSend(string msg) {
	if (stats == 2 && fLog) {
		SendText("PRIVMSG" @ KFIRC(Owner).Default.ircChannel @ ":" $ msg $ chr(10));
	}
}

function string col(int cor) {
	return chr(3) $ cor;
}

Function ReceivedLine(string Line) {
	local array<string> Data;
	local int i;

	Split(Line, Chr(10), Data);
	if (Data.Length > 0) {
		For (i = 0; i < Data.Length; ++i) {
			ProcessLine(Data[i]);
		}
	} else {
		ProcessLine(Line);
	}
}

function bool CheckPerms(string msg, string ircNick) {
	local int i;
	local string ircNickT;
	
	if (KFIRC(Owner).Default.aAll) {
		return True;
	} else {
		for (i = 0; i < users.Length; ++i) {
			if (InStr("@%+", Left(users[i], 1)) != -1) {
				ircNickT = Mid(users[i], 1);
			}

			if (ircNickT == ircNick) {
				if (KFIRC(Owner).Default.aO && (Left(users[i], 1) == "@" || Left(users[i], 1) == "%")) {
					return True;
				} else if (KFIRC(Owner).Default.aV && Left(users[i], 1) == "+") {
					return True;
				}
			}
		}
	}
}

function ProcessLine(string msg) {
	local array<string> Data;
	local string bmsg, ircNick;

	Split(msg, " ", Data);
	if (InStr(msg, "PING") != -1) {
		SendText("PONG :" $ Right(msg, Len(msg) - 6) $ chr(10));
	}

	if (InStr(msg, " PRIVMSG ") != -1) {
		Split(msg, ":", Data);
		Split(Data[1], "!", Data);
		ircNick = Data[0];
		Split(msg, ":", Data);
		Split(Data[2], " ", Data);

		if (CheckPerms(msg, ircNick)) {
			if (Data[0] ~= "!status") {
				fLog = True;
				KFIRC(Owner).spec.SStatus();
				fLog = KFIRC(Owner).Default.fLog;
			}

			if (Data[0] ~= "!s") {
				fLog = True;
				bmsg = Mid(msg, InStr(Locs(msg), ":!s") + 4);
				KFIRC(Owner).spec.MsgSend(bmsg);
			}

			if (Data[0] ~= "!log") {
				if (Mid(msg, InStr(Locs(msg), ":!log") + 6) == "1") {
					fLog = True;
					ircSend(col(KFIRC(Owner).Default.Color3) $ "[!]" @ col(KFIRC(Owner).Default.Color1) $ "Live logging enabled!");
				} else if (Mid(msg, InStr(Locs(msg), ":!log") + 6) == "0") {
					fLog = True;
					ircSend(col(KFIRC(Owner).Default.Color3) $ "[!]" @ col(KFIRC(Owner).Default.Color1) $ "Live logging disabled!");
					fLog = False;
				}
			}

			if (Data[0] ~= "!help") {
				fLog = True;
				ircSend(col(KFIRC(Owner).Default.Color1) $ "!status  -  " $ col(KFIRC(Owner).Default.Color2) $ "force show current game status.");
				ircSend(col(KFIRC(Owner).Default.Color1) $ "!s <message>  -  " $ col(KFIRC(Owner).Default.Color2) $ "send message through bot to active game.");
				ircSend(col(KFIRC(Owner).Default.Color1) $ "!log <1/0>  -  " $ col(KFIRC(Owner).Default.Color2) $ "ON/OFF logging active gameplay events to channel.");
				fLog = KFIRC(Owner).Default.fLog;
			}
		}
	}
	Split(msg, " ", Data);
	
	if (Data[1] == "KICK") {
		KFIRC(Owner).needRejoin = True;
		KFIRC(Owner).SetTimer(10, False);
	}

	if (stats == 2 && (Data[1] == "NICK" || Data[1] == "MODE")) {
		SendText("NAMES" @ KFIRC(Owner).Default.ircChannel $ chr(10));
	}	

	if (Data[1] == "353") {
		Split(msg, "#", users);
		Split(users[1], ":", users);
		Split(users[1], " ", users);	
	}	
	
	if (Data[1] == "451") {
		stats = 0;
	}
	
	if (Data[1] == "001") {
		stats = 1;
	}
	
	if (Data[1] == "JOIN") {
		stats = 2;
		KFIRC(Owner).SetTimer(0, False);
		SetTimer(0, False);
	}
}

defaultproperties
{
}