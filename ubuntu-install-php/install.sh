#!/bin/bash

# Step 1: Select PHP VERSION
echo -e "\033[33m select php version: \033[0m"
echo '1：Install php version 5.6';
echo '2：Install php version 7.0';
echo '3：Install php version 7.1';
echo '4：Install php version 7.2';
echo '';
read -p 'Enter your choice (1, 2, 3, 4)：' INPUT_PHPVERSION;

case "${INPUT_PHPVERSION}" in
    1)
        PHPVERSION=5.6
        ;;
    2)
        PHPVERSION=7.0
        ;;
    3)
        PHPVERSION=7.1
        ;;
    4)
        PHPVERSION=7.2
        ;;
    *)
        echo -e "\033[31m Wrong Selected! \033[0m";
        exit 1;
        ;;
esac

# Step 2: Use Alibaba Mirror
release_info_file=/etc/os-release;
test -f $release_info_file;

if [ $? != '0' ]; then
    echo -e "\033[31m Sorry, This shell only can be used in Ubuntu 16.04/18.04 ! \033[0m";
    return 1;
fi
source $release_info_file;
if [ $NAME != 'Ubuntu' ]; then
    echo -e "\033[31m Sorry, This shell only can be used in Ubuntu 16.04/18.04 ! \033[0m";
    return 1;
fi

source_file='/etc/apt/sources.list';
cp "${source_file}" /etc/apt/sources.list.bak

if [[ $(cat "${source_file}" | grep 'aliyun.com') == '' ]]; then
    echo -e "\033[33m apt source use aliyun mirror...... \033[0m";

    # use aliyun-mirror
    case $VERSION_ID in
    18.04)
        cat>"${source_file}"<<EOF
# aliyun mirror
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF
        ;;
    16.04)
        cat>"${source_file}"<<EOF
# deb cdrom:[Ubuntu 16.04 LTS _Xenial Xerus_ - Release amd64 (20160420.1)]/ xenial main restricted
deb-src http://archive.ubuntu.com/ubuntu xenial main restricted #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse #Added by software-properties
deb http://archive.canonical.com/ubuntu xenial partner
deb-src http://archive.canonical.com/ubuntu xenial partner
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-security multiverse
EOF
        ;;
    esac

fi

# specify php version
PHP_VERSION=${PHPVERSION:-'7.2'};

# Step 3: add php repository
if [[ $(ls '/etc/apt/sources.list.d' | grep 'ondrej') == '' ]];then
    echo -e "\033[33m adding php repository ... \033[0m"

    apt install -y software-properties-common apt-transport-https lsb-release ca-certificates
    add-apt-repository -y ppa:ondrej/php
    apt update
fi

# Step 4: install git php mysql nginx redis
apt install -y git \
curl \
unzip \
nginx \
mysql-server \
redis-server \
"php${PHP_VERSION}" \
"php${PHP_VERSION}-bcmath" \
"php${PHP_VERSION}-bz2" \
"php${PHP_VERSION}-cli" \
"php${PHP_VERSION}-curl" \
"php${PHP_VERSION}-dev" \
"php${PHP_VERSION}-fpm" \
"php${PHP_VERSION}-gd" \
"php${PHP_VERSION}-imap" \
"php${PHP_VERSION}-json" \
"php${PHP_VERSION}-mbstring" \
"php${PHP_VERSION}-mysql" \
"php${PHP_VERSION}-odbc" \
"php${PHP_VERSION}-pgsql" \
"php${PHP_VERSION}-soap" \
"php${PHP_VERSION}-sqlite3" \
"php${PHP_VERSION}-tidy" \
"php${PHP_VERSION}-xml" \
"php${PHP_VERSION}-zip" \
composer \
libnghttp2-dev

if [ $? != '0' ]; then
    exit 1;
fi

# Step 5: install php-swoole

SWOOLE_VERSION=4.2.9;

rm -rf swoole*
wget -O swoole.zip "https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz"

if [ $? != '0' ]; then
    exit 1;
fi

tar -zxvf swoole.zip

cd "swoole-src-${SWOOLE_VERSION}"

"phpize${PHP_VERSION}"

./configure --enable-openssl --enable-http2 --enable-mysqlnd

if [[ $(echo `uname -a` | grep "Microsoft") != "" && -d "/mnt/c" ]]
then
  sed -i 's/#define HAVE_SIGNALFD 1/\/\/#define HAVE_SIGNALFD 1/g' config.h
fi
if [ $? != '0' ]; then
    exit 1;
fi

make clean && make -j && sudo make install

rm -rf "/etc/php/${PHP_VERSION}/mods-available/swoole.ini"
echo "extension=swoole.so" >> "/etc/php/${PHP_VERSION}/mods-available/swoole.ini"

ln -s "/etc/php/${PHP_VERSION}/mods-available/swoole.ini" "/etc/php/${PHP_VERSION}/cli/conf.d/swoole.ini"

exit 0
