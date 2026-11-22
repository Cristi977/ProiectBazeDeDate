<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Receptie extends Model
{
    protected $table = 'receptie';

    protected $primaryKey = 'ID_Receptie';

    public $timestamps = false;

    protected $fillable = [
        'ID_Productie',
        'ID_Comanda',
        'ID_Produs',
        'ID_Utilizator',
        'Data_Receptie',
        'Cantitate',
    ];

    protected $casts = [
        'ID_Productie' => 'integer',
        'ID_Comanda' => 'integer',
        'ID_Produs' => 'integer',
        'ID_Utilizator' => 'integer',
        'Data_Receptie' => 'datetime',
        'Cantitate' => 'integer',
    ];

    public function productie()
    {
        return $this->belongsTo(
            Productie::class,
            'ID_Productie',
            'ID_Productie'
        );
    }

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

    public function utilizator()
    {
        return $this->belongsTo(
            Utilizator::class,
            'ID_Utilizator',
            'ID_Utilizator'
        );
    }
}