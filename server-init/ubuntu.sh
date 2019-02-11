#!/bin/bash

apt update

apt upgrade -y

apt install -y vim curl

# VIM config
curl -o /root/namet.vim -L https://raw.githubusercontent.com/namet117/vimrc/master/namet.vim
echo "source /root/namet.vim" > /root/.vimrc
