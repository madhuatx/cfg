#!/bin/bash

ln -sf ~/develop/cfg/.bashrc ~/.bashrc
ln -sf ~/develop/cfg/.bash_profile ~/.bash_profile
ln -sf ~/develop/cfg/.emacs.d ~/.emacs.d
ln -sf ~/develop/cfg/.ssh/config ~/.ssh/config
ln -sf ~/develop/cfg/.gitconfig ~/.gitconfig

mkdir -p ~/.matplotlib
mkdir -p ~/.config/matplotlib
ln -sf ~/develop/cfg/matplotlibrc ~/.matplotlib/matplotlibrc
ln -sf ~/develop/cfg/matplotlibrc ~/.config/matplotlib/matplotlibrc
mkdir -p ~/.jupyter
ln -s ~/develop/cfg/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py

cd ~/.ssh && chmod 644 config
cd ~/develop/cfg/

sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --help

mkdir -p ~/.config
mkdir -p ~/.starship/bin
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y -b ~/.starship/bin
ln -sf ~/develop/cfg/starship/starship.toml ~/.config/starship.toml 

cd ~
