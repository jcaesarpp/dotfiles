# functions
function md () { mkdir -p "$@" && eval cd "\"\$$#\""; }
function hgrep () { history | grep "$@" | less; }
function pping () { ping "$1" | xargs -n1 -i bash -c 'echo `date +%y-%m-%d\ %H:%M:%S`" {}"' | ccze; }

function mranger () {
    tempfile='/tmp/chosendir'
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}" $@
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)"  ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

function tomkv () {
    for i in `ls *$@`; do ffmpeg -y -threads 4 -i "$i" `basename "$i" "$@"`mkv && rm -f "$i"; done
}

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
alias ffmpeg='ffmpeg -y -threads 4'
alias history='history | less'
alias zip='zip -9r'
alias vim='vim -p'
alias df='df -lhPT --total'
alias x='cd; startx &! logout'
alias rsync='rsync -rvzhP'
alias srsync='sudo rsync -rvzhP'
alias nurl='vim ~/.newsbeuter/urls && sort ~/.newsbeuter/urls | uniq > /tmp/urls && cp /tmp/urls ~/.newsbeuter/urls'
alias mutt='cd ~/Desktop && mutt'
alias chromium='chromium --proxy-server=192.168.12.200:8080'

alias ctest='for i in {0..255}; do printf "\x1b[38;5;${i}mcolour${i} " ; done ; echo '

alias trash='mv --force -t ~/.local/share/Trash'
alias find='find -L'

alias rm_desktop.ini='find . -iname "desktop.ini" -type f -exec rm -fv {} \;'
alias rm_thumbs.db='find . -iname "thumbs.db" -type f -exec rm -fv {} \;'
alias rm_picasa.ini='find . -iname "*picasa.ini" -type f -exec rm -fv {} \;'
alias rm_disturb='rm_desktop.ini; rm_thumbs.db; rm_picasa.ini'

alias search='aptitude search'
alias show='aptitude show'

_apt_install_complete() { 
    mapfile -t COMPREPLY < <(apt-cache --no-generate pkgnames "$2");
}

complete -F _apt_install_complete search
complete -F _apt_install_complete show

# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
    #alias synaptic='sudo synaptic'
    alias apt-get='sudo apt-get --allow-unauthenticated'
    alias update='apt-get --fix-missing update'
    alias upgrade='apt-get upgrade'
    alias install='sudo apt -f install --no-install-recommends --allow-unauthenticated'
    alias remove='apt-get remove'
    alias purge='apt-get autoremove --purge'
    alias clean='apt-get clean'
    #alias systemctl='sudo systemctl'
    alias vi='sudo vim -p'
    
    complete -F _apt_install_complete install
fi

