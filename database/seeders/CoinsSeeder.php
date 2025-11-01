<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Coin; // 👈 Adicione esta linha

class CoinsSeeder extends Seeder
{
    public function run(): void
    {
        Coin::factory(10)->create();
    }
}
