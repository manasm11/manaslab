#!/bin/bash

main() {
        if $is_debian_based ; then
                download_bashrc && \
                install_programs_deb && \
                setup_git && \
                download_nvim_conf_deb && \
                install_vim_plug && \
                echo "Run ':PlugInstall' in nvim to enable nvim plugins."
        fi
}

is_debian_based=$([ -f /etc/debian_version ])

download_bashrc() {
        wget -O "$HOME/.bashrc" \
                        "https://raw.githubusercontent.com/manasm11/manaslab/refs/heads/main/.bashrc"
}

install_programs_deb() {
        sudo apt-get update && \
        sudo apt-get -y install wget neovim curl git
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

main
