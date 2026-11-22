<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Rol extends Model
{
    protected $table = 'roluri';

    protected $primaryKey = 'ID_Rol';

    public $timestamps = false;

    protected $fillable = [
        'Nume',
        'Descriere',
    ];

    public function utilizatori()
    {
        return $this->hasMany(Utilizator::class, 'ID_Rol', 'ID_Rol');
    }
}