<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Material extends Model
{
    protected $table = 'materiale';

    protected $primaryKey = 'ID_Material';

    public $timestamps = false;

    protected $fillable = [
        'Cod_Material',
        'Nume',
        'Unitate_Masura',
        'Prag_Minim',
        'Activ',
    ];

    protected $casts = [
        'Prag_Minim' => 'decimal:4',
        'Activ' => 'boolean',
    ];

    public function produse()
    {
        return $this->belongsToMany(
            Produs::class,
            'retetar',
            'ID_Material',
            'ID_Produs',
            'ID_Material',
            'ID_Produs'
        )->withPivot('Cantitate_Standard');
    }

    public function intrari()
    {
        return $this->hasMany(
            IntrareMaterial::class,
            'ID_Material',
            'ID_Material'
        );
    }

    public function consumuri()
    {
        return $this->hasManyThrough(
            ConsumMaterial::class,
            IntrareMaterial::class,
            'ID_Material',
            'ID_Intrare',
            'ID_Material',
            'ID_Intrare'
        );
    }

    public function alerte()
    {
        return $this->hasMany(
            AlertaMaterial::class,
            'ID_Material',
            'ID_Material'
        );
    }
}