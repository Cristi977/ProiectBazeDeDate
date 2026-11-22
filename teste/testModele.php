<?php

use Illuminate\Database\Capsule\Manager as Capsule;
use App\Models\Comanda;
use App\Models\Produs;
use App\Models\PasPrelucrare;
use App\Models\Productie;
use App\Models\Receptie;
use App\Models\Stoc;

try {
    require_once __DIR__ . '/../database.php';

    echo "=== TEST CONEXIUNE ===" . PHP_EOL;

    Capsule::connection()->getPdo();

    echo "Conectare reusita la: "
        . Capsule::connection()->getDatabaseName()
        . PHP_EOL
        . PHP_EOL;

    echo "=== TEST MODELE ===" . PHP_EOL;

    $clase = [
    \App\Models\Rol::class,
    \App\Models\Utilizator::class,
    \App\Models\Comanda::class,
    \App\Models\Produs::class,
    \App\Models\Material::class,
    \App\Models\PasPrelucrare::class,
    \App\Models\Productie::class,
    \App\Models\ExecutieOperatie::class,
    \App\Models\IntrareMaterial::class,
    \App\Models\ConsumMaterial::class,
    \App\Models\Receptie::class,
    \App\Models\Stoc::class,
    \App\Models\GestionareIesire::class,
    \App\Models\AlertaMaterial::class,
];

    $erori = 0;

    foreach ($clase as $clasa) {
        echo PHP_EOL . $clasa . PHP_EOL;

        try {
            if (!class_exists($clasa)) {
                throw new \RuntimeException(
                    "Clasa nu a fost gasita. Verifica namespace-ul, "
                    . "numele fisierului si autoload-ul Composer."
                );
            }

            $model = new $clasa();

            if (!$model instanceof \Illuminate\Database\Eloquent\Model) {
                throw new \RuntimeException(
                    "Clasa nu extinde modelul Eloquent."
                );
            }

            echo "  Incarcare clasa: OK" . PHP_EOL;
            echo "  Tabel: " . $model->getTable() . PHP_EOL;
            echo "  Cheie primara: " . $model->getKeyName() . PHP_EOL;

            $numarInregistrari = $model->newQuery()->count();

            echo "  Citire tabel: OK" . PHP_EOL;
            echo "  Numar de inregistrari: "
                . $numarInregistrari
                . PHP_EOL;
        } catch (\Throwable $e) {
            $erori++;

            echo "  EROARE: " . $e->getMessage() . PHP_EOL;
        }
    }

    echo PHP_EOL . "=== REZULTAT FINAL ===" . PHP_EOL;
    echo "Modele verificate: " . count($clase) . PHP_EOL;
    echo "Modele fara erori: " . (count($clase) - $erori) . PHP_EOL;
    echo "Modele cu erori: " . $erori . PHP_EOL;

    exit($erori > 0 ? 1 : 0);
} catch (\Throwable $e) {
    echo PHP_EOL
        . "Testul nu poate continua: "
        . $e->getMessage()
        . PHP_EOL;

    exit(1);
}