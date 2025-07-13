<?php

use Spiral\RoadRunner\GRPC\Server;
use Spiral\RoadRunner\GRPC\Invoker;
use App\Services\MessageService;
use App\Services\MessageServiceInterface;

// Suppress deprecation and startup messages
error_reporting(E_ERROR);
ini_set('display_errors', '0');

require __DIR__ . '/vendor/autoload.php';

$server = new Server(new Invoker());
$server->registerService(MessageServiceInterface::class, new MessageService());
$server->serve();
