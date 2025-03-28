#!/bin/bash

main() {
        if $is_debian_based ; then
                download_bashrc && \
                download_spellcheck_dictionary && \
                download_nvim_conf_deb && \
                download_snippets && \
                install_programs_deb && \
                install_nvim && \
                install_vim_plug && \
                setup_spellcheck && \
                setup_git && \
                echo "Run ':PlugInstall' in nvim to enable nvim plugins."
        fi
}

is_debian_based=$([ -f /etc/debian_version ])

download_bashrc() {
        wget -O "$HOME/.bashrc" \
                        "https://raw.githubusercontent.com/manasm11/manaslab/refs/heads/main/.bashrc"
}

download_spellcheck_dictionary() {
        mkdir -p "$HOME/.config/nvim/spell/" && \
        wget -O "$HOME/.config/nvim/spell/en.utf-8.add" \
                        "https://raw.githubusercontent.com/manasm11/manaslab/refs/heads/main/en.utf-8.add"
}

download_nvim_conf_deb() {
        mkdir -p "$HOME/.config/nvim/" && \
        wget -O "$HOME/.config/nvim/init.vim" \
                        "https://raw.githubusercontent.com/manasm11/neovim-config/refs/heads/main/init.vim"
}

download_snippets() {
        mkdir -p "$HOME/.config/nvim/snippets/" && \
        wget -O "$HOME/.config/nvim/snippets/go.snippets" \
                "https://raw.githubusercontent.com/manasm11/manaslab/refs/heads/main/go.snippets"
}

install_programs_deb() {
        sudo apt-get update && sudo apt-get upgrade -y && \
        sudo apt-get -y install wget curl git
}

install_nvim() {
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
        sudo rm -rf /opt/nvim && \
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
        export PATH="$PATH:/opt/nvim-linux-x86_64/bin" && \
        rm nvim-linux-x86_64.tar.gz
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
