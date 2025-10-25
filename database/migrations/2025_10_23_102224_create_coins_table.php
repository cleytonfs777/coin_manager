<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
  /**
   * Run the migrations.
   */
  public function up(): void
  {
    Schema::create("coins", function (Blueprint $table) {
      $table->id();
      $table->string("symbol");
      $table->string("name");
      $table->double("price", 10, 2);
      $table->integer("qtd");
      $table->boolean("is_fav")->default(false);
      // definição de chaves estrangeiras
      $table->unsignedBigInteger("id_user");
      $table
        ->foreign("id_user")
        ->references("id")
        ->on("users")
        ->onDelete("cascade")
        ->onUpdate("cascade");
      $table->unsignedBigInteger("id_categoria");
      $table
        ->foreign("id_categoria")
        ->references("id")
        ->on("categorias")
        ->onDelete("cascade")
        ->onUpdate("cascade");
      $table->timestamps();
    });
  }

  /**
   * Reverse the migrations.
   */
  public function down(): void
  {
    Schema::dropIfExists("coins");
  }
};
