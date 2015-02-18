if [[ -d /usr/local/share/zsh/site-functions ]]; then
    fpath=(/usr/local/share/zsh/site-functions $fpath)
fi

source ${ZDOTDIR:-$HOME}/.zprezto/runcoms/zlogin

[[ -e ~/.zlogin.local ]] && source ~/.zlogin.local
