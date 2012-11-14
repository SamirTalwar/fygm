function make_PS1 {
    BLUE='\e[34m'
    GREEN='\e[32m'
    END='\e[0m'

    printf "\[$BLUE\]\u\[$END\]@\[$GREEN\]\H\[$END\] \W\$(git_PS1)\\$ "
}

function git_PS1 {
    GREEN='\e[32m'
    YELLOW='\e[33m'
    RED='\e[31m'
    END='\e[0m'

    in_git=$([[ -d .git ]] || git rev-parse --git-dir >/dev/null 2>&1 ; echo $?)
    if [[ $in_git -eq 0 ]]
    then
        changes=$([[ -z "$(git status -s)" ]]; echo $?)
        branch=$(git rev-parse --abbrev-ref HEAD)
        pushed=$([[ -z "$(git log origin/$branch..)" ]]; echo $?)
        if [[ $changes -eq 0 ]]
        then
            color=$([[ $pushed -eq 0 ]] && echo $GREEN || echo $YELLOW)
        else
            color=$RED
        fi
        printf " $color$branch$END"
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
