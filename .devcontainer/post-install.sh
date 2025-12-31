#!/bin/bash
set -x

install_npm() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    # in lieu of restarting the shell
    \. "$HOME/.nvm/nvm.sh"
    nvm install 24

    node -v
    npm -v
}

install_cline() {
    install_npm
    apt update -y
    apt install -y python3 make gcc g++
    npm install -g cline

    cline version
}

install_helm() {
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash

    helm version
}

docker --version
install_helm
install_cline
