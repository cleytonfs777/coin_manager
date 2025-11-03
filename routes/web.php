<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CoinController;
use App\Http\Controllers\SiteController;
use App\Http\Controllers\WalletController;

Route::get("/", [SiteController::class, "index"])->name("site.home");
Route::get("/coin/{slug}", [SiteController::class, "details"])->name("site.details");
Route::get("/categoria/{id}", [SiteController::class, "categoria"])->name("site.categoria");

Route::get("/wallet", [WalletController::class, 'walletLista'])->name('site.wallet');
Route::post("/wallet", [WalletController::class, 'adicionaWallet'])->name('site.addwallet');
Route::post("/remover", [WalletController::class, 'removerWallet'])->name('site.removerwallet');
Route::post("/atualizar", [WalletController::class, 'atualizarWallet'])->name('site.atualizarwallet');
Route::get("/limpar", [WalletController::class, 'limparWallet'])->name('site.limparwallet');