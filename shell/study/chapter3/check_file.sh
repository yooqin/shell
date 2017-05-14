#!/bin/bash

filename=$1
#检测文件是否存在，注意这里用了;号隔开一行中的多个命令

if [ -x "$filename" ]; then    #  Note the space after the semicolon.
    echo "File $filename exists."; cp $filename $filename.bak
else
    echo "File $filename not exists"; touch $filename
fi; echo "File exists complete."
