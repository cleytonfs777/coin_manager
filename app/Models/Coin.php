<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Coin extends Model
{
    use HasFactory;

    protected $fillable = [
        'symbol',
        'name',
        'price',
        'qtd',
        'slug',
        'is_fav',
        'id_user',
        'id_categoria',
        'image', // 👈 novo campo
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }

    public function categoria()
    {
        return $this->belongsTo(Categoria::class, 'id_categoria');
    }
}
