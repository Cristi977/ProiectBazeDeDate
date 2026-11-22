<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ConsumMaterial extends Model
{
    protected $table = 'consum_materiale';

    protected $primaryKey = 'ID_Consum';

    public $timestamps = false;

    protected $fillable = [
        'ID_Executie',
        'ID_Intrare',
        'Cantitate_Consumata',
        'Cantitate_Rebut',
    ];

    protected $casts = [
        'ID_Executie' => 'integer',
        'ID_Intrare' => 'integer',
        'Cantitate_Consumata' => 'decimal:4',
        'Cantitate_Rebut' => 'decimal:4',
    ];

    public function executie()
    {
        return $this->belongsTo(
            ExecutieOperatie::class,
            'ID_Executie',
            'ID_Executie'
        );
    }

    public function intrare()
    {
        return $this->belongsTo(
            IntrareMaterial::class,
            'ID_Intrare',
            'ID_Intrare'
        );
    }
}