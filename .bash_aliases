cattoless() {
	/usr/bin/cat "$1" | /usr/bin/less;
}

alias check='cattoless'

alias tshell='tmux new-session -s shell'
alias tmail='tmux new-session -s mail'
alias ttext='tmux new-session -s text'
alias cls='clear'
alias bye='exit'
