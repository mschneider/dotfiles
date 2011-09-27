# are we on mac?
if [[ $(uname) = 'Darwin' ]]; then
  LS_COLOR_PARAM=-G
else
  LS_COLOR_PARAM=--color=auto
fi

# shortcuts
alias l="ls $LS_COLOR_PARAM"
alias la='l -A'
alias ll='l -l'
alias lla='l -lA'
alias g='git'
alias grep='grep --color'
alias rgrep='grep -rn'

# shell
export SHELL='/bin/zsh'

# editor
alias 'vi=vim'
alias 'm=mate'
export EDITOR='vi'
export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR
# fix zsh to emacs mode though
bindkey -e

# common typo..
alias 'cd..=cd ..'

# auto completion
autoload -Uz compinit
compinit

# report time stats for long running tasks
export REPORTTIME=30

# USER %n
# HOST %m
# TIME %T
# DIR  %c
# RET  %?
PROMPT='%B%T%b %m:%c%(!.#.$) '

# node
NODE_PATH='/usr/local/lib/node_modules'
# python
PYTHONPATH='/usr/local/lib/python2.6/site-packages'
# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
