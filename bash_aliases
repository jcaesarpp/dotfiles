# functions
md () { mkdir -p "$@" && eval cd "\"\$$#\""; }
hgrep () { history | grep "$@" | less; }
pping () { ping "$1" | xargs -n1 -i bash -c 'echo `date +%y-%m-%d\ %H:%M:%S`" {}"' | ccze; }

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -hF'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto -i'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -l'
alias lla='ls -la'
alias la='ls -A'
alias l='ls -C'

# for navigating with cd
alias .1='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'

# general programs
alias dleft='echo "Left $(($(date +%j -d"Dec 31")-$(date +%-j))) days to end $(date +%Y)."'
alias history='history | less'
alias zip='zip -9r'
alias vim='vim -p'
alias df='df -lhPT --total'
alias x='cd; startx &! logout'
alias rsync='rsync -rvzhP'
alias srsync='sudo rsync -rvzhP'
alias nurl='vim ~/.newsboat/urls && sort ~/.newsboat/urls | uniq > /tmp/newsboat.urls && mv /tmp/newsboat.urls ~/.newsboat/urls'
alias mutt='cd ~/Desktop && mutt'

alias ctest='for i in {0..255}; do printf "\x1b[38;5;${i}mcolour${i} " ; done ; echo '

alias trash='mv --force -t ~/.local/share/Trash'
alias find='find -L'

alias rm_desktop.ini='find . -iname "desktop.ini" -type f -exec rm -fv {} \;'
alias rm_thumbs.db='find . -iname "thumbs.db" -type f -exec rm -fv {} \;'
alias rm_picasa.ini='find . -iname "*picasa.ini" -type f -exec rm -fv {} \;'
alias rm_disturb='rm_desktop.ini; rm_thumbs.db; rm_picasa.ini'

case $HOSTNAME in
    laptop-jpompa )
        #source /media/store/workspaces/scanntech/infra-docs/bash_scanntech_infraestructura.sh
        source ~/.private/scanntech/00-functions.sh
        source ~/.private/scanntech/aliases_scanntech.sh
        alias navicat="${HOME}/.navicat121_premium_es_x64/start_navicat"

        source ~/.private/aliases_dnf.sh
    ;;
    * )
        source ~/.private/aliases_apt.sh
    ;;
esac

source ~/.private/scanntech/00-functions.sh

alias docker=podman
alias docker-compose=podman-compose

