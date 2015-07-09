eval "$(ssh-agent -k)" >/dev/null

if [[ -e ~/.zlogout.local ]]; then
    source ~/.zlogout.local
fi
