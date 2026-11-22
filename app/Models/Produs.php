<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Produs extends Model
{
    protected $table = 'produse';

    protected $primaryKey = 'ID_Produs';

    public $timestamps = false;

    protected $fillable = [
        'ID_Inginer',
        'Cod_Produs',
        'Nume',
        'Activ',
    ];

    protected $casts = [
        'ID_Inginer' => 'integer',
        'Activ' => 'boolean',
    ];

    public function inginer()
    {
        return $this->belongsTo(
            Utilizator::class,
            'ID_Inginer',
            'ID_Utilizator'
        );
    }

    public function comenzi()
    {
        return $this->belongsToMany(
            Comanda::class,
            'detalii_comanda',
            'ID_Produs',
            'ID_Comanda',
            'ID_Produs',
            'ID_Comanda'
        )->withPivot([
            'Cantitate_Comandata',
            'Pret_Unitate',
        ]);
    }

    public function materiale()
    {
        return $this->belongsToMany(
            Material::class,
            'retetar',
            'ID_Produs',
            'ID_Material',
            'ID_Produs',
            'ID_Material'
        )->withPivot('Cantitate_Standard');
    }

    public function pasiPrelucrare()
    {
        return $this->hasMany(
            PasPrelucrare::class,
            'ID_Produs',
            'ID_Produs'
        )->orderBy('Ordine_Executie');
    }

    public function productii()
    {
        return $this->hasMany(Productie::class, 'ID_Produs', 'ID_Produs');
    }

    public function receptii()
    {
        return $this->hasMany(Receptie::class, 'ID_Produs', 'ID_Produs');
    }

    public function stoc()
    {
        return $this->hasOne(Stoc::class, 'ID_Produs', 'ID_Produs');
    }

    public function iesiri()
    {
        return $this->hasMany(
            GestionareIesire::class,
            'ID_Produs',
            'ID_Produs'
        );
    }
}