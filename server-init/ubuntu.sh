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
    echo -e "\e[1;31m [ Error ] NOT UBUNTU!!\e[0m";
    exit 1;
if

# 1. 更换源为国内的地址
if [[ $(cat /etc/apt/sources.list | grep "ubuntu.com") != '' ]]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.original;
    sudo sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list;
    sudo sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list;
fi
sudo apt update

# 2. 安装软件
sudo apt install -y git vim unzip zsh nginx mysql-server mysql-client redis-server libnghttp2-dev;

# 3. 安装php

sudo apt install -y software-properties-common;
sudo sudo add-apt-repository ppa:ondrej/php -y;
sudo apt update;

PHP_VERSION=7.4
sudo apt install -y  \
    php${PHP_VERSION} php${PHP_VERSION}-cli php${PHP_VERSION}-fpm php${PHP_VERSION}-dev  \
    php${PHP_VERSION}-bcmath php${PHP_VERSION}-bz2 php${PHP_VERSION}-curl php${PHP_VERSION}-gd \
    php${PHP_VERSION}-json php${PHP_VERSION}-imap php${PHP_VERSION}-mbstring php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-odbc php${PHP_VERSION}-soap php${PHP_VERSION}-pgsql php${PHP_VERSION}-sqlite3 \
    php${PHP_VERSION}-xml php${PHP_VERSION}-tidy php${PHP_VERSION}-zip php${PHP_VERSION}-redis;


# 4. 安装Node
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

# 5. 安装oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone git://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# 6. 配置VIM
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

curl -o ~/namet.vim -L https://raw.githubusercontent.com/namet117/vimrc/master/namet.vim

echo "source ~/namet.vim" > ~/.vimrc

vim +PlugInstall
