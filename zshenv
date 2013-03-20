if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
fi

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

[[ -e ~/.zshenv.local ]] && source ~/.zshenv.local
