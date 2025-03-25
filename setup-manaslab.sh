#!/bin/bash

is_debian_based=$([ -f /etc/debian_version ])

install_programs_deb() {
        sudo apt-get update && \
        sudo apt-get -y install wget neovim
}

download_nvim_conf_deb() {
        mkdir -p "$HOME/.config/nvim/"
        wget -O "$HOME/.config/nvim/init.vim" "https://raw.githubusercontent.com/manasm11/neovim-config/refs/heads/main/init.vim"
}

if $is_debian_based ; then
        install_programs_deb
        download_nvim_conf_deb
fi
