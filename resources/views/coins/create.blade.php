@extends('layouts.main')

@section('title', 'Criar Criptomoeda')

@section('content')
<section class="py-4">
  <div class="container">
    <h1 class="h4 mb-4">Adicionar nova criptomoeda</h1>

    <div class="card shadow-sm border-0">
      <div class="card-body">
        <form action="/coin" method="POST">
          @csrf

          {{-- Nome --}}
          <div class="mb-3">
            <label for="name" class="form-label">Nome da moeda</label>
            <input type="text" class="form-control @error('name') is-invalid @enderror"
            id="name" name="name" value="{{ old('name') }}" required>
            @error('name')
            <div class="invalid-feedback">
              {{ $message }}
            </div>
            @enderror
          </div>

          {{-- Símbolo --}}
          <div class="mb-3">
            <label for="symbol" class="form-label">Símbolo</label>
            <input type="text" class="form-control @error('symbol') is-invalid @enderror"
            id="symbol" name="symbol" value="{{ old('symbol') }}" required maxlength="10">
            @error('symbol')
            <div class="invalid-feedback">
              {{ $message }}
            </div>
            @enderror
          </div>

          {{-- Quantidade --}}
          <div class="mb-3">
            <label for="qtd" class="form-label">Quantidade</label>
            <input type="number" class="form-control @error('qtd') is-invalid @enderror"
            id="qtd" name="qtd" value="{{ old('qtd') }}" required min="0" step="1">
            @error('qtd')
            <div class="invalid-feedback">
              {{ $message }}
            </div>
            @enderror
          </div>

          {{-- Preço --}}
          <div class="mb-3">
            <label for="price" class="form-label">Preço (R$)</label>
            <input type="number" class="form-control @error('price') is-invalid @enderror"
            id="price" name="price" value="{{ old('price') }}" required min="0" step="0.01">
            @error('price')
            <div class="invalid-feedback">
              {{ $message }}
            </div>
            @enderror
          </div>

          {{-- Favorito --}}
          <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" id="isfavorite" name="isfavorite"
            value="1" {{ old('isfavorite') ? 'checked' : '' }}>
            <label for="isfavorite" class="form-check-label">Marcar como favorita</label>
          </div>

          {{-- Botões --}}
          <div class="d-flex justify-content-between">
            <a href="#" class="btn btn-outline-secondary">
              Cancelar
            </a>
            <button type="submit" class="btn btn-primary">
              <i class="bi bi-save me-1"></i> Salvar
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</section>
@endsection