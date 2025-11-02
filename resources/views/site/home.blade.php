@extends('site.layout')
@section('title','Home Cripto Buy')
@section('content')
<div class="row container">
  @foreach ($coins as $coin)
  <div class="col s12 m3">
    <div class="card">
      <div class="card-image">
        <img src="{{ $coin->image }}" alt="{{ $coin->name }}">
        <span class="card-title">{{ $coin->name }}</span>
        <a class="btn-floating halfway-fab waves-effect waves-light red"><i class="material-icons">visibility</i></a>
      </div>
      <div class="card-content">
        <p>{{ $coin->symbol }}</p>
        <p>Price: ${{ number_format($coin->price, 2, ',', '.') }}</p>
        <p>Quantity: {{ $coin->qtd }}</p>
        <p>Category: {{ $coin->categoria->name }}</p>
        <p>User: {{ $coin->user->name }}</p>
      </div>
    </div>
  </div>
    @endforeach
  </div>
  <div class="center">
    {{ $coins->links('custom.pagination') }}
  </div>  
@endsection