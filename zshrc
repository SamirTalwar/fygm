if [[ $(uname) == 'Darwin' ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

if [[ -s ${ZDOTDIR:-$HOME}/.zprezto/init.zsh ]]; then
  source ${ZDOTDIR:-$HOME}/.zprezto/init.zsh
fi

RPROMPT="$RPROMPT %{%F{yellow}%}[%D{%H:%M}]%{%f%}"

setopt CLOBBER

export KEYTIMEOUT=1
bindkey -v
bindkey '^R' history-incremental-search-backward

[[ -e ~/.zshrc.local ]] && source ~/.zshrc.local
