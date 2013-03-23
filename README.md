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
 * bot rejoin and lowered time to 20s
 * wave length naming
 * wave difficulty detection
 * IRC command parsing (now accepting capital/lowercase)

### Added:
 * ability to send messages through bot to active game (shown as DAR character :)
 * ability to join channel protected with password
 * ability to hide players IPs (shown during player connects to the server)
 * nick to message showing when player exits the server
 * elapsed time to `!status` command

### Changed:
 * command `!scores` to `!status`
 * ability to parse `!status` from in-game chat (disabled)
 * a bit the look of messages showing from bot (etc. waves)


## Installation
1. Place the [`KFIRCBot.u`] into `System` folder.
2. In you server config (def. `KillingFloor.ini`):
 * under the `[Engine.GameEngine]` add line: `ServerActors=KFIRCBot.KFIRC`
 * at the end add:
[`KFIRCBot.u`]: https://raw.github.com/EsEnZeT/KFIRCBot/master/KFIRCBot.u

```
[KFIRCBot.KFIRC]
ircServer= (ex: irc.freenode.net)
ircPort= (ex: 6667)
ircNick= (ex: KFIRCBot)
ircChannel= (ex: #yourchannel)
ircPassword= (password to channel, if any)
hideIP= (0 - show client IP on join; 1 - don't)
color1= (ex: 04)
color2= (ex: 12)
```

Properly installed mutator should show in the server console something like this:
```
[+] Starting KFIRCBot version: 102
[+] Fox - http://www.epnteam.net/
[+] SnZ - snz@spinacz.org
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
