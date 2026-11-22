<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Utilizator extends Model
{
    protected $table = 'utilizatori';

    protected $primaryKey = 'ID_Utilizator';

    public $timestamps = false;

    protected $fillable = [
        'ID_Rol',
        'Nume',
        'Email',
        'Parola_Hash',
        'Activ',
    ];

    protected $hidden = [
        'Parola_Hash',
    ];

    protected $casts = [
        'ID_Rol' => 'integer',
        'Activ' => 'boolean',
        'Data_Creare' => 'datetime',
    ];

    public function rol()
    {
        return $this->belongsTo(Rol::class, 'ID_Rol', 'ID_Rol');
    }

    public function comenziGestionate()
    {
        return $this->hasMany(
            Comanda::class,
            'ID_Manager',
            'ID_Utilizator'
        );
    }

    public function produseDefinite()
    {
        return $this->hasMany(
            Produs::class,
            'ID_Inginer',
            'ID_Utilizator'
        );
    }

    public function executii()
    {
        return $this->hasMany(
            ExecutieOperatie::class,
            'ID_Operator',
            'ID_Utilizator'
        );
    }

    public function intrariMateriale()
    {
        return $this->hasMany(
            IntrareMaterial::class,
            'ID_Utilizator',
            'ID_Utilizator'
        );
    }

    public function receptii()
    {
        return $this->hasMany(
            Receptie::class,
            'ID_Utilizator',
            'ID_Utilizator'
        );
    }

    public function iesiri()
    {
        return $this->hasMany(
            GestionareIesire::class,
            'ID_Utilizator',
            'ID_Utilizator'
        );
    }

    public function alerteRezolvate()
    {
        return $this->hasMany(
            AlertaMaterial::class,
            'ID_Utilizator_Rezolvare',
            'ID_Utilizator'
        );
    }
}