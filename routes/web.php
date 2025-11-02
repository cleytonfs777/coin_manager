<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CoinController;
use App\Http\Controllers\SiteController;

Route::get("/", [SiteController::class, "index"]);