. /etc/ksh.kshrc

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

HISTFILE="$HOME/.ksh_history"
HISTSIZE=1000
HISTCONTROL=ingnoredups

export VISUAL="vim"
export EDITOR="$VISUAL"
set -o vi
