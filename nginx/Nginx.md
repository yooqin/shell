## Mac下常用的操作

- Nginx常用操作

httpd -v 查看apache版本

php —version 查看php版本信息

sudo apachectl stop 关闭apache

sudo nginx 打开nginx

nginx -s reload|reopen|stop|quit 重新加载配置 重启 停止 退出

nginx -t 测试配置

kill -HUP cat /xxxxxnginx.pid  //配置文件修改重新加载

- 查看端口开放情况

netstat -nat |grep LISTEN

lsof -n -P -i TCP -s TCP:LISTEN

telnet 127.0.0.1 端口号 //验证端口是否开启

- Nginx的启动

kill -HUB pid : 从容重启Nginx，像Nginx master进程发送信号，重新加载配置，从新创建worker进程

nginx -s reload|reopen|stop|quit 重新加载配置 重启 停止退出，Nginx 0.8版本后增加命令