<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\Coin;

class CoinController extends Controller
{
  public function index()
  {
    $coins = Coin::paginate(6);
    return view("site.home", compact("coins"));
  }
}
