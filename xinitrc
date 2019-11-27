#!/bin/bash

[ -f ~/.Xdefaults ] && xrdb -merge ~/.Xdefaults
setxkbmap us altgr-intl -option ctrl:nocaps

#autocutsel &
#oneko -dog &
#mpd
xautolock -time 3 -secure -locker xtrlock.sh &

exec awesome

