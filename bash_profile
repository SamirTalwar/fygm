set -o vi

function _update_ps1() {
    export PS1="$(~/dotfiles/powerline-shell/powerline-shell.py $?) "
}

export PROMPT_COMMAND="_update_ps1"

if [[ $(uname) == 'Darwin' ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

[[ -e ~/.bash_profile.local ]] && source ~/.bash_profile.local
