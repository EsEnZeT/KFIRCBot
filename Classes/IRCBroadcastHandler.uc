Class IRCBroadcastHandler extends BroadcastHandler;


function PostBeginPlay() {
	NextBroadcastHandler = Level.Game.BroadcastHandler;
	Level.Game.BroadcastHandler = Self;
}

function ircSend(string msg) {
	KFIRC(Owner).irc.ircSend(msg);
}

function string col(int cor) {
	return chr(3) $ cor;
}

function Broadcast(Actor Sender, coerce string Msg, optional name Type) {
	if (PlayerController(Sender) != None) {
		if (Type == 'Say') {
			ircSend(col(KFIRC(Owner).Default.Color3) $ ">>" @ col(KFIRC(Owner).Default.Color1) $ PlayerController(Sender).PlayerReplicationInfo.PlayerName $ ":" @ col(KFIRC(Owner).Default.Color2) $ Msg);
		}
	}

	if (Type == 'DeathMessage') {
		ircSend(col(KFIRC(Owner).Default.Color3) $ "*" @ col(KFIRC(Owner).Default.Color1) $ "Death:" @ col(KFIRC(Owner).Default.Color2) $ Msg);
	}

	Super.Broadcast(Sender, Msg, Type);
}

function BroadcastTeam(Controller Sender, coerce string Msg, optional name Type) {
	if (PlayerController(Sender) != None) {
		if (Type == 'TeamSay') {
			ircSend(col(KFIRC(Owner).Default.Color3) $ ">>" @ col(KFIRC(Owner).Default.Color1) $ PlayerController(Sender).PlayerReplicationInfo.PlayerName $ ":" @ col(KFIRC(Owner).Default.Color2) $ Msg);
		}
	}
	
	Super.BroadcastTeam(Sender, Msg, Type);	
}

defaultproperties
{
}