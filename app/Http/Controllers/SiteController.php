<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Coin;
use App\Models\Categoria;

class SiteController extends Controller
{
    public function index()
  {
    $coins = Coin::paginate(3);
    return view("site.home", compact("coins"));
  }

  public function details($slug)
  {
    $coin = Coin::where('slug', $slug)->first();

    return view('site.details', compact('coin'));
  }
  
  public function categoria($id)
  {
    $categoria = Categoria::find($id);
    $coins = Coin::where('id_categoria', $id)->paginate(3);

    return view('site.categoria', compact('coins', 'categoria'));
  }
}
