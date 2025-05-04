#!/bin/bash

GO_VERSION="1.24.1"
SYSTEM=deb
main() {
        get_system_type && \
        download_bashrc && \
        install_programs_deb && \
        download_nvim_conf_deb && \
        install_nvim && \
        install_go && \
        setup_git && \
}

get_system_type() {
        options=("debian/ubuntu" "termux" "exit") # Define options in an array
        PS3="Which system are you in?: "
        select opt in "${options[@]}"; do
          case "$opt" in
            "debian/ubuntu")
                SYSTEM=deb
              ;;
            "termux")
                SYSTEM=term
              ;;
            "exit")
              echo "Exiting..."
              break
              ;;
            "")  # If user just presses enter
              echo "Invalid selection. Please choose a number from the menu."
              ;;
            *)
              echo "Invalid selection. Please choose a number from the menu."
              ;;
          esac
        done
}

is_debian_based=$([ -f /etc/debian_version ])

download_bashrc() {
        wget -O "$HOME/.bashrc" \
                        "https://raw.githubusercontent.com/manasm11/manaslab/refs/heads/main/.bashrc"
}

download_nvim_conf_deb() {
        mkdir -p "$HOME/.config/nvim/" && \
        wget -O "$HOME/.config/nvim/init.vim" \
                        "https://raw.githubusercontent.com/manasm11/neovim-config/refs/heads/main/init.vim"
}

install_programs_deb() {
        sudo apt-get update && sudo apt-get upgrade -y && \
        sudo apt-get -y install wget curl git
}

install_nvim() {
        sudo apt purge neovim
        sudo snap remove nvim
        sudo rm /usr/bin/nvim
        sudo rm -rf /opt/nvim
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
        export PATH="$PATH:/opt/nvim-linux-x86_64/bin" && \
        rm nvim-linux-x86_64.tar.gz
}

install_go() {
        sudo apt purge golang
        curl -LO https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
        rm -rf /usr/local/go && tar -C $HOME -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
        mv $HOME/go $HOME/.go && \
        export PATH="$HOME/.go/bin:$PATH" && \
        export GOPATH="$HOME/.go" && \
        rm go${GO_VERSION}.linux-amd64.tar.gz && \
        go install golang.org/x/tools/gopls@latest
}

install_vim_plug() {
        sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

setup_spellcheck() {
        nvim -u NONE -es -c "mkspell! $HOME/.config/nvim/spell/en.utf-8.add"
}

setup_git() {
        git config --global user.email "manas.m22@gmail.com" && \
        git config --global user.name "Manas Mishra"
        git config --global pull.rebase true
}

main
