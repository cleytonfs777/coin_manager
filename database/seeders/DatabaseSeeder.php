<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
  /**
   * Seed the application's database.
   */
  public function run(): void
  {
     // User::factory(10)->create();
    
    // Ordem correta: primeiro usuários, depois categorias, por último moedas
    $this->call([
      UsersSeeder::class,
      CategoriasSeeder::class,
      CoinsSeeder::class,
    ]);
  }
}
