#!/bin/bash

#检测rpm是否可以安装，结果输出到文件

SUCCESS=0
E_NOARGS=65

if [ -z "$1" ]
then
    echo "Usage:`basename $0` rpm-file"
    exit E_NOARGS
fi

{#语句块开始，语句块输出内容将重定向到文件
    echo 
    echo "描述"
    rpm -qpi $1 #查询描述
    echo
    echo "列表:"
    rpm -qpl $1
    echo 
    rpm -i --test $1 #是否可以安装
    
    if [ "$?" -eq $SUCCESS ]
    then
        echo "$1 can be installed"
    else 
        echo "$1 can not be installed"
    fi
    echo
} > "$1.test"

echo "结果放入$1.test"
exit 0
