#!/bin/bash

[ -f ~/.Xdefaults ] && xrdb -merge .Xdefaults
setxkbmap us altgr-intl -option ctrl:nocaps

#mpd
#xautolock -time 3 -secure -locker xtrlock.sh &

exec awesome

