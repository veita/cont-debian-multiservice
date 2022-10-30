PS1='\[\033[01;33m\](container) \u@\h\[\033[01;34m\] \w \$\[\033[00m\] '

eval "`dircolors`"

alias ls='ls --time-style=long-iso --color=auto'
alias ll='ls --time-style=long-iso --color=auto -al'
alias  l='ls --time-style=long-iso --color=always -al'

alias ..='cd ..'
alias ...='cd ../..'

alias v=vim
alias s=screen
alias t="screen -dr || screen"
alias o='less -R'
alias g="grep --exclude-dir .git --exclude-dir .svn --color=auto"
