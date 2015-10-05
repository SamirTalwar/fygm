if [[ -d /usr/local/share/zsh/site-functions ]]; then
    fpath=(/usr/local/share/zsh/site-functions $fpath)
fi

source ${ZDOTDIR:-$HOME}/.zprezto/runcoms/zlogin

ssh-add ~/.ssh/*.pem 2>/dev/null

if [[ -e ~/.zlogin.local ]]; then
    source ~/.zlogin.local
fi
