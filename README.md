KFIRCBot
========

[Killing Floor] mutator/server actor that reports current game status to an IRC channel and much more.

KFIRCBot was originally created by [Fox] on 11 January 2010 and can be found [here].

I take credits only for stuff listed below.

[Killing Floor]: http://store.steampowered.com/app/1250/
[Fox]: http://steamcommunity.com/id/foxrlx
[here]: http://www.epnteam.net/fox/KFIRCBot.rar


## News
### Fixed:
 * bot rejoin and lowered time to 10s
 * wave length naming
 * wave difficulty detection
 * IRC command parsing (now accepting capital/lowercase)
 * chat handling (now parsing also 'TeamSay')
 * bot appearance on kick list

### Added:
 * ability to send messages through bot to active game (shown as specified custom character)
 * ability to join channel protected with password
 * ability to hide players IPs (shown during player connects to the server)
 * nick to message showing when player exits the server
 * elapsed time to `!status` command
 * prefixes for chat messages `>>` and death messages `*`
 * permission handling (bot will respond now to certain users, with flag +o/+v/ALL)
 * option to enable/disable logging of gameplay to irc channel
 * option to record gameplay (stored in Demos folder in format `YYYY-MM-DD_HH-MM-SS_MapName.demo4`)
 * detection of zed kill (bot will post to channel who killed boss on last wave, prefixed by `~!~`)
 * `!help` command
 * nick in use handling (will add -[0-1000] to current bot nick)
 * `bDebug` which can help to diagnose problems on connection stage

### Changed:
 * command `!scores` to `!status`
 * ability to parse `!status` from in-game chat (disabled)
 * a bit the look of messages showing from bot (etc. waves, chat)


## Checksum
This is checksum for current release (v107) if doesn't match the file you have is unreliable!
```
ucc.exe Editor.CheckSumPackageCommandlet KFIRCBot.u
KFIRCBot.u checksum: 1e9ce6ce3c54d1b504eca8c1844992f3
```


## Installation
1. Place the [`KFIRCBot.u`] into `System` folder.
2. In you server config (def. `KillingFloor.ini`):
 * under the `[Engine.GameEngine]` add line: `ServerActors=KFIRCBot.KFIRC`
 * at the end add:
[`KFIRCBot.u`]: https://raw.github.com/EsEnZeT/KFIRCBot/master/KFIRCBot.u

```
[KFIRCBot.KFIRC]
ircServer= (ex.: irc.freenode.net)
ircPort= (ex.: 6667)
ircNick= (ex.: KFIRCBot)
ircChannel= (ex.: #yourchannel)
ircPassword= (password to channel, if any)
botChar= (ex.: DAR, check your *.upl files for names)
hideIP= (0 - show client IP on join; 1 - don't)
color1= (ex.: 04) (message types)
color2= (ex.: 12) (messages)
color3= (ex.: 09) (chat prefixes)
aO= (1 - allow to execute !commands by OP(s)/+o flag; 0 - don't)
aV= (1 - allow to execute !commands by VOICE(s)/+v flag; 0 - don't)
aAll= (1 - allow all users to execute !commands; 0 - don't)
fLog= (1 - log active gameplay events to channel on join; 0 - don't + not recommended)
bDebug= (1 - show messages in server console during connecting to irc server; 0 - don't)
rDemo= (1 - records demos; 0 - don't)
```
[You can find example configuration here].
[You can find example configuration here]: https://raw.github.com/EsEnZeT/KFIRCBot/master/example.ini

Properly installed mutator should show in the server console something like this:
```
[+] Starting KFIRCBot version: 107
[+] SnZ - snz@spinacz.org
[+] Fox - http://www.epnteam.net/
Resolving irc.freenode.net...
Resolved irc.freenode.net (130.239.18.172)
```

Keep in mind that if you won't configure bot, it will use default settings listed in [Main class].
[Main class]: https://github.com/EsEnZeT/KFIRCBot/blob/master/Classes/KFIRC.uc


## Optional
1. In you server config (def. `KillingFloor.ini`):
 * under the `[Engine.DemoRecDriver]` change following values:

```
NetServerMaxTickRate=61
LanServerMaxTickRate=61
```

This should fix recording demos in low framerate, same changes can be done for playback on the client.


## Usage
[`KFIRCBot`] is a fully automated mutator but you can also use following commands on channel:
* `!status` - force show current game status
* `!s <message>` - send message through bot to active game
* `!log <1/0>` - ON/OFF logging active gameplay events to channel.
* `!help` - will show all of the above commands, just in case if you forget

Even if `fLog` will be defined as 0 you can still get output from any commands posted above.
Only `!s <message>` won't care about `fLog` parameter (will send message to players and forcibly enable logging), because you want to get answers right?

For example, if you used `fLog=0` bot will join channel and won't log current gameplay as long as you don't tell him to do this: `!log 1`.
It can be usefull if you don't want too much spam, but if you want to use it without that, just specify `fLog=1` in config.
[`KFIRCBot`]: https://raw.github.com/EsEnZeT/KFIRCBot/master/KFIRCBot.u


## Color Table
![Color Table](https://raw.github.com/EsEnZeT/KFIRCBot/master/screenshots/colors.png)


## Screenshots
![Bot](https://raw.github.com/EsEnZeT/KFIRCBot/master/screenshots/bot.png)

![In-game](https://raw.github.com/EsEnZeT/KFIRCBot/master/screenshots/ingame.jpg)


## License
Released under the GPL license (http://www.gnu.org/copyleft/gpl.html).

![githalytics.com alpha](https://cruel-carlota.pagodabox.com/48687fd4a86adc1568a4d7453bf85698 "githalytics.com")


