<?php

require __DIR__ . '/database.php';

use Illuminate\Database\Capsule\Manager as Capsule;

try {
    Capsule::connection()->getPdo();
    echo "Connected successfully to: " . Capsule::connection()->getDatabaseName() . PHP_EOL;
} catch (\Exception $e) {
    echo "Connection failed: " . $e->getMessage() . PHP_EOL;
}