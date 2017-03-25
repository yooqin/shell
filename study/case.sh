#!/bin/bash

variable=$1

case "$variable" in
  abc)  echo "\$variable = abc" ;; 
  xyz)  echo "\$variable = xyz" ;;
esac


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



: ${username=`whoami`}

echo $username

echo $$

#命令组内的变量存在于子进程中不会污染外部变量
(a=hello; echo $a)
echo $a
