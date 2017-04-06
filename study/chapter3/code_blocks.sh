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
