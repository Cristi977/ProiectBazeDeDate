<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AlertaMaterial extends Model
{
    protected $table = 'alerte_materiale';

    protected $primaryKey = 'ID_Alerta';

    public $timestamps = false;

    protected $fillable = [
        'ID_Material',
        'ID_Comanda',
        'Data_Generare',
        'Cantitate_Necesara',
        'Cantitate_Disponibila',
        'Stare',
        'Mesaj',
        'Data_Rezolvare',
        'ID_Utilizator_Rezolvare',
    ];

    protected $casts = [
        'ID_Material' => 'integer',
        'ID_Comanda' => 'integer',
        'Data_Generare' => 'datetime',
        'Cantitate_Necesara' => 'decimal:4',
        'Cantitate_Disponibila' => 'decimal:4',
        'Data_Rezolvare' => 'datetime',
        'ID_Utilizator_Rezolvare' => 'integer',
    ];

    public function material()
    {
        return $this->belongsTo(
            Material::class,
            'ID_Material',
            'ID_Material'
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

    public function utilizatorRezolvare()
    {
        return $this->belongsTo(
            Utilizator::class,
            'ID_Utilizator_Rezolvare',
            'ID_Utilizator'
        );
    }
}