#!/bin/bash

apt update

apt upgrade -y

apt install -y git vim curl


# Install Nodejs
curl -o /tmp/node.tar.xz -L https://nodejs.org/dist/v11.9.0/node-v11.9.0-linux-x64.tar.xz

xz -d /tmp/node.tar.xz

tar -xvf /tmp/node.tar

mv /tmp/node /opt/node

ln -s /opt/node/bin/node /usr/bin/node
ln -s /opt/node/bin/npm /usr/bin/npm
ln -s /opt/node/bin/npx /usr/bin/npx

# VIM config
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

curl -o ~/namet.vim -L https://raw.githubusercontent.com/namet117/vimrc/master/namet.vim

echo "source ~/namet.vim" > ~/.vimrc

vim +PlugInstall
