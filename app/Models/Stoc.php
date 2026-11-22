<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Stoc extends Model
{
    protected $table = 'stoc';

    protected $primaryKey = 'ID_Produs';

    public $incrementing = false;

    public $timestamps = false;

    protected $fillable = [
        'ID_Produs',
        'Cantitate',
    ];

    protected $casts = [
        'ID_Produs' => 'integer',
        'Cantitate' => 'integer',
    ];

    public function produs(): BelongsTo
    {
        return $this->belongsTo(
            Produs::class,
            'ID_Produs',
            'ID_Produs'
        );
    }
}