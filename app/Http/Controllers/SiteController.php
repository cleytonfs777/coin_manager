<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Coin;

class SiteController extends Controller
{
    public function index()
  {
    $coins = Coin::paginate(3);
    return view("site.home", compact("coins"));
  }
}
