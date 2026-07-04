PS1='\[\033[01;33m\](container) \[\033[01;32m\]\u@\h\[\033[01;34m\] \w $\[\033[00m\] '

HISTCONTROL=ignoreboth
HISTIGNORE="l:q:h *:..:..."

function rgc()
{
    rg --colors path:fg:cyan --colors path:style:bold -p "$@" | less -RFX
}

eval "`dircolors`"

alias l="ls --time-style=long-iso --color=always -laF"
alias ll="ls --time-style=long-iso --color=auto -laF"
alias ls="ls --time-style=long-iso --color=auto"
alias dt="date --utc '+%Y-%m-%d %H:%M:%S UTC'"
alias g="grep --exclude-dir .git --exclude-dir .svn --color=always"
alias o="less -r"
alias q=" history -d -1"
alias rg='rg --colors path:fg:cyan --colors path:style:bold'
alias s=tmux
alias t='tmux attach-session -d || tmux'
alias v="vim"
alias ..="cd .."
alias ...="cd ../.."
