# shell库里放了什么?

1. shell学习过程中的学习脚本
2. 工作中积累的shell脚本
3. 收藏的常用shell脚本

# study部分

## shell文件介绍

每个shell文件都第一行都是命令解释器的声明，#!声明是一个可执行的脚本

    ＃！/ bin / sh 
    ＃！/ bin / bash 
    ＃！/ usr / bin / perl 
    ＃！/ usr / bin / tcl 
    ＃！/ bin / sed -f 
    ＃！/ bin / awk -f

## 基础知识

### 基础
### 特殊字符

1. #注释符(comments):shell只能注释一行

            echo "The # here does not begin a comment."
            echo 'The # here does not begin a comment.'
            echo The \# here does not begin a comment.
            echo The # here begins a comment.
            echo ${PATH#*:}       # Parameter substitution, not a comment. 参数替换
            echo $(( 2#101011 ))  # Base conversion, not a comment.进制转换
            以上分别输出:
            The # here does note begin a comment.
            The # here does note begin a comment.
            The # here does note begin a comment.
            The #

2. ;命令分割符(command separator):在同一行分割多个命令 
    ls;ll


### 变量和参数
### 引用
### 退出和退出状态
### Tests
### 操作及相关操作



# 代码对照
1. clean_up.sh 清理一个log日志文件
2. note.sh 显示命令行提示
3. more.sh 关于一个more的执行
