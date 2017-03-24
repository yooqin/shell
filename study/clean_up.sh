#!/bin/bash

#cleanup, version2
#run as root, of course.
#清理一个日志文件，每次保留日志文件中最新的50条，可指定条数

LOG_DIR=/Users/qinwei/github/shell/log
ROOT_UID=0
LINES=50
E_XCD=86
E_NOTROOT=87

if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "Must be root to run this script."
    exit ${E_NOTROOT}
fi

if [ -n "$1" ]
then
    lines=$1
else
    lines=${LINES}
fi

cd ${LOG_DIR}

if [ `pwd` != ${LOG_DIR} ]
then
    echo "Can't change to ${LOG_DIR}"
    exit ${E_XCD}
fi

tail -n ${lines} testnginx.log > testnginx.temp
mv testnginx.temp testnginx.log

cat /dev/null > testphp.log

exit 0
