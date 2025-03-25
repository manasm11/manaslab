#!/bin/bash

main() {
        if $is_debian_based ; then
                install_programs_deb && \
                download_nvim_conf_deb && \
                install_vim_plug
        fi
}

is_debian_based=$([ -f /etc/debian_version ])

install_programs_deb() {
        sudo apt-get update && \
        sudo apt-get -y install wget neovim curl
}

download_nvim_conf_deb() {
        mkdir -p "$HOME/.config/nvim/" && \
        wget -O "$HOME/.config/nvim/init.vim" \
                        "https://raw.githubusercontent.com/manasm11/neovim-config/refs/heads/main/init.vim"
}

install_vim_plug() {
        curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

main
