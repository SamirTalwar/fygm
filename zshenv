if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
fi

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

export DOCKER_HOST="tcp://192.168.59.103:2376"
export DOCKER_CERT_PATH="$HOME/.boot2docker/certs/boot2docker-vm"
export DOCKER_TLS_VERIFY=1

export GRADLE_OPTS="$GRADLE_OPTS -Dorg.gradle.daemon=true"

if [[ -e ~/.zshenv.local ]]; then
    source ~/.zshenv.local
fi
