# 介绍

- PHP面向对象的高级特性    
魔术方法、SPL、自动载入、命名空间
- 11种PHP设计模式
- PSR-0,Composer,Phar

# 开发环境

### Phpstorm使用


### 编程字体选择

为什么要注意字体，因为编程中常会有oO0il1等字符的区分    
- 选择等宽字体    
- 常见等宽字体包括Courier New,Consolas    
- 推荐使用SourceCodePro由Adobe转为程序员设计，免费开源    

### 运行环境搭建

-easyPHP

# PHP面向对象的高级特性

### PHP命名空间
命名空间解决的问题：    
1、防止类名冲突    
2、增加包的概念更好的构建大工程    

##### 命名空间的声明
```
test1.php
<php 
namespace Test;

function test(){
    echo "test";
}
test2.php
<?php
namespace Test2;
function test(){
    
}
client.php
<?php
require 'test1.php';
require 'test2.php'; 

Test1\test();
Test2\test();
```
由于有了命名空间的隔离同时require两个test方法并不会报错

### 类的自动载入
项目大了之后需要require各种文件，如果某个文件删除还需要删除require引入导致需要花费大量的时间维护require文件，这样就引入了自动载入来解决这个问题

- 最原始形式 require、include

- 后来的形式
```
<?php
Test1::test();
function __autoload($class){
    require __DIR__'/'.$class;
}
```
这种形式有个问题当多个框架中都会有__autoload，这样多个框架融合就会导致报错，php5.3之后提供了spl_autoload_register('autoload1')；

- 目前的形式spl_autolaod_register
```
<?php
spl_autoload_register('autoload1');
spl_autoload_register('autoload2');

Test1::test();

public function autoload1($class){
    require __DIR__'/'.$class;
}
public function autoload2($class){
    require __DIR__'/'.$class;
}
```

### PSR-0规范
- 命名空间必须与路径一致
- 类名首字母必须大写
- 出入口文件外，其他php文件只能有一个类不能有可执行的代码

##### 符合PSR-O规范的框架要求
- 全部使用命名空间
- 所有PHP文件自动载入
- 单一入口

##### 代码示例
```
├── App
│   └── Controller
│       └── Home
│           └── Index.php
├── BaseFramework
│   ├── Loader.php
│   └── Object.php
└── index.php

#index.php
<?php
define('BASEDIR', __DIR__);

require BASEDIR.'/BaseFramework/Loader.php';
spl_autoload_register('\\BaseFramework\\Loader::autoload');

BaseFramework\Object::test();

#Loader.php
<?php
namespace BaseFramework;

class Loader{

    static function autoload($class){
        $file = BASEDIR.'/'.str_replace('\\', '/', $class).".php";
        require $file;
    }

}

#Index.php
<?php
namespace App\Controller\Home;

class Index{

    function test(){
        echo "Index->test run.";
    }

}
```

### SPL标准库的使用

##### 数据结构
```
//栈
$stack = new SplStack();
$stack->push('d1');
$stack->push('d2');
echo $stack->pop();
echo $stack->pop();

//队列
$queue = new SplQueue();
$queue->enqueue('d1');
$queue->enqueue('d2');
echo $queue->dequeue();
echo $queue->dequeue();

//堆
$heap = new SplMinHeap();
$heap->insert('d1');
$heap->insert('d2');
echo $heap->extract();
```

##### 迭代器

##### 接口

##### 异常

##### SPL函数

##### 文件处理

##### 各种类及接口


### PHP链式操作实现
$db->where()->limit()->order();

```
class Db{
    public funtion where(){
        return $this;
    }
    public function limit(){
        return $this;
    }
    public function order(){
        return $this;
    }
}
```

### PHP魔术方法使用








