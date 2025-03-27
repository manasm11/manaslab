#!/bin/bash

main() {
        if $is_debian_based ; then
                download_bashrc && \
                download_spellcheck_dictionary && \
                download_nvim_conf_deb && \
                install_programs_deb && \
                install_nvim && \
                install_vim_plug && \
                setup_spellcheck && \
                setup_git && \
                echo "Run ':PlugInstall' in nvim to enable nvim plugins."
        fi
}

is_debian_based=$([ -f /etc/debian_version ])

download_spellcheck_dictionary() {
        mkdir -p "$HOME/.config/nvim/spell/" && \
        wget -O "$HOME/.config/nvim/spell/en.utf-8.add" \
                        "https://raw.githubusercontent.com/manasm11/manaslab/refs/heads/main/en.utf-8.add"
}

download_bashrc() {
        wget -O "$HOME/.bashrc" \
                        "https://raw.githubusercontent.com/manasm11/manaslab/refs/heads/main/.bashrc"
}

install_nvim() {
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
        sudo rm -rf /opt/nvim && \
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
        rm nvim-linux-x86_64.tar.gz
}

install_programs_deb() {
        sudo apt-get update && sudo apt-get upgrade -y && \
        sudo apt-get -y install wget curl git
}

download_nvim_conf_deb() {
        mkdir -p "$HOME/.config/nvim/" && \
        wget -O "$HOME/.config/nvim/init.vim" \
                        "https://raw.githubusercontent.com/manasm11/neovim-config/refs/heads/main/init.vim"
}

install_vim_plug() {
        sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

setup_git() {
        git config --global user.email "manas.m22@gmail.com" && \
        git config --global user.name "Manas Mishra"
}

setup_spellcheck() {
        nvim -u NONE -es -c "mkspell! $HOME/.config/nvim/spell/en.utf-8.add"
}

main
