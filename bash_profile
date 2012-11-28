function make_PS1 {
    RED="\[\033[31m\]"
    GREEN="\[\033[32m\]"
    YELLOW="\[\033[33m\]"
    BLUE="\[\033[34m\]"
    END="\[\033[0m\]"

    in_git=$([[ -d .git ]] || git rev-parse --git-dir >/dev/null 2>&1 ; echo $?)
    if [[ $in_git -eq 0 ]]
    then
        changes=$([[ -z "$(git diff ; git diff --cached)" ]]; echo $?)
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        [[ "$branch" == 'HEAD' ]] && return

        pushed=$([[ -z "$(git branch -r | grep origin/$branch)" || -z "$(git log origin/$branch..)" ]]; echo $?)
        if [[ $changes -eq 0 ]]
        then
            [[ $pushed -eq 0 ]] && color=$GREEN || color=$YELLOW
        else
            color=$RED
        fi
        git=" $color$branch$END"
    fi
    echo "$BLUE\u$END@$GREEN\H$END \W$git\\$ "
}

PROMPT_COMMAND='PS1="$(make_PS1)"; '$PROMPT_COMMAND

if [[ $(uname) == 'Darwin' ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

[[ -e ~/.bash_profile.local ]] && source ~/.bash_profile.local
