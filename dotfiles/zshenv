path=(
    ~/bin/unix
    ~/.rvm/bin
    ~/.cabal/bin
    ./node_modules/.bin
    $path
)

if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
    path=(
        ~/bin/mac
        $path
    )
fi

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

export GRADLE_OPTS="$GRADLE_OPTS -Dorg.gradle.daemon=true"

if [[ -e ~/.zshenv.local ]]; then
    source ~/.zshenv.local
fi
