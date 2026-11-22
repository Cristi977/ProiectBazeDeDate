<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class GestionareIesire extends Model
{
    protected $table = 'gestionare_iesiri';

    protected $primaryKey = 'ID_Iesire';

    public $timestamps = false;

    protected $fillable = [
        'ID_Comanda',
        'ID_Produs',
        'ID_Utilizator',
        'Data_Iesire',
        'Cantitate',
        'Document_Iesire',
    ];

    protected $casts = [
        'ID_Comanda' => 'integer',
        'ID_Produs' => 'integer',
        'ID_Utilizator' => 'integer',
        'Data_Iesire' => 'datetime',
        'Cantitate' => 'integer',
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

    public function stoc()
    {
        return $this->belongsTo(Stoc::class, 'ID_Produs', 'ID_Produs');
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