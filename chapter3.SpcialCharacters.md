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

8. \反斜线(back slash):转义输出一些特殊符号

9. /斜线(forward slash):文件路径分割符，如/bin/bash;也做算术运算符 

10. `命令替换符(command substitution):包含一段可执行的命令，如a=`whoami`

11. :空命令符，不做任何操作，通常当做占位符使用
- 在/etc/passwd作为分隔符,$PATH中作为分隔符

12. !非(negate) 运算符非

13. *星号(asterisk):作为通配符使用，本身为目录下所有文件(echo *)，同时作为算术运算符

14. ?问号:三元运算符(( var0 = var1<98?9:21 )) 或 单个字符通配符

15. $美元符号

- 变量表示符号，放在变量前

        var1=5
        var2=2
        echo $var1     # 5
        echo $var2     # 2 

- 正则表达式中$表示行末尾

- ${}如字符串中输出参数做界定符限制, echo hello this is ${shell}shell script

- $'..' 输出转义字符，如 echo $'\n';换行 echo $'\041'; echo $'\a'

- $*, $@位置参数

- $? 状态持有变量，可以是上一条命令执行状态，方法执行状态或脚本执行状态,0正确执行

- $$ 进程id变量, 脚本中的进程id

16. ()括号

- 命令组，(a=hello; echo $a) 命令组中的变量不会覆盖全局，子进程执行变量互不干扰

- 数组初始化,Array=(element1 element2 element3)

17. {xxx,yyy,zzz,...}

        echo \"{These,words,are,quoted}\"   # " prefix and suffix
        # "These" "words" "are" "quoted"
        cat {file1,file2,file3} > combined_file
        # Concatenates the files file1, file2, and file3 into combined_file.
        cp file22.{txt,backup}
        # Copies "file22.txt" to "file22.backup"

18. {a..z} 表示a-z也可输出{0..9}等 

19. {}代码块，创建一个匿名块和函数的区别在于代码块的属性外部可见

- 文件内容重定向代码块

        #!/bin/bash
        #从文件中读取两行数据到代码块
        FILE=/var/log/system.log
        {
        read line1
        read line2
        } < $FILE
        echo "First line in $FILE is:";
        echo $line1
        echo "Second line in $FIEL is:"
        echo $line2
        exit 0

- 代码块内容重定向到文件

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
        
- 占位符文本,如 ls | xargs -t -i mv {} {}.bak 所有文件改为bak

20. []测试表达式,前后需要空格

- 条件表达式 if [ $name != $1 ]

- 数组元素,array[1]=hello;echo ${array[1]}

- 正则表达式的一部分字符范围 [a-z]


21. [[]] 更灵活的测试表达式

22. (()) 整数的扩展

23. >  &>  >&  >>  <  <>重定向 

- 重定向加数字(0:标准输入stdin 1:标准输出stdout 2:标准错误stderr)如ls a.txt b.txt 1>file.out 2>file.err,文件b.txt不存在，则file.out内容为a.txt file.err内容为not found b.txt;通常情况下默认为1>xx 1省略 

- >重定向文件， cat xx.log > a.log

- &>意思是把标准输出和标准错误输出都重定向到文件filename中,通常抑制输出是这样做 type unkonw_command &>/dev/null; echo $?

- >& &是描述符号1>&2 意思是把标准输出重定向到标准错误,2>&1 意思是把标准错误输出重定向到标准输出,命令格式 ls a.txt b.txt 1>file.out 2>&1 file.out内包含strout和strerr

- >> 重定向内容追加到文件末尾

- <> 打开重定向文件一遍读写

24. \<\>正则表达式界定符

25. |管道符，将前面的stdout转为stdin，一种进程间通信的方法

26. &后台作业，一个命令后加& 命令将在后台作业

27. -命令选型设置

28. ~当前工作目录

29. 控制字符 ctl+a命令行最前方ctl+b退格键无损ctl+c强制停掉当前前台操作ctl+d退出
