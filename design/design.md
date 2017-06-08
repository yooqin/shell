# 软件设计原则
原则为我们提供指南，它告诉我们什么是对的，什么是错的。不会告诉我们如何解决问题，给出一些准则以便我们可以设计好的软件，避免不良的设计。

## 面向对象的SOLID原则
- 职责单一原则 Single Responsibility Principle (SRP)
核心思想[一个类只做一件事并把这件事做好，其只有一个引起它变化的原因]单一职责原则可以看做是低耦合、高内聚在面向对象原则上的引申，将职责定义为引起变化的原因，以提高内聚性来减少引起变化的原因。职责过多可能引起它变化的原因就越多，这将导致职责依赖，相互之间就产生影响，从而极大的损伤其内聚性和耦合度。单一职责通常意味着单一的功能，因此不要为一个模块实现过多的功能点，以保证实体只有一个引起它变化的原因。Unix/Linux是这一原则的完美体现，每个程序都独立负责一个单一的事情；Windows是这一原则的反面示例，几乎所有的程序都交织在一起。

- 开闭原则 Open/Closed Principle (OCP)
核心思想[模块是可扩展的，而不可修改的。也就是说对扩展是开放的，而对修改是封闭的]  
对扩展开放：有新的需求或者变化时，可以对现有代码进行扩展，以适应新的情况。  
对修改封闭：意味着类一旦设计完成，就可以独立完成其工作，而不要对类进行任何修改 
对于面向对象来说，需要依赖抽象而不是实现。“策略模式”就是这个的实现。 

- 里氏替换原则 Liskov substitution principle (LSP)
核心思想[子类必须能够替换他们的基类]子类可以替换任何基类能够出现的地方，并且经过替换后代码仍可运行。另外不应该在代码中出现ifelse之类对子类类型进行判断的条件。  
LSP是使代码符合开闭原则的一个重要保证，正是由于子类型的可替换性才使得福类型的模块在无需修改的情况下就可以扩展。  
这个原则让你考虑的不是语义上对象间的关系，而是实际需求的环境。在很多情况下，在设计初期我们类之间的关系不是很明确，LSP给了我们一个判断和设计类之间关系的基准：需不需要继承，以及怎样设计继承关系。

- 接口隔离原则 Interface Segregation Principle (ISP）
把功能实现在接口中，而不是类中，使用多个专门的接口比使用单一的总接口要好。  

- 依赖倒置原则 Dependency Inversion Principle (DIP)
高层模块不应该依赖于底层模块实现，而是依赖于高层抽象。

## 其他软件设计原则
- Don't Repeat Yourself(DRY):当我们在两个或多个地方发现一些相似的代码的时候，我们需要把他们共性抽象出来形成一个唯一的新方法，并且改变现有的地方的代码让他们以一些合适的参数调用这个新方法。
- Keep It Simple,Stupid(KISS)
- Program to an interface, not an implementation
- Command-Query Separation(CQS)-命令查询分离原则
查询：当一个方法返回一个值来回应一个问题的时候，它就具有查询的性质。  
命令：当一个方法要改变对象的状态的时候，它就具有命令的性质。 
在设计接口时，如果可能，应该尽量使接口单一化，保证方法的行为严格的是命令或者是查询，这样查询方法不会改变对象的状态，没有副作用，而会改变对象的状态的方法不可能有返回值。也就是说：如果我们要问一个问题，那么就不应该影响到它的答案。实际应用，要视具体情况而定，语义的清晰性和使用的简单性之间需要权衡。将Command和Query功能合并入一个方法，方便了客户的使用，但是，降低了清晰性，而且，可能不便于基于断言的程序设计并且需要一个变量来保存查询结果。  
在系统设计中，很多系统也是以这样原则设计的，查询的功能和命令功能的系统分离，这样有则于系统性能，也有利于系统的安全性。 
- You Ain't Gonna Need It(YAGNI)
- Law of Demeter-迪米特法则
- Common Closure Principle(CCP)-共同封闭原则
- Common Reuse Principle(CRP)-共同重用原则
- Hollywood Principle-好莱坞原则
- High Cohesion & Low/Loose coupling 高内聚低耦合
内聚：一个模块内各个元素批次结合的紧密程度   
耦合：一个软件结构内不同模块之间互联程度的度量  
内聚意味着重用和独立，耦合意味着多米诺效应牵一发动全身

# 软件设计模式
模式是在软件开发过程中总结得出的一些可重用的解决方案，解决一些实际问题。

## 控制反转(IOC)
为相互依赖的组件提供抽象，将依赖(底层模块)对象的获得交给第三方来控制，即依赖对象不在被依赖模块的类中直接通过NEW来获取。
```
class SqlServerUtil{
    public function Add(){
        echo "sqlServer中添加";
    }
}

class Order{
    private $sql_server_util = null;
    public function __construct(){
        $this->sql_server_util = new SqlServerUtil();
    }
    public function Add(){
        $this->sql_server_util->Add();
    }
}

class orderController{
    public function addOrder(){
        $order = new Order();
        $order->Add();
    }
}
```
代码问题组件之间高度耦合、可扩展性差违背了DIP原则。高层的Order类不应该依赖于底层的SqlServerUtil类，两者应该依赖于抽象。控制反转两种实现方式1、依赖注入 2、服务定位

### 依赖注入(DI)
IOC的一种重要方式，将依赖对象的创建和绑定转移到被依赖对象的外部来实现

- 构造函数注入  
```
//定义一个接口
interface IDataAccess{
    public function Add();
}
//SqlServer实现接口
class SqlServerUtil implements IDataAccess{
    public function Add(){
        echo "add";
    }
}
class Order{
    private $util=null;
    public function __construct(IDataAccess $idata){
        $this->util = $idata;
    }
    public function Add(){
        $this->util->Add();
    }
}
class orderController{
    public function addOrder(){
        $util = new SqlServerUtil();
        $order = new Order($util);
        $order->Add();
    }
}
```
将依赖对象SqlServerUtil对象的创建绑定放到了Order外部来实现从而解除了SqlServerUtil与Order的耦合关系。如需更改数据源则直接切换SqlServerUtil类即可无需修改Order类

- 属性注入  
通过属性传递依赖
```
class Order{
    private $util = null;
    public function setUtil(IDataAccess $idata){
        $this->util = $idata;
    }
    public function Add(){
        $this->util->Add();
    }
}
class orderController{
    public function addOrder(){
        $util = new SqlServerUtil();
        $order = new Order();
        $order->setUtil($util);
        $order->Add();
    }
}
```

- 接口注入  
相比构造函数注入与属性注入，接口注入有些复杂，思路为先定义一个接口，包含一个设置依赖的方法，然后依赖类，继承并实现这个接口。  
```
interface IDependent{
    public function setDependent(IDataAccess $idata);
}

class Order implements IDependent{
    ...
    ...
}
```

### IOC容器
IOC容器实际上就是DI框架，一般包含以下功能：  
1. 动态创建注入依赖对象    
2. 管理对象声明周期  
3. 映射依赖关系  






# 参考
- 《深入理解DIP、IoC、DI以及IoC容器》 http://blog.jobbole.com/101666/  
- 《一些软件设计的原则》 http://coolshell.cn/articles/4535.html