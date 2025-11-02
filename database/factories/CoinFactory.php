<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

use App\Models\Categoria;
use App\Models\User;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Model>
 */
class CoinFactory extends Factory
{
  /**
   * Define the model's default state.
   *
   * @return array<string, mixed>
   */
  public function definition(): array
  {
    $name = $this->faker->unique()->word(); // Nome da moeda

    // Garantir que existem usuários e categorias
    $userId = User::inRandomOrder()->first()?->id ?? User::factory()->create()->id;
    $categoriaId = Categoria::inRandomOrder()->first()?->id ?? Categoria::factory()->create()->id;

    $symbol = strtoupper($this->faker->unique()->lexify('???'));
    $imageUrl = "https://placehold.co/54x54/162447/a84105?text=" . urlencode($symbol);


    return [
      "symbol" => $symbol,
      "name" => $name,
      "price" => $this->faker->randomFloat(2, 0.01, 100000), // preço entre 0.01 e 100000
      "qtd" => $this->faker->numberBetween(1, 100), // quantidade de moedas
      "slug" => Str::slug($name),
      "is_fav" => $this->faker->boolean(30), // 30% de chance de ser favorito
      "id_user" => $userId,
      "id_categoria" => $categoriaId,
      "image" => $imageUrl,
    ];
  }
}
