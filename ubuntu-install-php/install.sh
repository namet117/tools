#!/bin/bash

sourceUrl="http://repo.huaweicloud.com"

# 1. 检查是否已经变更过源地址了
if [[ $(cat /etc/apt/sources.list | grep "${sourceUrl}") == '' ]]; then 
    if [[ ls /etc/apt | grep 'sources.list.backup' ]]; then
        cp /etc/apt/sources.list /etc/apt/sources.list.backup;
    fi

    sed -i "s@http://.*archive.ubuntu.com@${sourceUrl}@g" /etc/apt/sources.list
    sed -i "s@http://.*security.ubuntu.com@${sourceUrl}@g" /etc/apt/sources.list
fi

# 2. 更新软件版本
apt update 

# 3. 安装lnmp
if [[ $(which php) == '' ]] || [[ $(which nginx) == '' ]] || [[ $(which mysql) == '' ]] || [[ $(which redis-cli) == '' ]]; then
    apt install -y git curl unzip \
        nginx mysql-server mysql-client redis-server \
        php php-cli php-fpm php-dev libnghttp2-dev \
        php-bcmath php-bz2 php-curl php-gd php-json php-imap php-mbstring \
        php-odbc php-soap php-pgsql php-sqlite3 php-xml php-tidy php-zip;
fi

# 4. 安装composer
if [[ $(which composer) == '' ]]; then 
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'c31c1e292ad7be5f49291169c0ac8f683499edddcfd4e42232982d0fd193004208a58ff6f353fde0012d35fdd72bc394') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
fi

# 5. 安装Swoole
# TODO
