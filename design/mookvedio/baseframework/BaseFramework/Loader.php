<?php
namespace BaseFramework;

class Loader{

    static function autoload($class){
        $file = BASEDIR.'/'.str_replace('\\', '/', $class).".php";
        require $file;
    } 

}
