@extends('site.layout')
@section('title','Wallet')
@section('content')
<div class="row container">

  @if (session('success'))
    <div class="card-panel green lighten-4 green-text text-darken-4">
      {{ session('success') }}
    </div>
  @endif  
  
  @if (session('aviso'))
    <div class="card-panel yellow lighten-4 green-text text-darken-4">
      {{ session('aviso') }}
    </div>
  @endif

  @if($itens->count() == 0)
    <div class="card-panel orange lighten-4 green-text text-darken-4">
      Sua carteira está vazia !!
    </div>
  @else
    <h3>Sua carteira possui: {{ $itens->count() }} criptomoedas</h3>

  <table class="striped">
    <thead>
      <tr>
        <th></th>
        <th>Name</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Action</th>
      </tr>
    </thead>
    <tbody>
    @foreach ($itens as $item)
      <tr>
        <td><img src="{{ $item->attributes->image }}" alt="#" width="70" class="responsive-img circle"></td>
        <td>{{ $item->name }}</td>
        <td>R$ {{ number_format($item->price, 2, ',', '.') }}</td>
        <td>
        <form action="{{ route('site.atualizarwallet') }}" method="post" enctype="multipart/form-data">
          @csrf
          <input type="hidden" name="id" value="{{ $item->id }}">
          <input type="number"  min="1" style="width:40px;font-weight:900;" class="white center" name="quantity" value="{{ $item->quantity }}">
        </td>
        <td>
          <button class="btn-floating waves-effect waves-light orange"><i class="material-icons">refresh</i></button>
            </form>
            <form action="{{ route('site.removerwallet') }}" method="post" enctype="multipart/form-data">
              @csrf
              <input type="hidden" name="id" value="{{ $item->id }}">
              <button class="btn-floating waves-effect waves-light red"><i class="material-icons">delete</i></button>
            </form>
        </td>
      </tr>
    @endforeach
    </tbody>
  </table>
  <div class="card orange darken-1">
    <div class="card-content white-text">
      <span class="card-title">Valor Total</span>
      <p>R$ {{ number_format(Cart::getTotal(), 2, ',', '.') }}</p>
    </div>
  </div>
  @endif
  <div class="row container center">
    <a href="{{ route('site.home') }}" class="btn-large waves-effect waves-light blue">Continuar comprando <i class="material-icons right">arrow_back</i></a>
    <a href="{{ route('site.limparwallet') }}" class="btn-large waves-effect waves-light grey">Limpar carrinho <i class="material-icons right">clear</i></a>
    <button class="btn-large waves-effect waves-light green">Finalizar Pedido <i class="material-icons right">check</i></button>
  </div>
  </div>
  <div class="center">
  </div>  
@endsection