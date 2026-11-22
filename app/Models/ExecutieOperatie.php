<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ExecutieOperatie extends Model
{
    protected $table = 'executii_operatii';

    protected $primaryKey = 'ID_Executie';

    public $timestamps = false;

    protected $fillable = [
        'ID_Productie',
        'ID_Produs',
        'ID_Pas',
        'ID_Operator',
        'Data_Raportare',
        'Timp_Prelucrare',
        'Tarif_Orar_Aplicat',
        'Cantitate_Buna',
        'Rebuturi',
        'Observatii',
    ];

    protected $casts = [
        'ID_Productie' => 'integer',
        'ID_Produs' => 'integer',
        'ID_Pas' => 'integer',
        'ID_Operator' => 'integer',
        'Data_Raportare' => 'datetime',
        'Timp_Prelucrare' => 'decimal:4',
        'Tarif_Orar_Aplicat' => 'decimal:4',
        'Cantitate_Buna' => 'integer',
        'Rebuturi' => 'integer',
    ];

    public function productie()
    {
        return $this->belongsTo(
            Productie::class,
            'ID_Productie',
            'ID_Productie'
        );
    }

    public function produs()
    {
        return $this->belongsTo(Produs::class, 'ID_Produs', 'ID_Produs');
    }

    public function pas()
    {
        return $this->belongsTo(PasPrelucrare::class, 'ID_Pas', 'ID_Pas');
    }

    public function operator()
    {
        return $this->belongsTo(
            Utilizator::class,
            'ID_Operator',
            'ID_Utilizator'
        );
    }

    public function consumuri()
    {
        return $this->hasMany(
            ConsumMaterial::class,
            'ID_Executie',
            'ID_Executie'
        );
    }
}