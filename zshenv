if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
fi

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

if (( $+commands[docker-machine] )) &&
  [[ $($(which gtimeout || which timeout) 3 docker-machine status docker 2>/dev/null) == 'Running' ]]; then
    eval "$(docker-machine env docker)"
fi

export GRADLE_OPTS="$GRADLE_OPTS -Dorg.gradle.daemon=true"

if [[ -e ~/.zshenv.local ]]; then
    source ~/.zshenv.local
fi
