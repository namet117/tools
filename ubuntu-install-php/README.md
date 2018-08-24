## 安装php开发环境脚本

### 系统要求
`Ubuntu-16.04`或`Ubuntu-18.04`

### 使用方法
 ```shell
 curl -O http://tool.namet.xyz/install.sh && sudo ./install.sh
 ```

### 安装的软件
* nginx
* MySQL
* PHP
* Redis

### 安装的PHP扩展
* bcmath
* bz2
* curl
* gd
* imap
* json
* mbstring
* mysql
* odbc
* pgsql
* sqlite3
* tidy
* xml
* zip
* swoole(4.0.3版本)

### 安装Swoole时的编译参数
* enable-openssl
* enable-http2
* enable-mysqlnd
* enable-async-redis

### ！！！
* 如果使用的是Win10子系统Linux，即WSL，则会根据[Swoole文档](https://wiki.swoole.com/wiki/page/7.html#entry_h2_4)做相应修改
* swoole扩展仅添加到了php-cli中，
