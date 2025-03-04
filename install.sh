#!/bin/bash

install_path=${HOME}/FoundryServer

clone_repo() {
    sudo git clone -b release --single-branch --depth=1 https://github.com/CloudFlavorKettle/FoundryVTT-docker-compose.git
}

install_docker() {
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    sudo usermod -aG docker $USER

    sudo curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

open_ports() {
    sudo iptables -I INPUT 5 -i ens3 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
    sudo iptables -I INPUT 5 -i ens3 -p tcp --dport 8080 -m state --state NEW,ESTABLISHED -j ACCEPT
    sudo iptables -I INPUT 5 -i ens3 -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
}

make_alias() {
    if grep -q "# Foundry aliases" "${HOME}/.bashrc"; then
        return
    fi

    sudo echo '' >> $HOME/.bashrc
    sudo echo "# Foundry aliases" >> $HOME/.bashrc
    sudo echo "if [ -f ${install_path}/.bash_aliases ]; then" >> $HOME/.bashrc
    sudo echo "    source ${install_path}/.bash_aliases" >> $HOME/.bashrc
    sudo echo "fi" >> $HOME/.bashrc
    bash
}

main() {
    clone_repo
    install_docker
    open_ports || :
    make_alias
}

main
