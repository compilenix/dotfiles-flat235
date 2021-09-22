#!/bin/bash
# vim: sw=4 et

condition_for_install=1
if [[ \
    -f $(which git 2>/dev/null) && \
    -f $(which zsh 2>/dev/null) && \
    -f $(which python3 2>/dev/null) && \
    -f $(which pip 2>/dev/null)
    ]]; then

    condition_for_install=0
fi

if [[ ${condition_for_install} -eq 0 ]]; then
    pushd "$HOME" >/dev/null
        mkdir -pv "$HOME/bin"
        echo "git clone https://git.compilenix.org/CompileNix/dotfiles.git \"$HOME/dotfiles\""
        git clone https://git.compilenix.org/CompileNix/dotfiles.git "$HOME/dotfiles"
        echo "install required python libs"
        pip3 install --user rich pyyaml neovim
        pushd "$HOME/dotfiles" >/dev/null
            ./update.sh
        popd >/dev/null
        if [[ $EUID -eq 0 ]]; then
            chsh -s /bin/zsh
        else
            echo "you are not root, so you are not allowed to change your own shell to zsh"
            echo 'retry with: sudo chsh -s /bin/zsh "$USERNAME"'
        fi
    popd >/dev/null
else
    echo "one or more of the following dependencies are not installed: git, zsh, python, pip"
fi

