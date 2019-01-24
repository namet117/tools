#!/bin/bash

# 当前版本号
CURRENT_VERSION='0.1-dev'
# 上个命令输出内容
LAST_COMMAND_OUTPUT=''

# 输出绿色内容
function s() {
    echo -e "\033[32m${1}\033[0m";
}

# 输出红色内容
function e() {
    echo -e "\033[31m${1}\033[0m";
}

# 输出帮助信息
function _help() {
    echo -e "A simple git project management tool
current version is : ${CURRENT_VERSION}

Available subcommands are:
   up        Update your current branch from origin.
   start     Create a feature branche from master.
   finish    Finish your feature branche, merge commits into master.
   publish   Push your current branche to remote origin.
";
}

# 检查是否有错误
function _checkError() {
    if [[ $? -gt 0 ]]; then
        echo -e "${LAST_COMMAND_OUTPUT}";
    fi
}

# 检查当前目录是否在Git版本控制下
function isUnderGitControll() {
    git status > /dev/null 2&>1;
    if [[ $? -gt 0 ]]; then
       exit 2;
    fi
}

# 检查是否有未提交的修改
function hasUncommitFiles() {
    if [[ $(git status | grep 'working tree clean') == '' ]]; then
        e "检测到有未提交的修改";
        exit 5;
    fi
}

# 更新当前工作空间
function updateWorkSpace() {
    git pull
}

# 开启一个新分支
function newBranch() {
    # 1. 先测试本工作空间是否有未提交的文件
    hasUncommitFiles;
    # 2. 获取分支名称
    if [[ ${1} == '' ]]; then
        e '请指定功能分支名称（可省略feature前缀）';
        exit 4;
    fi
    if [[ $(echo ${1} | grep '') == '' ]]; then
        branch_name="feature/${1}";
    else
        branch_name="${1}";
    fi
    # 3. 创建分支
    git checkout -b ${branch_name} > /dev/null 2&>1
    if [[ $? -eq 0 ]]; then
        echo 1;
    fi

}

##################################################
################### 逻辑开始 ######################
##################################################

# 1. 如果没有任何参数或者第一个参数为help，则输出help()并退出
if [[ $# == 0 || $1 == 'help' ]]; then
    _help;
    exit 0;
fi

# 2. 检查是否可执行当前操作
ACTION="$1";

if [[ $( echo ',up,start,finish,publish,' | grep ",${ACTION},") == '' ]]; then
    e "gits ${1} is not a command. See 'gits help'.\n";
    _help;
    exit 1;
fi

# 3. 检查当前工作目录是否有git控制
isUnderGitControll;

# 4. 获取当前想向执行的操作
case "${ACTION}" in
    'up')
        updateWorkSpace;
        ;;
    'start')
        newBranch $2
        ;;
    'finish')
        PHPVERSION=7.1
        ;;
    'publish')
        PHPVERSION=7.2
        ;;
esac
