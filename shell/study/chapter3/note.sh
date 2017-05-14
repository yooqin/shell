#!/bin/bash

#验证base参数是否正确，并提示应该输入的内容

sleep 10

echo hello
sleep 30
echo llll
exit 0

E_WRONG_ARGS=85
script_parameters="-a -h -m -z"

number_of_expected_args=3

echo $#

if [ $# -ne $number_of_expected_args ]
then
    echo "Usage:`basename $0` ${script_parameters}"
    exit $E_WRONG_ARGS
fi
