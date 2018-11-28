## 安装php开发环境脚本

### 系统要求
`Ubuntu-16.04`或`Ubuntu-18.04`

### 使用方法
 如果系统中尚未安装`wget`工具，请先安装
 `sudo apt install -y wget`
 确认系统中已有`wget`之后，执行命令开始安装
 ```shell
 wget -O install.sh https://github.com/namet117/tools/raw/master/ubuntu-install-php/install.sh && sudo bash install.sh
 ```

### 安装的软件
* nginx
* MySQL(5.7)
* PHP (可选版本有: 5.6, 7.0, 7.1, 7.2)
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
* swoole(4.2.9版本)

### 安装Swoole时的编译参数
* enable-openssl
* enable-http2
* enable-mysqlnd

### ！！！
* 如果使用的是Win10子系统Linux，即WSL，已根据[Swoole文档](https://wiki.swoole.com/wiki/page/7.html#entry_h2_4)做了相应修改
* swoole扩展仅添加到了php-cli中，
