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

    return [
      "symbol" => $this->faker->unique()->regexify("[A-Z]{3}"),
      "name" => $name,
      "price" => $this->faker->randomFloat(2, 0.01, 100000), // preço entre 0.01 e 100000
      "qtd" => $this->faker->numberBetween(1, 100), // quantidade de moedas
      "slug" => Str::slug($name),
      "is_fav" => $this->faker->boolean(30), // 30% de chance de ser favorito
      "id_user" => User::pluck("id")->random(),
      "id_categoria" => Categoria::pluck("id")->random(),
    ];
  }
}
