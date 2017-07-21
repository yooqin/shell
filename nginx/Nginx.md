# 附录手册

## Nginx常用操作

- httpd -v 查看apache版本
- php —version 查看php版本信息
- sudo apachectl stop 关闭apache
- sudo nginx 打开nginx
- nginx -s reload|reopen|stop|quit 重新加载配置 重启 停止 退出
- nginx -t 测试配置
- kill -HUP cat /xxxxxnginx.pid  //配置文件修改重新加载
- 查看端口开放情况
    
    netstat -nat |grep LISTEN  
    lsof -n -P -i TCP -s TCP:LISTEN  
    telnet 127.0.0.1 端口号 //验证端口是否开启

- Nginx的启动

    kill -HUB pid : 从容重启Nginx，像Nginx   
    master进程发送信号，重新加载配置，从新创建worker进程  
    nginx -s reload|reopen|stop|quit 重新加载配置 重启 停止退出，Nginx 0.8版本后增加命令

# Nginx的基本配置及优化

## Nginx的完整配置示例

Nginx服务器配置文件
```
#使用的用户和用户组
user www www;

#工作衍生进程数(一般设置为cpu总核数的两倍)
worker_processes 8;
#制定错误日志存放路径，错误日志记录级别可选为[debug|info|notice|
#warn|error|crit]
error_log /var/log/nginx/nginx_error.log crit;
#制定pid存放路径
pid /usr/location/nginx/nginx.pid
#制定文件描述数量
worker_rlimit_nofile 51200;
events{
	#使用网络I/O模型，Linux系统采用epoll模型，FreeBSD系统采用kqueue
	#模型
	use epoll;
	#允许的连接数
	worker_connections 51200;
	http{
		include mime.types;
		default_type application/octet-stream;
		#设置使用的字符集，如果页面有多重字符集不要在此设置
		charset utf-8;

		server_names_hash_bucket_size 128;
		client_header_buffer_size 32k;
		large_client_header_buffers 4 32k;

		#设置客户端上传文件大小
		client_max_body_size 8m;

		sendfile on;
		tcp_nopush on;

		keepalive_timeout 60;
		tcp_nodelay on;

		fastcgi_connect_timeout 300;
		fastcgi_send_timeout 300;
		fastcgi_read_timeout 300;
		fastcgi_buffer_size 64k;
		fastcgi_buffers 4 64k;
		fastcgi_busy_buffers_size 128k;
		fastcgi_temp_file_write_size 128k;

		#开启gzip压缩
		gzip on;
		gzip_min_length 1k;
		gzip_buffers 4 16k;
		gzip_http_version 1.1;
		gzip_comp_level 2;
		gzip_types text/plain application/x-javascript 
		text/css application/xml;
		gzip_vary on;

		server{
			listen 80;
			server_name test.com www.test.com;
			index index.html index.php
			root /data/www/site;

			location ~* .*\.(gif|jpg|jpeg|png|swf)${
				expires 30d;
			}

			location ~ .*\.(js|css)?${
				expires 1h;
			}

			log_format access '$remote_addr $remote_user 
			$time_local "$request" $status $body_bytes_send 
			"$http_referer" "$http_user_agent" 
			$http_x_forwarded_for';
			access_log /var/log/nginx/access.log access;
		}

	}
}
```
配置文件的格式大致为
```
....
....
events{
	....
	....
}
http{
	....
	....
	server{
		....
		....
	}
	server{
		....
		....
	}
}
```

## Nginx虚拟主机的配置

```
http{
	server{
		listen 80 default;
		server_name _ *;
		access_log /var/logs/nginx.log access;
		location / {
			index index.html;
			root /data/www/test
		}
	}
}
```

### 基于IP的虚拟主机

主机上添加多个ip别名
```
	   http{
	
			#第1个
			server{
				listen 192.168.8.30:80;
				server_name 192.168.8.30;
				location / {
					index index.html;
					root /var/www/site1;
				}
			}
	
			#第2个
			server{
				listen 80; #listen可以省略ip，会使用server_name的ip
				server_name 192.168.8.31;
				location / {
					index index.html;
					root /var/www/site2;
				}
			}
	
			第N个
			...
	
		}
```

### 基于域名的虚拟主机

```
			server{
				listen 80;
				server_name www.testing.com
				location / {
					index index.html;
					root /var/www/testing;
				}
			}
```

## Nginx日志文件配置及切割

Nginx日志主要指令有log_format(设置日志格式)、access_log(日志文件),指令作用域在http{}或server{}

### log_format设置日志格式

语法: log_format name format {format}
Nginx有一个默认的combined日志格式无需设置
```
log_format mylogformat '$http_x_forwarded_for - $remote_user [$time_local] '
'"$request" $status $body_bytes_send'
'"$http_referer" "$http_user_agent"';
```
指定缓冲区设置 access_log /var/log/access.log combined buffer=32k;

### Nginx日志文件切割

```
//移动log文件
mv /var/log/nginx/access.log /var/log/nginx/back/20150101.log
//重新生成log
kill -USER1 `cat /run/nginx.pid`
```

## Nginx Gzip压缩配置

gzip压缩一般能压缩至原大小的30%甚至更小，gzip压缩指令位于http{}指令块中
```
gzip on;
gzip_min_length 1k;
gzip_buffers 4 16k;
gzip_http_version 1.1;
gzip_comp_level 2;
gzip_types text/plain application/x-javascript text/css application/xml;
gzip_vary on;
```

## Nginx自动列目录配置

前提模块下不能有index指令
```
location / {
	autoindex on;
	autoindex_exact_size on;
	autoindex_localtime on;
}
```

## Nginx浏览本地缓存配置

```
	location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
        expires 7d;
    }

    location ~ .*\.(js|css)?$
    {

        expires 2h;
    }
```

# Nginx与PHP及PHP-FPM的安装配置及优化

## FastCGI是什么

FastCGI将CGI解释器的进程保持在内存中并以此获得较高的性能，CGI反复加载是CGI性能低下的原因，把CGI解释器保持在内存中并接受FastCGI进程管理器调度，提供良好的性能、伸缩性

### CGI工作原理

1. 解析配置启动CGI > 处理输入返回输出 > 断开连接关闭CGI

### FastCGI工作原理

1. FastCGI进程管理器自身初始化，启动多个CGI解释器(php-cgi)进程并等待来自WebServer的连接；
1. 客户端请求到达Web服务器(Nginx)时，Nginx采用TCP协议或UNIX套节字方式转发到FastCGI主进程，FastCGI主进程选择一个cig子进程，Nginx将CGI环境变量和标准输入发送到cig子进程；
1. FastCGI子进程完成处理后将标注输出和错误信息从同一连接返回给Nginx，当FastCGI子进程关闭连接时，请求便告知处理完成，FastCGI等待处理下一个FastCGI主进程分配的连接

# Nginx HTTP负载均衡和反向代理的配置与优化

## 相关概念

### 负载均衡

负载均衡由多台服务器以对称的方式组成一个服务器集合，每台服务器都具有等价地位，都可以单独对外提供服务，通过某种负载分担技术，将外部发送的请求均匀分配到对称结构中的某一台服务器上;

### 反向代理(Reverse Proxy)

代理服务器接收Internet上的请求，让后将请求转发给内部网络的服务器，并将服务器上的结果返回给请求连接的客户端，即为反向代理服务。

### 正向代理

代理服务器代理内部网络对Internet的连接请求，客户机必须制定代理服务器，并将本来直接发送到Web服务器的请求发送到代理服务器。

## 常见的web负载均衡方法

### 用户手动选择方式

比较古老的方式，通过主站入口提供不同线路不同服务器的链接，通常下载站都如此采用此方式

### DNS轮询方式

同一个域名添加多条A记录实现简单的DNS轮询，如dig www.baidu.com的结果
```
diw www.baidu.com
www.baidu.com.        1045    IN    CNAME    www.a.shifen.com.
www.a.shifen.com.    280    IN    A    61.135.169.125
www.a.shifen.com.    280    IN    A    61.135.169.121
```
DNS轮询会有存在可靠性低下、负载分配不均衡

### 四/七层负载均衡设备

#### OSI模型

OSI(open system interconnection)开放系统互联网模型：由低层到高层为物理层、数据链路层、网络层、传输层、会话层、表示层、应用层。其中一至四层为低层与数据移动密切相关，五至七层为高层包含程序级数据。  

==============================================================  
应用层: 操作系统或应用程序提供访问网络服务的接口，包括文件传输  
        文件管理、电子邮件等信息  
        协议: Telnet FTP HTTP SNMP     
=============================7=================================  
表示层: 管理数据的解密加密，图片和文件信息进行解码编码  
=============================6=================================   
会话层: 网络中两节点之间建立维持通信，保持会话同步，还决定通信    
        是否中断，通信中断时决定何处重新发送    
=============================5=================================  
传输层: 网络通信时第一个端到端的层次，起到缓冲作用，当网络层的  
        服务质量不能满足时，它将提高服务，当网络层服务质量较高  
        时它只做很少的事情。处理端到端的差错控制、流量控制提供  
        可靠无误的数据传输  
        协议: TCP UDP SPX  
        在IP协议栈中第四层是TCP（传输控制协议）和UDP（用户数据  
        报协议）所在的协议层。TCP和UDP包含端口号，它可以唯一区  
        分每个数据包包含哪些应用协议如(HTTP FTP telnet),TCP/  
        UDP端口号提供附加信息可为网络交换机利用，四层交换机利  
        用这种信息来区分包中数据，这是四层交换基础  
=============================4=================================  
网络层: 通常包含IP地址、路由协议、地址解析协议(ARP)相关问题，  
        负责对子网间的数据包进行路由选择，决定一个网络中两个  
        节点的最佳路径，可以实现拥塞控制、网际互联  
        协议: IP IPX RIP OSPF  
=============================3=================================  
数据链路层: 控制网络层和物理层之间的通信，保证数据在不可靠的物  
            理层进行可靠传递，把网络层的数据分割成特定的可被物  
            理层传输的帧保证传输可靠性。主要作用物理地址寻址、  
            数据成帧、流量控制、检错、重发。  
            协议: SDLC HDLC PPP STP 帧中继   
==============================2================================  
物理层: 包括物理联网媒介(布线、光纤、网卡和其他两台通信设备连  
        接在一起的设施)，它规定了激活、维持、关闭通信端点之间  
        的机械特性、电器特性、功能及过程特性。物理层不提供纠  
        错服务，但能够设定数据传输速率并检测数据出错率.  
==============================1================================  

#### 四\七层负载均衡

现代负载均衡通常操作与OSI模型中的第四层或第七层   
1. 第四层负载均衡将网络上IP地址映射为多个内部服务器IP地址对每次TCP连接请求动态使用其中一个IP地址达到负载均衡目的。  
1. 第七层控制应用层的内容提供对访问流量高层控制方式，七层负载均衡通过检查HTTP报头，通过报头执行负载均衡任务。

##### 硬件四/七层负载均衡交换机
七层负载均衡交换机代表有F5 BIG-IP、Citrix NetScaler、Radware、Cisco CSS、Foundry

##### 软件四层负载均衡
LVS(linux Virtual Server)

##### 软件七层负载均衡
大多基于HTTP反向代理方式，如Nginx、L7SW、HAProxy

##### 多线多地区智能DNS解析与混合负载均衡方式
多线多地区智能DNS解析、DNS轮询、四/七层负载交换机等技术综合使用,达到负载均衡最优化

## Nginx负载均衡与方向代理配置实例

配置示例
```
http{
    #允许客户端请求的最大单个文件字节数 
    client_max_body_size 300m;
    
    #缓冲区代理缓冲用户端请求的最大字节数, 先保存到本地再传给用户
    client_body_buffer_size 128k;

    #后端服务器连接超时时间，发起握手等候响应超时时间
    proxy_connect_timeout 600;
    
    #连接成功后，等待后端服务器响应时间
    proxy_read_timeout 600;

    #后端数据回传时间
    proxy_send_timeout 600;

    #代理请求缓冲区
    proxy_buffer_size 16k;
    proxy_buffers 4 32k;

    #如果系统很忙的时候申请更大的proxy_buffers
    proxy_busy_buffers_size 64k;

    upstream php_server_pool{
        server 127.0.0.1:8081 weight=5 max_fails=2 filetimeout=30s;
        server 127.0.0.1:8082 weight=5 max_fails=2 filetimeout=30s;
    }

    server {
        listen       8080;
        server_name  localhost;

        #charset koi8-r;
        access_log  /var/log/nginx/access.log main;

        location / {
            proxy_next_upstream http_502 http_504 error timeout invalid_header;
            proxy_pass http://php_server_pool;
            proxy_set_header Host localhost;
            proxy_set_header X-Forwarded-For $remote_addr;
            #root   html;
            #index  index.html index.htm;
        }
    }


    server {
        listen 8081;
        server_name localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }
    }

    server {
        listen 8082;
        server_name localhost;

        location / {
            root   /usr/local/var/www2;
            index  index.html index.htm;
        }
    }
}
```

### Nginx负载均衡的HTTP Upstream模式

#### ip_hash指令

根据Iphash定位到具体的服务器上，有效解决多次访问不在同一服务器问题，但负载均衡效果不能保证
down可以保证hash结果一直
```
upstream backend {
    ip_hash;
    server example.com;
    server example.com down;
    server example.com;
    server example.com;
}
```

#### server指令

server name [parameters]
参数
weight=number
max_fails=number
fail_timeout=time
down
backup

#### upstream相关变量

$upstream_addr 处理upstream服务器地址
$upstream_status upstream服务器应答状态
$upstream_response_time upstream服务器响应时间毫秒
$upstream_http_$HEADER 任意的HTTP协议头信息

### Nginx负载均衡服务器的双机高可用

双机高可用通过虚拟IP（漂移IP）方式来实现,主要形式有以下两种:  
1. 一台主服务器加一台热备服务器，主服务器绑定一个公网虚拟ip提供负载均衡服务，热备服务器处于空闲状态，主发生故障时，热备服务器接管主服务器的虚拟ip;  
1. 两台负载均衡服务器都处于活动状态，各自绑定一个公网虚拟ip，其中一台故障时，另一台接管发生故障的虚拟ip;

#### 一主一热备实现

1. www.test.com解析到虚拟IP 61.1.1.2
1. 主机 61.1.1.4绑定虚拟ip 61.1.1.2
```
ifconfig eth0:1 61.1.1.2 broadcast 61.1.1.255 netmask 255.255.255.0 up
route add -host 61.1.1.2 dev eth0:1
arping -I eth0 -c 3 -s 61.1.1.1
```
1. 用户访问www.test.com实际访问的是61.1.1.4,而另一台热备61.1.1.5空闲
1. 如果 61.1.1.4故障，61.1.1.5 接管虚拟ip61.1.1.2
```
ifconfig eth0:1 61.1.1.2 broadcast 61.1.1.255 netmask 255.255.255.0 up
route add -host 61.1.1.2 dev eth0:1
arping -I eth0 -c 3 -s 61.1.1.1
```
1. 用户访问www.test.com则落到61.1.1.5上

#### 双机负载均衡

1. www.test.com 域名通过DNS轮询解析到虚拟ip 61.1.1.2  61.1.1.3上
1. 61.1.1.4绑定虚拟ip \*\*\*.2， \*\*\*.5绑定虚拟ip\*\*\*.3
1. 若\*\*\*.4故障，则在\*\*\*。5上同时绑定虚拟ip \*\*\*.2 和 \*\*\*.3 
如一个自动切换的脚本
```
#!/bin/sh
LANG=C
date=$(date -d "today" +"%Y-%m-%d %H:%M:%S")

function_bind_vip1(){
    ifconfig eth0:ha1 61.1.1.2 broadcast 61.1.1.255 netmask 255.255.255.0 up
    route add -host 61.1.1.2 dev eth0:ha1
}

function_bind_vip2(){
    ifconfig eth0:ha2 61.1.1.3 broadcast 61.1.1.255 netmask 255.255.255.0 up
    route add -host 61.1.1.3 dev eth0:ha1
}

function_remove_vip1(){
    ifconfig eth0:ha1 61.1.1.2 broadcast 61.1.1.255 netmask 255.255.255.0 down
}

funciton_remove_vip2(){
    ifconfig eth0:ha1 61.1.1.3 broadcast 61.1.1.255 netmask 255.255.255.0 down
}

function_vip_arping1(){
    arping -I eth0 -c 3 -s 61.1.1.2 61.1.1.1 > /dev/null 2>&1
}

function_vip_arping2(){
    arping -I eth0 -c 3 -s 61.1.1.3 61.1.1.1 > /dev/null 2>&1
}

bind_time_vip1="N"
bind_time_vip2="N"

while true
do
    httpcode_rip1=`curl -o /dev/null -s -w %{http_code} http://61.1.1.4`
    httpcode_rip2=`curl -o /dev/null -s -w %{http_code} http://61.1.1.5`

    if [ x$httpcode_rip1 == "x200"];
    then
        if [ $bind_time_vip1 == "N" ];
        then
            function_bind_vip1
            function_vip_arping1
            nginx -s reload
            bind_time_vip1="Y"
        fi
        function_vip_arping1
    else 
        if [ $bind_time_vip1 == "Y" ];
        then
            function_remove_vip1
            bind_time_vip1="N"
        fi
    fi

    if [ x$httpcode_rip2 == "x200" ];
    then
        if [ $bind_time_vip2 == "Y" ];
        then
            function_remove_vip2
            bind_time_vip2="N"
        fi
    else 
        if [ $bind_time_vip2 == "N" ]
        then
            function_bind_vip2
            function_vip_arping2
            nginx -s reload
            bind_time_vip2="Y"
        fi
        function_vip_arping2
    fi

    sleep 5
done
```

# Nginx Rewrite规则与示例
- Rewrite到固定的入口文件
- 动态url伪装成静态HTML
- 目录结构、域名变化旧URL跳转至新的URL

## 相关指令
简单的rewrite示例
```
if (!~f $request_filename) {
    rewrite ^/img/(.*)$ /site/$host/images/$1 last;
}
```

### break
- 使用环境:server, location, if
- 作用:完成当前的规则集，不再处理rewrite指令
- 示例
```
if ($slow) {
    limit_rate 10k;
    break;
}
```

### if
- 使用环境:server, location
- 作用:检查一个条件是否符合，if指令不支持嵌套，不支持&&或||
1. 变量名不能包括空字符串或以0开始的字符串
2. 变量的比较使用 = 或 ！=
3. 正则表达式的匹配使用 ~* 和 ~ 号
4. ~ 表示区分大小写字母匹配
5. ~* 表示不区分大小写字母匹配
6. !~ 和 !~* 和 !~ ~* 相反
7. -f 和 ~-f 判断文件是否存在
8. -d、~-d 判断目录是否存在
9. -e、!-e 判断文件或目录是否存在
10. -x、!-x 判断文件是否可执行
- 示例
```
if ($http_user_agent ~ MSIE) {
    rewrite ^(.*)$ /msie/$1 break;
}

if ($http_cookie ~* "id=([^;] +)(?:;|$)") {
    set $id $1;
}

if ($request_method = POST) {
    return 405;
}

if (!-f $request_filename) {
    break;
    proxy_pass http://127.0.0.1;
}

if ($slow) {
    limit_rate 10k;
}

if ($invalid_referer) {
    return 403;
}
```

### return
- 使用环境:server, location, if
- 作用:结束规则的执行并返回状态码给客户端
- 状态码及含义  
1. 200(No Content)服务器成功处理了请求但无需返回任何实体内容且希望返回更新了元信息。
2. 400(Bad Request)包含语法错误，当前请求服务器无法理解
3. 402(Payment Required)预留
4. 403(Forbidden)理解了请求但拒绝执行
5. 404(Not Found)希望得到的资源未在服务器上发现
6. 405(Method Not Allowed)指定的请求方法不能被用于请求相应的资源
7. 406(Not Acceptable)请求的资源特性无法满足请求头的条件，无法生存响应实体
8. 408(Request Timeout)请求超时
9. 410(Gone)请求的资源在服务器上已经不可用
10. 411(Length Required)服务器拒绝灭有定义Content-Lenght头情况下的请求
11. 413(Request Entity Too Large)请求提交的实体数据的大小超过了服务器能能够处理的范围，如果这种限制是临时的服务器应当返回一个Retry-After响应头告知客户端多少时间后重新尝试
12. 416(Request Range Not Satisfiable)
13. 500(Internal Server Error)服务器无法完成对请求的处理，服务器程序出错是出现
14. 501(Not Implemented)服务器不支持当前请求所需要的某个功能
15. 502(Bad Gateway)网管或代理服务器执行请求时从上游服务器接收到无效的响应
16. 503(Service Unavailable)临时的服务器维护或过载，服务器当前无法处理请求
17. 504(Gateway Timeout)作为代理或网管服务器尝试执行请求时，未能及时从上游服务器收到响应
- 示例
```
location ~ .*\.(sh|bash)?${
    return 403;
}
```

### rewrite
- 语法:rewrite regex replacement flag
- 使用环境:server, location, if
- flag 列表
1. last - 相当于apache里的L标记，表示完成rewrite
2. break - 匹配完成后终止匹配
3. redirect - 返回302重定向，浏览器地址会显示为跳转后的地址
4. permanent - 返回301永久重定向，浏览器地址不会显示跳转后的URL
- 示例
```
location /cms/ {
    proxy_pass http://test.yourdomain.com;
    rewrite "^/cms/(.*)\.html$" /cms/index.html break;
}
#一般在location中或server中直接编写rewrite规则，推荐使用last标记；在非根location中推荐使用break标记

rewrite ^(/download/.*)/media/(.*)\..*$ $1/mp3/$2.mp3 last;
return 403;

location /download/ {
    rewrite ^(/download/.*)/media/(.*)\..*$ $1/mp3/$2.mp3 break;
    return 403;
}

rewrite "/photos/([0-9]{2})([0-9]{2})([0-9]{2})" /path/to/photos/$1/$1$2/$1$2$3.png;
```

### set
- 语法: set variable value
- 使用环境: server, location, if
- set $varname 'hello';
- 
### uninitialized_variable_warn
- 使用环境:http,server,location,if
- 作用:用于开启或关闭记录未初始化变量的警告信息，默认为开启

### Nginx Rewrite可以用的全局变量
1. $args
2. $content_length
3. $content_type
4. $document_root
5. $document_uri
6. $host
7. $http_user_agent
8. $http_cookie
9. $limit_rate
10. $request_body_file
11. $request_method
12. $remote_addr
13. $remote_port
14. $remote_user
15. $request_filename
16. $request_uri
17. $query_string
18. $scheme
19. $server_protocol
20. $server_addr
21. $server_name
22. $server_port
23. $uri

## PCRE正则表达式语法

## Rewrite规则编写实例
- 文件或目录不存在时重定向到一个文件
```
if (!-e $request_filename){
    rewrite ^/(.*)$ /index.php last;
}
```

- 多个目录转换为参数
```
if ($host ~* (.*)\.domain\.com) {
    set $sub_name $1;
    rewrite ^/sort\/(\d)\/?$ /index.php?cid=$sub_name&id=$1 last;
}
```

- 目录兑换
```
rewrite ^/(\d+)/(.+)/ /$2?id=$1 last;
```

- 禁止访问多个目录
```
location ~ ^/(cron|templates)/{
    deny all;
    break;
}
```

- 禁止访问以 /data 开头的文件
```
location ~ ^/data{
    deny all;
}
```

- 根据referer信息设置防盗链
```
location ~* \.(gif|jpg|png|swf|flv)$ {
    valid_referers none blocked www.yourdomain.com *.yourdomain.com;
    if ($invalid_referer) {
        rewrite ^/(.*) http://www.yourdomain.com/blocked.html;
    }
}
```

- 域名前缀作为重写规则变量的示例
```
if ($host ~* ^(.*?)\.domain\.com$) {
    set $var_wupin_city $1;
    set $var_wupin '1';
}

if ($host ~* ^qita\.domain\.com$) {
    set $var_wupin '0';
}

if (!-f $document_root/html/zhuanti/secondmarket/$var_wupin_city/index.html) {
    set $var_wupin '0';
}
if ($var_wupin ~ '1') {
    rewrite ^/wu/$ /html/zhuanti/secondmarket.$var_wupin_city/index.html last;
}
```

# Nginx模块开发
