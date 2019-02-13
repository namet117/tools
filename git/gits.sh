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
    echo -e "简单版的GIT管理工具
当前版本 : ${CURRENT_VERSION}

可用命令有:
    st          查看当前工作空间状态（git status）.
    log         查看版本树状记录图.
    files       查看每个版本提交的文件名.
    up          从origin更新当前分支（使用rebase）.
    start       开始一个新的功能分支.
    finish      结束一个功能分支的开发并合并到master.
    publish     推送当前分支到origin上.
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
    git status > /dev/null 2>&1;
    if [[ $? -gt 0 ]]; then
        e '当前目录非GIT目录!';
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

# 获取当前分支名
function getCurrentBranch() {
    branch=`git symbolic-ref --short -q HEAD`;
    echo $branch;
    return 0;
}

# 更新当前工作空间
function updateWorkSpace() {
    git pull --rebase;
}

# 检查某个分支是否存在
function checkBranchExists() {
    if [[ $(git branch | grep $1) == '' ]]; then
        echo 'n';
    else
        echo 'y';
    fi

    return 0;
}

# 补全功能分支名
function fixBranch() {
    if [[ $(echo ${1} | grep 'feature/') == '' ]]; then
        branch_name="feature/${1}";
    else
        branch_name="${1}";
    fi
    echo $branch_name;
    return 0;
}

# 开启一个新分支
function newBranch() {
    # 0. 得到目标分支名
    if [[ ${1} == '' ]]; then
        e '请指定功能分支名称（可省略feature前缀）';
        exit 4;
    fi
    branch_name=`fixBranch $1`;
    # 1. 如果分支已经存在，则报出提示并切换到该分支
    exists=`checkBranchExists $branch_name`;
    if [[ $exists == 'y' ]]; then
        e "分支${branch_name}已存在";
        git checkout $branch_name;
        exit 5;
    fi

    # 2. 如果当前不在master分支则切换到master分支
    br=`getCurrentBranch`;
    if [[ $br != 'master' ]]; then
        r=`git checkout master`;
    fi

    # 3. 先测试本工作空间是否有未提交的文件
    #hasUncommitFiles;
    
    # 4. 创建分支并切换到新分支
    git checkout -b ${branch_name};
}

# 结束一个功能分支的开发任务
function finishWork() {
    target_branch=`getCurrentBranch`;
    if [[ $target_branch == 'master' && ${1} == '' ]]; then
        if [[ ${1} == '' ]]; then
            e '请输入分支名!';
            exit 6;
        fi
    else
        r=`git checkout master`;
    fi
    
    git merge $target_branch;
}

# 发布本地分支到远程
function publishToOrigin() {
    current_branch=`getCurrentBranch`;
    res=git push -u origin $current_branch;
    if [[ $? -gt 0 ]]; then
        if [[ $(echo $res | grep '') ]]; then
            updateWorkSpace;
            git push -u origin $current_branch;
        fi
    fi
}

# 展示Log
function showLog() {
    git log --no-merges --color --stat --graph --date=format:'%Y-%m-%d %H:%M:%S' --pretty=format:'%Cred%h%Creset -%C(yellow)%d%C(magenta) %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit;
}

# 展示变动文件
function showFiles() {
    git log --no-merges --color --name-only --graph --date=format:'%Y-%m-%d %H:%M:%S' --pretty=format:'%Cred%h%Creset -%C(yellow)%d%C(magenta) %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit;
}

##################################################
################### 逻辑开始 #####################
##################################################

# 1. 如果没有任何参数或者第一个参数为help，则输出help()并退出
if [[ $# == 0 || $1 == 'help' ]]; then
    _help;
    exit 0;
fi

# 2. 检查是否可执行当前操作
ACTION="$1";

if [[ $( echo ',st,files,log,up,start,finish,publish,' | grep ",${ACTION},") == '' ]]; then
    e "gits ${1} 命令不存在. 详见 'gits help'.\n";
    _help;
    exit 1;
fi

# 3. 检查当前工作目录是否有git控制
isUnderGitControll;

# 4. 获取当前想向执行的操作
case "${ACTION}" in
    'log')
        showLog;
        ;;
    'st')
        git status;
        ;;
    'files')
        showFiles;
        ;;
    'up')
        updateWorkSpace;
        ;;
    'start')
        newBranch $2;
        ;;
    'finish')
        finishWork;
        ;;
    'publish')
        publishToOrigin;
        ;;
esac
