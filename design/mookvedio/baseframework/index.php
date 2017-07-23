<?php
define('BASEDIR', __DIR__);

require BASEDIR.'/BaseFramework/Loader.php';
spl_autoload_register('\\BaseFramework\\Loader::autoload');

BaseFramework\Object::test();
