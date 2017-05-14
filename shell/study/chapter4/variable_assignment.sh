#!/bin/bash


#普通赋值
a=123
echo "变量a的值：${a}"
echo 

#使用let赋值
let a=10+8
echo "变量a的值：${a}"
echo

#使用for赋值
for a in 8 9 10
do
    echo -n "${a}"
done
echo 

#使用read赋值
echo "请键入a的值"
read a
echo "a的值是${a}"

#命令行形式赋值
a=`ls -l`
echo $a     #remove换行
echo "${a}" #保留


a=$(cat ./variable_assignment.sh)
echo $a

exit 0

