# 请求周期

1. 入口文件index.php 加载composer，创建应用实例/服务容器
2. 发送请求至http内核(app/Http/Kernel.php)
3. http内核引导配置错误处理、日志记录、程序环境检测
4. 通过http中间件，session读写、是否维护模式、验证CSRF
5. 载入注册服务提供者，所有服务提供者在(config/app.php中providers数组)，调用所有服务提供者的regster方法
6. 服务提供者引导各个组件，数据库、队列、验证器及路由
7. Request移交给路由进行分发，同时运行路由中间件
8. 返回结果

# 服务容器

服务容器是管理类依赖和运行依赖注入的工具，实质上指类的依赖通过构造器或在某种情况下通过setter方法进行注入。
```
<?php
use App\Repositories\UserRepository;
class UserController extends Controller{
    protected $users;

    //通过构造函数注入user对象，实现解耦
    public function __construct(UserRepository $users){
        $this->users = $users;
    }

    public function show($id){
        $user = $this->users->find($id);
        return view('user.profile', ['user'=>$user]);
    }
}
```
以上实现的好处：  
1. 实现UserController与UserRepository的解耦
2. 方便切换UserRepository的实现形式
3. 在测试时可以轻松的mock或创建假的UserRepository

## 绑定

几乎所有服务容器的绑定都在服务提供者中进行的。如果类没有依赖任何接口，没有必要绑定到容器中。
- 简单绑定
```
$this->app->bind('HelpSport\API', function($app){
        return new HelpSport\API($app->make('HttpClient'));
    });
```
- 绑定一个单例
```
$this->app->singleton('HelpSpot\API', function($app){
        return new HelpSport\API($app->make('HttpClient'));
    });
```
- 绑定实例
```
$api = new HelpSpot\API(new HttpClient);
$this->app->instance('HelpSpot\Api', $api);
```
- 绑定初始数据
```
$this->app->when('App\Http\Controllers\UserController')
          ->needs('$variableName')
          ->give($value);
```
- 绑定接口至实现
```
$this->app->bind(
    'App\Contracts\EventPusher',
    'App\Services\RedisEventPusher'
);

use App\Contracts\EventPusher;
public function __construct(EventPusher $pusher)
{
    $this->pusher = $pusher;
}
```
告诉容器一个类需要EventPusher接口实例时，RedisEventPusher的实例将会被容器注入

## 解析
- make方法
```
$api = $this->app->make('HelpSpot\API');
或
$api = resolve('HelpSpot\API');
```
- 自动注入

# 服务提供者
服务提供者是所有Laravel应用程序引导启动的中心所在

# Facades
为应用程序的 服务容器 中可用的类提供了一个「静态」接口，所有的 Laravel facades 都需要定义在命名空间 Illuminate\Support\Facades

# Contracts
系列框架用来定义核心服务的接口,如Illuminate\Contracts\Queue\Queue契约中定义了队列任务所需的方法

#中间件
Laravel 中间件提供了一种方便的机制来过滤进入应用的 HTTP 请求，例如，Laravel 包含验证用户身份权限的中间件。如果用户没有通过身份验证，中间件会重定向到登录页，引导用户登录

## 创建
php artisan make:middleware CheckAge

### 前置或后置中间件
```
//前置中间件
<?php
namespace App\Http\Middleware;
use Closure;
class BeforeMiddleware
{
    public function handle($request, Closure $next)
    {
        // 执行动作
        return $next($request);
    }
}
//后置中间件
<?php
namespace App\Http\Middleware;
use Closure;
class AfterMiddleware
{
    public function handle($request, Closure $next)
    {
        $response = $next($request);
        // 执行动作
        return $response;
    }
}
```

## 注册中间件
- 全局中间件
如果你希望访问你应用的每个 HTTP 请求都经过某个中间件，只需将该中间件类列入 app/Http/Kernel.php 类里的 $middleware 属性
- 为路由制定中间件
1. 在app\Http\Kernel中指定中间件，在路由中->middleware('middlewarename');
2. 直接将中间件类传入，->middleware(CheckAge::class);
- 中间件组

## 代码
注册Router
\Illuminate\Routing\Router::auth()

class Auth extends Facade
{
    /**
     * Get the registered name of the component.
     *
     * @return string
     */
    protected static function getFacadeAccessor()
    {
        return 'auth';
    }

    /**
     * Register the typical authentication routes for an application.
     *
     * @return void
     */
    public static function routes()
    {
        static::$app->make('router')->auth();
    }
}



$flight = App\Flight::firstOrCreate(['user_id' => '1']);
$flighe->save();


GET /photos index photos.index
GET /photos/create  create  photos.create
POST  /photos store photos.store
GET /photos/{photo} show  photos.show
GET /photos/{photo}/edit  edit  photos.edit
PUT/PATCH /photos/{photo} update  photos.update
DELETE  /photos/{photo} destroy photos.destroy

