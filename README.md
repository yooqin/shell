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

        git commit -am "fix bug"; git push origin master

3. ;; 双分号(double semicolon)case语句结束符
        
        case "$variable" in
            abc)  echo "\$variable = abc" ;;
            xyz)  echo "\$variable = xyz" ;;
        esac

4. .点号(dot)

- 作为文件名的一部分存在，如放在文件名前表示文件为隐藏文件，正常状态不显示改文件或目录
- .表示当前目录
- ..表示上级目录
- 点好还被用在正则表达式中

    touch .hidden-file #创建一个隐藏文件
    cd . #进入当前目录
    cd ..   #进入上一级目录
    cp /var/log/nginx.log . //nginx.log拷贝到当前目录

5. "双引号(double quote):shell脚本中用来声明String类型字符

6. '单引号(single quote): 声明String，String中不包含转义字符

7. ,逗号(comma operator)

- 将一系列运算符连到一块，但只返回最后一组
- 结合{}表示或连接字符串

        let "t2 = ((a=9, 15/3))"
        # Set "a = 9" and "t2 = 15 / 3"
        echo $t2
        echo $a
        # t2 = 5,   a=9

        #在/bin 和 /usr/bin中查找所有包含 calc的 文件
        for file in /{,usr/}bin/*che
        do
                if [ -x "$file" ]
                then
                  echo $file
                fi
        done








### 变量和参数
### 引用
### 退出和退出状态
### Tests
### 操作及相关操作



# 代码对照
1. clean_up.sh 清理一个log日志文件
2. note.sh 显示命令行提示
3. more.sh 关于一个more的执行
