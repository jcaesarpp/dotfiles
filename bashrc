case $- in
    *i*)
    ;;
    *)
        return
    ;;
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
    PS1="${PS_CYAN}\u${PS_RESET}@${PS_GREEN}\h${PS_RESET} [ ${PS_CYAN}\w${PS_RESET} ]\n\$? \$(if [[ \$? == 0 ]]; then echo \"${PS_GREEN};)${PS_RESET}\"; else echo \"${PS_RED}:(${PS_RESET}\"; fi)${PS_RESET} "
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

[[ -d "${HOME}/.bin" ]] && \
    PATH="${PATH}:${HOME}/.bin"

[[ -d "${HOME}/.local/bin" ]] && \
    PATH="${PATH}:${HOME}/.local/bin"

[[ -d /media/store/develop/bash ]] && \
    PATH="${PATH}:/media/store/develop/bash"

[[ -f ~/.bash_aliases ]] && \
    . ~/.bash_aliases

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
export CDPATH=.:~:/media/store:/etc
export CALENDAR='Gregorian'
export AWT_TOOLKIT=MToolkit
export MANOPT='-L es_ES'
export PAGER='less'
export MANWIDTH=80
export _JAVA_AWT_WM_NONREPARENTING=1

export EDITOR='vim'
export RANGER_LOAD_DEFAULT_RC=false

PATH="/home/jcpp/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/jcpp/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/jcpp/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/jcpp/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/jcpp/perl5"; export PERL_MM_OPT;

export QT_QPA_PLATFORMTHEME=qgnomeplatform
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

#eval $(~/.linuxbrew/bin/brew shellenv)

# dtask
[[ -f ~/.dstask-bash-completions.sh ]] && source ~/.dstask-bash-completions.sh
alias task=dstask
alias t=dstask

# fzf
[[ -f /usr/share/fzf/shell/key-bindings.bash ]] && source /usr/share/fzf/shell/key-bindings.bash
[[ -f /usr/share/bash-completion/completions/fzf ]] && source /usr/share/bash-completion/completions/fzf
export FZF_DEFAULT_OPTS="--height 55% --multi --reverse --margin=0,1 --bind 'ctrl-f:page-down,ctrl-b:page-up,pgdn:preview-page-down,pgup:preview-page-up'"
export FZF_CTRL_R_OPTS="--sort --exact --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview,pgdn:preview-page-down,pgup:preview-page-up'"
export FZF_CTRL_T_OPTS="--select-1 --exit-0 --preview-window 'right:80%' --preview 'bat --color=always --style=header,grid --line-range :300 {}' --bind '?:toggle-preview,pgdn:preview-page-down,pgup:preview-page-up'"
export FZF_ALT_C_OPTS="--select-1 --exit-0 --preview 'tree -C {} | head -200' --bind '?:toggle-preview,pgdn:preview-page-down,pgup:preview-page-up'"
alias fvim='vim $(fzf)'

