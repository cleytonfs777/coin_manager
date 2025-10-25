<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CoinController;

Route::get("/", [CoinController::class, "index"]);