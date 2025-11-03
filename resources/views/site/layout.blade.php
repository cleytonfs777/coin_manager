<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>@yield('title','Sistema Coin')</title>
  <!-- Compiled and minified CSS -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

</head>
<body>
  <!-- Dropdown Structure -->
  <ul id='dropdown1' class='dropdown-content'>
    
    @foreach ($categoriasMenu as $categoriaM )
      <li><a href="{{ route('site.categoria', $categoriaM->id) }}">{{ $categoriaM->nome }}</a></li>
    @endforeach
    
  </ul>

  <nav class='blue'>
    <div class="nav-wrapper container">
      <a href="{{ route('site.home') }}" class="brand-logo center">Cripto System</a>
      <ul id="nav-mobile" class="right">
        <li><a href="{{ route('site.home') }}">Home</a></li>
        <li><a class='dropdown-trigger' href='#' data-target='dropdown1'>Categorias<i class="material-icons right">expand_more</i></a></li>
        <li><a href="{{ route('site.wallet') }}">Wallet <span class="new badge green" data-badge-caption="">{{ Cart::getContent()->count()}}</span></a></li>
      </ul>
    </div>
  </nav>

  @yield('content')
  <!-- Compiled and minified JavaScript -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      var elems = document.querySelectorAll('.dropdown-trigger');
      var instances = M.Dropdown.init(elems, {
        coverTrigger: false,
        constrainWidth: false
      });
    });
      
  </script>
</body>
</html>