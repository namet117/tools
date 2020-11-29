#!/bin/bash


# 定义函数
showError() {
    echo -e "\e[1;31m [ Error ] $1\e[0m";
    exit 1;
}

showSuccess() {
    echo -e "\e[1;32m$1\e[0m";
}

showInfo() {
    echo -e "$1";
}


# 0. 判断是否为Ubuntu
if [[ $(cat /etc/os-release | grep "NAME=\"Ubuntu\"") == '' ]]; then

if

# 1. 更换源为国内的地址
if [[ $(cat /etc/apt/sources.list | grep "ubuntu.com") != '' ]]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.original;
    sudo sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list;
    sudo sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list;
fi

# 2. 更新
sudo apt update


sudo apt install -y git vim unzip \
        nginx mysql-server mysql-client redis-server \
        php php-cli php-fpm php-dev libnghttp2-dev \
        php-bcmath php-bz2 php-curl php-gd php-json php-imap php-mbstring \
        php-odbc php-soap php-pgsql php-sqlite3 php-xml php-tidy php-zip;


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
