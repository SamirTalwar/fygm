if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
fi

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

if (( $+commands[boot2docker] )) && [[ $(boot2docker status) == 'running' ]]; then
    export DOCKER_HOST=tcp://$(boot2docker ip):2376
    export DOCKER_CERT_PATH=/Users/samir/.boot2docker/certs/boot2docker-vm
    export DOCKER_TLS_VERIFY=1
fi

if [[ -e ~/.zshenv.local ]]; then
    source ~/.zshenv.local
fi
