#!/bin/bash

if [ -n "$1" ]; then
    T_PHP_VERSION=$1;
else
    T_PHP_VERSION='7.2';
fi

source /etc/os-release

source_file='/etc/apt/sources.list';

cp "${source_file}" /etc/apt/sources.list.bak

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
*)
    echo 'your system is not ubuntu(16.04 or 18.04)';
    exit 1
    ;;
esac

apt update

# add php repository
# apt install -y software-properties-common apt-transport-https lsb-release ca-certificates
# add-apt-repository -y ppa:ondrej/php
# apt update

# install git php mysql nginx redis
apt install -y git unzip nginx mysql-server redis php php-bcmath php-bz2 php-cli php-curl php-dev php-fpm php-gd php-imap \
php-json php-mbstring php-mysql php-odbc php-pgsql php-soap php-sqlite3 \
php-tidy php-xml php-zip libnghttp2-dev

# install php-swoole
rm -rf hiredis
git clone https://github.com/redis/hiredis.git
cd hiredis && make -j && make install && ldconfig

cd ..

rm -rf swoole*
wget -O swoole.zip "https://github.com/swoole/swoole-src/archive/v4.0.3.tar.gz"
tar -zxvf swoole.zip

cd swoole-src-4.0.3 && phpize && ./configure --enable-openssl --enable-http2 --enable-async-redis --enable-mysqlnd

if [[ $(echo `uname -a` | grep "Microsoft") != "" && -d "/mnt/c" ]]
then
  sed -i 's/#define HAVE_SIGNALFD 1/\/\/#define HAVE_SIGNALFD 1/g' config.h
fi
make clean && make && sudo make install

rm -rf /etc/php/7.2/mods-available/swoole.ini

echo "extension=swoole.so" >> /etc/php/7.2/mods-available/swoole.ini

ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/cli/conf.d/swoole.ini

exit 0
