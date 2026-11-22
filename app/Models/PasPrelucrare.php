<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class PasPrelucrare extends Model
{
    protected $table = 'pasi_prelucrare';

    protected $primaryKey = 'ID_Pas';

    public $timestamps = false;

    protected $fillable = [
        'ID_Produs',
        'Ordine_Executie',
        'Nume_Proces',
        'Timp_Standard',
        'Pret_Ora_Standard',
        'Masina',
    ];

    protected $casts = [
        'ID_Produs' => 'integer',
        'Ordine_Executie' => 'integer',
        'Timp_Standard' => 'decimal:2',
        'Pret_Ora_Standard' => 'decimal:2',
    ];

    public function produs(): BelongsTo
    {
        return $this->belongsTo(
            Produs::class,
            'ID_Produs',
            'ID_Produs'
        );
    }

    public function productii(): HasMany
    {
        return $this->hasMany(
            Productie::class,
            'ID_Pas_Curent',
            'ID_Pas'
        );
    }
}