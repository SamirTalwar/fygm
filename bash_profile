set -o vi

function is {
    return $1
}

function make_PS1 {
    exit_status=$?

    RED="\[\033[31m\]"
    GREEN="\[\033[32m\]"
    YELLOW="\[\033[33m\]"
    BLUE="\[\033[34m\]"
    ORANGE="\[\033[1;31m\]"
    END="\[\033[0m\]"

    in_git=$([[ -d .git ]] || git rev-parse --git-dir >/dev/null 2>&1; echo $?)
    if is $in_git
    then
        changed=$([[ ! -z "$(git status -s)" ]]; echo $?)
        branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        remote="$(git config --get branch.$branch.remote)"
        if [[ "$branch" == 'HEAD' ]]; then
            color=$RED
            branch='<no branch>'
        elif is $changed; then
            color=$RED
        elif [[ -z "$remote" ]]; then
            color=$BLUE
        else
            remote_exists=$(git branch -a | egrep "\b$remote/$branch\b" >/dev/null 2>&1; echo $?)
            pushed=$(is $remote_exists && [[ -z "$(git log --oneline $remote/$branch..)" ]]; echo $?)
            pulled=$(is $remote_exists && [[ -z "$(git log --oneline ..$remote/$branch)" ]]; echo $?)
            if is $pushed && is $pulled; then
                color=$GREEN
            else
                color=$YELLOW
            fi
        fi
        git=" $color$branch$END"
    fi

    if [[ $exit_status -ne 0 ]]
    then
        last_status="$ORANGE >> $exit_status << $END"
    fi
    echo "$BLUE\u$END@$GREEN\H$END \W$git$last_status$ "
}

PROMPT_COMMAND='PS1="$(make_PS1)"; '$PROMPT_COMMAND

if [[ $(uname) == 'Darwin' ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

[[ -e ~/.bash_profile.local ]] && source ~/.bash_profile.local
