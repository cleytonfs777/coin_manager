@extends('site.layout')
@section('title','Home Cripto Buy')
@section('content')

<div class="row container">
    <div class="col s12 m6">
        <img src="{{ $coin->image }}" alt="{{ $coin->name }}" class="responsive-img center" style="width: 70%; height: auto; display: block;">
    </div>
    <div class="col s12 m6">
        <h2>Nome: {{ $coin->name }}</h2>
        <p>Price: R${{ number_format($coin->price, 2, ',', '.') }}</p>
        <p>Quantity: {{ $coin->qtd }}</p>
        <p>Category: {{ $coin->categoria->nome }}</p>

        <form action="{{ route('site.addwallet') }}" method="post" enctype="multipart/form-data">
            @csrf
            <input type="hidden" name="id" value="{{ $coin->id }}">
            <input type="hidden" name="symbol" value="{{ $coin->symbol }}">
            <input type="hidden" name="name" value="{{ $coin->name }}">
            <input type="hidden" name="price" value="{{ $coin->price }}">
            <input type="hidden" name="image" value="{{ $coin->image }}">
            <input type="hidden" name="is_fav" value="{{ $coin->is_fav }}">
            <input type="number" name="qtd" min="1" value="1" style="width: 100px; text-align: center;">
            <button type="submit" class="btn orange btn-large">Comprar</button>
        </form>
    </div>
</div>

@endsection