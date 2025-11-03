<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Darryldecode\Cart\Facades\CartFacade as Cart;

class WalletController extends Controller
{
    public function walletLista()
    {
        $itens = Cart::getContent();
        return view('site.wallet', compact('itens'));
    }

    public function adicionaWallet(Request $request){
        Cart::add([
            "id" => $request->id,
            "name" => $request->name,
            "price" => $request->price,
            "quantity" => abs($request->qtd), // O pacote Cart espera "quantity"
            "attributes" => [
                "symbol" => $request->symbol,
                "is_fav" => $request->is_fav,
                "image" => $request->image,
            ],
        ]);

        return redirect()->route('site.wallet')->with('success', 'Criptomoeda adicionada a carteira com sucesso!!');
    }
    
    public function removerwallet(Request $request)
    {
        Cart::remove($request->id);
        return redirect()->route('site.wallet')->with('success', 'Criptomoeda removida da carteira com sucesso!!');

    }    
    
    
    public function atualizarWallet(Request $request)
    {
        Cart::update($request->id, [
            'quantity' => [
                'relative' => false,
                'value' => abs($request->quantity)
            ]
        ]);
        return redirect()->route('site.wallet')->with('success', 'Criptomoeda atualizada com sucesso!!');

    }
    
    public function limparWallet()
    {
        Cart::clear();
        return redirect()->route('site.wallet');

    }



}
