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
        php-bcmath php-bz2 php-curl php-gd php-json php-imap php-mbstring php-mysql \
        php-odbc php-soap php-pgsql php-sqlite3 php-xml php-tidy php-zip;


# Install Nodejs

NODE_VERSION=15.3.0;
# if [[ $(node -v) != "v${NODE_VERSION}" ]]; then
FILE_NAME="node-v${NODE_VERSION}-linux-x64";
DIST_DIR="/usr/share/node";
DIST_PATH=${DIST_DIR}/${NODE_VERSION};
cd /tmp;
curl -OL https://repo.huaweicloud.com/nodejs/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz;
xz -d ${FILE_NAME}.tar.xz;
tar -xvf ${FILE_NAME}.tar;
sudo mkdir -p /usr/share/node;
if [[ $(ls $DIST_DIR | grep $NODE_VERSION) != '' ]]; then
    sudo rm -rf $DIST_PATH;
fi
sudo mv $FILE_NAME $DIST_PATH;
sudo rm /etc/alternatives/node /etc/alternatives/npm /etc/alternatives/npx /usr/bin/node /usr/bin/npm /usr/bin/npx;
sudo ln -s $DIST_PATH/bin/node /etc/alternatives/node;
sudo ln -s $DIST_PATH/bin/npx /etc/alternatives/npx;
sudo ln -s $DIST_PATH/bin/npm /etc/alternatives/npm;
sudo ln -s /etc/alternatives/node /usr/bin/node;
sudo ln -s /etc/alternatives/npx /usr/bin/npx;
sudo ln -s /etc/alternatives/npm /usr/bin/npm;
# fi

# VIM config
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

curl -o ~/namet.vim -L https://raw.githubusercontent.com/namet117/vimrc/master/namet.vim

echo "source ~/namet.vim" > ~/.vimrc

vim +PlugInstall
