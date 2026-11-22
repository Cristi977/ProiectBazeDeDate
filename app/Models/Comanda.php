<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Comanda extends Model
{
    protected $table = 'comenzi';

    protected $primaryKey = 'ID_Comanda';

    public $timestamps = false;

    protected $fillable = [
        'ID_Manager',
        'Client',
        'Data_Inregistrare',
        'Termen_Limita',
        'Stare',
    ];

    protected $casts = [
        'ID_Manager' => 'integer',
        'Data_Inregistrare' => 'date',
        'Termen_Limita' => 'date',
    ];

    public function manager()
    {
        return $this->belongsTo(
            Utilizator::class,
            'ID_Manager',
            'ID_Utilizator'
        );
    }

    public function produse()
    {
        return $this->belongsToMany(
            Produs::class,
            'detalii_comanda',
            'ID_Comanda',
            'ID_Produs',
            'ID_Comanda',
            'ID_Produs'
        )->withPivot([
            'Cantitate_Comandata',
            'Pret_Unitate',
        ]);
    }

    public function productii()
    {
        return $this->hasMany(Productie::class, 'ID_Comanda', 'ID_Comanda');
    }

    public function receptii()
    {
        return $this->hasMany(Receptie::class, 'ID_Comanda', 'ID_Comanda');
    }

    public function iesiri()
    {
        return $this->hasMany(
            GestionareIesire::class,
            'ID_Comanda',
            'ID_Comanda'
        );
    }

    public function alerteMateriale()
    {
        return $this->hasMany(
            AlertaMaterial::class,
            'ID_Comanda',
            'ID_Comanda'
        );
    }
}