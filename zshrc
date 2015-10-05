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
bindkey '^R' history-incremental-search-backward

if (( $+commands[brew] )) && [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]]; then
    source $(brew --prefix)/etc/profile.d/autojump.sh
fi

if (( $+commands[thefuck] )); then
    eval "$(thefuck --alias)"
fi

if [[ -e ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi
