KFIRCBot
========

[Killing Floor] mutator that reports current game status to an IRC channel.

KFIRCBot was originally created by [Fox] on 11 January 2010 and can be found [here].

I take credits only for stuff listed below.

[Killing Floor]: http://store.steampowered.com/app/1250/
[Fox]: http://steamcommunity.com/id/foxrlx
[here]: http://www.epnteam.net/fox/KFIRCBot.rar


## News
### Fixed:
 * bot rejoin and lowered time to 15s
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

### Changed:
 * command `!scores` to `!status`
 * ability to parse `!status` from in-game chat (disabled)
 * a bit the look of messages showing from bot (etc. waves, chat)


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
```

Properly installed mutator should show in the server console something like this:
```
[+] Starting KFIRCBot version: 104
[+] SnZ - snz@spinacz.org
[+] Fox - http://www.epnteam.net/
Resolving irc.freenode.net...
Resolved irc.freenode.net (130.239.18.172)
```


## Usage
[`KFIRCBot`] is a fully automated mutator but you can also use following commands on channel:
* `!status` - force show current game status
* `!s <message>` - send message through bot to active game
[`KFIRCBot`]: https://raw.github.com/EsEnZeT/KFIRCBot/master/KFIRCBot.u


## Color Table
![Color Table](https://raw.github.com/EsEnZeT/KFIRCBot/master/screenshots/colors.png)


## Screenshots
![Bot](https://raw.github.com/EsEnZeT/KFIRCBot/master/screenshots/bot.png)

![In-game](https://raw.github.com/EsEnZeT/KFIRCBot/master/screenshots/ingame.jpg)


## License
Released under the GPL license (http://www.gnu.org/copyleft/gpl.html).

![githalytics.com alpha](https://cruel-carlota.pagodabox.com/48687fd4a86adc1568a4d7453bf85698 "githalytics.com")


