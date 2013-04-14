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

function bool AllowsBroadcast(Actor broadcaster, int Len) {
	if (NextBroadcastHandler != None) {
		return NextBroadcastHandler.AllowsBroadcast(broadcaster, Len);
	}
	return Super.AllowsBroadcast(broadcaster, Len);
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

	if (NextBroadcastHandler != None) {
		NextBroadcastHandler.Broadcast(Sender, Msg, Type);
	} else {
		Super.Broadcast(Sender, Msg, Type);
	}
}

function BroadcastTeam(Controller Sender, coerce string Msg, optional name Type) {
	if (PlayerController(Sender) != None) {
		if (Type == 'TeamSay') {
			ircSend(col(KFIRC(Owner).Default.Color3) $ ">>" @ col(KFIRC(Owner).Default.Color1) $ PlayerController(Sender).PlayerReplicationInfo.PlayerName $ ":" @ col(KFIRC(Owner).Default.Color2) $ Msg);
		}
	}

	if (NextBroadcastHandler != None) {
		NextBroadcastHandler.BroadcastTeam(Sender, Msg, Type);
	} else {
		Super.BroadcastTeam(Sender, Msg, Type);
	}
}

function AllowBroadcastLocalized(Actor Sender, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject) {
	if (NextBroadcastHandler != None) {
		NextBroadcastHandler.AllowBroadcastLocalized(Sender, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	} else {
		Super.AllowBroadcastLocalized(Sender, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	}
}

function UpdateSentText() {
	if (NextBroadcastHandler != None) {
		NextBroadcastHandler.UpdateSentText();
	} else {
		SentText = 0;
	}
}

defaultproperties
{
}
