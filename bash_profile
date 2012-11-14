function make_PS1 {
    BLUE='\e[34m'
    GREEN='\e[32m'
    END='\e[0m'

h   printf "\[$BLUE\]\u\[$END\]@\[$GREEN\]\H\[$END\] \W\$(git_PS1)\\$ "
}

function git_PS1 {
    GREEN='\e[32m'
    YELLOW='\e[33m'
    RED='\e[31m'
    END='\e[0m'

    in_git=$([[ -d .git ]] || git rev-parse --git-dir >/dev/null 2>&1 ; echo $?)
    if [[ $in_git -eq 0 ]]
    then
        changes=$(git status | grep '^nothing to commit, working directory clean$' >/dev/null 2>&1 ; echo $?)
        unpushed=$(git status | grep '^# Your branch is ahead ' >/dev/null 2>&1; echo $?)
        if [[ $changes -eq 0 ]]
        then
            color=$([[ $unpushed -eq 0 ]] && echo $YELLOW || echo $GREEN)
        else
            color=$RED
        fi
        printf " $color$(git branch | grep '^\*' | cut -d' ' -f2)$END"
    else
        echo ''
    fi
}

export PS1=$(make_PS1)

if [[ $(uname) == 'Darwin' ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

[[ -e ~/.bash_profile.local ]] && source ~/.bash_profile.local
