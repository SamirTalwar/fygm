set -o vi

if $(which node >/dev/null 2>&1); then
    function _update_ps1() {
        export PS1="$(~/dotfiles/powerline-js/powerline.js $? --shell bash --depth 1)"
    }
    export PROMPT_COMMAND="_update_ps1"
fi

if [[ $(uname) == 'Darwin' ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

[[ -e ~/.bash_profile.local ]] && source ~/.bash_profile.local
