if [[ $(uname) == 'Darwin' ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

[[ -e ~/.zshrc.local ]] && source ~/.zshrc.local

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

RPROMPT="$RPROMPT %{%F{yellow}%}[%D{%H:%M}]%{%f%}"

setopt CLOBBER

bindkey -v
export KEYTIMEOUT=1
