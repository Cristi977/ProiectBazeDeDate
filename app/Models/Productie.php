<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Productie extends Model
{
    protected $table = 'productie';

    protected $primaryKey = 'ID_Productie';

    public $timestamps = false;

    protected $fillable = [
        'ID_Comanda',
        'ID_Produs',
        'ID_Pas_Curent',
        'Cantitate_Planificata',
        'Stare',
        'Data_Inceput',
        'Data_Finalizare',
    ];

    protected $casts = [
        'ID_Comanda' => 'integer',
        'ID_Produs' => 'integer',
        'ID_Pas_Curent' => 'integer',
        'Cantitate_Planificata' => 'integer',
        'Data_Inceput' => 'datetime',
        'Data_Finalizare' => 'datetime',
    ];

    public function comanda()
    {
        return $this->belongsTo(
            Comanda::class,
            'ID_Comanda',
            'ID_Comanda'
        );
    }

    public function produs()
    {
        return $this->belongsTo(Produs::class, 'ID_Produs', 'ID_Produs');
    }

    public function pasCurent()
    {
        return $this->belongsTo(
            PasPrelucrare::class,
            'ID_Pas_Curent',
            'ID_Pas'
        );
    }

    public function executii()
    {
        return $this->hasMany(
            ExecutieOperatie::class,
            'ID_Productie',
            'ID_Productie'
        );
    }

    public function receptii()
    {
        return $this->hasMany(
            Receptie::class,
            'ID_Productie',
            'ID_Productie'
        );
    }
}