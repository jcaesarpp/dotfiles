case $- in
    *i*) ;;
*) return;;
esac

shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell
shopt -s globstar

stty -ixon

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS_RESET='\[\033[0m\]'
    PS_RED='\[\033[1;31m\]'
    PS_CYAN='\[\033[1;36m\]'
    PS_GREEN='\[\033[1;32m\]'
    PS_BLUE='\[\033[0;34m\]'
    PS_BLACK='\[\033[0;30m\]'
    PS_BROWN='\[\033[1;33m\]'
    PS_PURPLE='\[\033[1;35m\]'
    #PS1="$PS_RED[ \w ]\n$PS_CYAN\u$PS_RESET@$PS_GREEN\h$PS_RESET: "
    PS1="${PS_CYAN}\u${PS_RESET}@${PS_GREEN}\h${PS_RESET} [ ${PS_RED}\w${PS_RESET} ]\n\$? \$(if [[ \$? == 0 ]]; then echo \"${PS_GREEN};)${PS_RESET}\"; else echo \"${PS_RED}:(${PS_RESET}\"; fi)${PS_RESET} "
else
    #PS1='${debian_chroot:+($debian_chroot)}[ \w ]\n\u@\h: '
    PS1='\u@\h [ \w ]\n\$? \$(if [[ \$? == 0 ]]; then echo \";)\"; else echo \":(\"; fi) : '
fi
unset color_prompt force_color_prompt

case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#if [ -f ~/.tmux.exec ]; then
#    . ~/.tmux.exec
#fi

# time zone data
export TZ='America/Montevideo'

# history
export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTTIMEFORMAT='%F %T '
export HISTSIZE=3000
export HISTFILESIZE=3000
export HISTFILE=~/.bash_history

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# general programs
export CDPATH=.:~:~/store:/etc
export CALENDAR='Gregorian'
export AWT_TOOLKIT=MToolkit
export MANOPT='-L es_ES'
export PAGER='less'
export MANWIDTH=80
export _JAVA_AWT_WM_NONREPARENTING=1

export EDITOR='vim'
export RANGER_LOAD_DEFAULT_RC=false

