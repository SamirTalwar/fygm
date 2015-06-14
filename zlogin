if [[ -d /usr/local/share/zsh/site-functions ]]; then
    fpath=(/usr/local/share/zsh/site-functions $fpath)
fi

source ${ZDOTDIR:-$HOME}/.zprezto/runcoms/zlogin

if [[ -e ~/.zlogin.local ]]; then
    source ~/.zlogin.local
fi
