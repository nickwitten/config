## Colorize the ls output ##
alias ls='ls --color=auto'

## Use a long listing format ##
alias ll='ls -la --color=auto'

## Show hidden files ##
alias l.='ls -d .* --color=auto'

## Git ##
alias gitlog="git log --graph --pretty=format:'%Cred%h%Creset - %Cgreen(%ad)%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=local"

## Python ##
alias python='python3'
alias pip='pip3'

## TMUX ##
alias tmux="TERM=screen-256color-bce tmux"

alias powerdraw='echo - | awk "{printf \"%.1f\", $(( $(cat /sys/class/power_supply/BAT0/current_now) * $(cat /sys/class/power_supply/BAT0/voltage_now) )) / 1000000000000 }" ; echo " W "'

## Allow alias expansion for watch ##
alias watch='watch '

