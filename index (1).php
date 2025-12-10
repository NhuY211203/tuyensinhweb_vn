<?php
// Forward mọi /api/* vào Laravel public/index.php
$SERVER['SCRIPT_NAME'] = '/laravel/public/index.php';
$SERVER['SCRIPT_FILENAME'] = DIR . '/../laravel/public/index.php';
require DIR . '/../laravel/public/index.php';