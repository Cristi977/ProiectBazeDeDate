<?php

use Illuminate\Database\Capsule\Manager as Capsule;

try {
    require_once __DIR__ . '/database.php';

    Capsule::connection()->getPdo();

    echo "Conectare reusita la: "
        . Capsule::connection()->getDatabaseName()
        . PHP_EOL;

    $numarProduse = Capsule::table('produse')->count();

    echo "Numar de produse: " . $numarProduse . PHP_EOL;
} catch (\Throwable $e) {
    echo "Eroare: " . $e->getMessage() . PHP_EOL;
}