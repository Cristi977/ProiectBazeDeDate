<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class IntrareMaterial extends Model
{
    protected $table = 'intrari_materiale';

    protected $primaryKey = 'ID_Intrare';

    public $timestamps = false;

    protected $fillable = [
        'ID_Material',
        'ID_Utilizator',
        'Data_Intrare',
        'Furnizor',
        'Document_Intrare',
        'Cantitate',
        'Cost_Unitar',
    ];

    protected $casts = [
        'ID_Material' => 'integer',
        'ID_Utilizator' => 'integer',
        'Data_Intrare' => 'datetime',
        'Cantitate' => 'decimal:4',
        'Cost_Unitar' => 'decimal:4',
    ];

    public function material()
    {
        return $this->belongsTo(
            Material::class,
            'ID_Material',
            'ID_Material'
        );
    }

    public function utilizator()
    {
        return $this->belongsTo(
            Utilizator::class,
            'ID_Utilizator',
            'ID_Utilizator'
        );
    }

    public function consumuri()
    {
        return $this->hasMany(
            ConsumMaterial::class,
            'ID_Intrare',
            'ID_Intrare'
        );
    }
}