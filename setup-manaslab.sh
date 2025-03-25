#!/bin/bash

is_debian_based=$([ -f /etc/debian_version ])

install_programs_deb() {
        sudo apt install neovim
}

download_nvim_conf_deb() {
        mkdir -p "$HOME/.config/nvim/"
        wget -P "$HOME/.config/nvim/" "https://raw.githubusercontent.com/manasm11/neovim-config/refs/heads/main/init.vim"
}

if $is_debian_based ; then
        $([ -f step1 ]) || ( install_programs_deb && touch step1 )
        download_nvim_conf_deb
fi
