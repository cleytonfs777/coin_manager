<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
  <meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>@yield('title')</title>
<meta name="description" content="Organize ganhos, metas e gastos da sua renda extra de forma simples." />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
<link
href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet"
integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
crossorigin="anonymous">
<link rel="stylesheet" href="/css/style.css" />
</head>
<body>
<!-- Header -->
<header class="site-header">
<div class="container header-wrap">
<a class="brand" href="#">
<span class="brand-mark" aria-hidden="true">₿</span>
<span class="brand-name">Gestor de Renda <strong>Criptomoedas</strong></span>
</a>

<nav class="nav" aria-label="Primária">
<a href="/coin/create">Criar cripto</a>
</nav>
</div>
</header>
@yield('content')
<script
src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
crossorigin="anonymous"></script>
</body>
</html>