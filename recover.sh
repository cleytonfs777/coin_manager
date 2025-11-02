#!/bin/bash

# 🔄 Script de Recuperação - Coin Manager
# Este script resolve problemas quando o setup foi interrompido

echo "🔄 Recuperando configuração do Coin Manager..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se estamos no diretório correto
if [ ! -f "artisan" ]; then
    print_error "Este script deve ser executado na raiz do projeto Laravel!"
    exit 1
fi

print_step "Limpando cache do Composer..."
composer clear-cache

print_step "Removendo vendor para reinstalação limpa..."
if [ -d "vendor" ]; then
    rm -rf vendor
    print_success "Diretório vendor removido!"
fi

print_step "Removendo composer.lock para fresh install..."
if [ -f "composer.lock" ]; then
    rm composer.lock
    print_success "composer.lock removido!"
fi

print_step "Instalando dependências PHP novamente..."
if composer install --no-cache; then
    print_success "Dependências PHP instaladas com sucesso!"
else
    print_error "Falha na instalação. Verificando extensões PHP..."
    
    # Verificar extensões críticas
    required_extensions=("intl" "mbstring" "xml" "curl" "zip")
    missing=()
    
    for ext in "${required_extensions[@]}"; do
        if ! php -m | grep -i "^$ext$" > /dev/null 2>&1; then
            missing+=("$ext")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        print_error "Extensões PHP faltando: ${missing[*]}"
        print_error "Execute: ./fix-dependencies.sh"
        exit 1
    fi
    
    print_error "Erro desconhecido no Composer."
    exit 1
fi

print_step "Verificando autoload..."
if [ -f "vendor/autoload.php" ]; then
    print_success "vendor/autoload.php criado com sucesso!"
else
    print_error "vendor/autoload.php não foi criado!"
    print_step "Tentando dump-autoload..."
    composer dump-autoload
    if [ -f "vendor/autoload.php" ]; then
        print_success "Autoload regenerado!"
    else
        print_error "Falha crítica na criação do autoload!"
        exit 1
    fi
fi

print_step "Verificando arquivo .env..."
if [ ! -f ".env" ]; then
    print_warning "Arquivo .env não existe, criando..."
    if [ -f ".env.docker" ]; then
        cp .env.docker .env
        print_success "Arquivo .env criado com configurações Docker!"
    elif [ -f ".env.example" ]; then
        cp .env.example .env
        print_success "Arquivo .env criado!"
    else
        print_error "Nenhum arquivo .env de exemplo encontrado!"
        exit 1
    fi
fi

print_step "Gerando chave da aplicação..."
php artisan key:generate --force
print_success "Chave da aplicação gerada!"

print_step "Verificando conexão com banco..."
if docker ps | grep coin_manager_db > /dev/null 2>&1; then
    print_success "Container do banco está rodando!"
else
    print_warning "Container do banco não está rodando, iniciando..."
    docker-compose up -d
    print_success "Containers Docker iniciados!"
    echo "Aguardando banco ficar pronto..."
    sleep 10
fi

print_step "Executando migrações..."
if php artisan migrate --force; then
    print_success "Migrações executadas com sucesso!"
else
    print_error "Erro nas migrações. Verificando configuração..."
    
    # Verificar se pode conectar no banco
    if php artisan tinker --execute="DB::connection()->getPdo(); echo 'Conexão OK';" 2>/dev/null; then
        print_success "Conexão com banco OK, tentando migrate novamente..."
        php artisan migrate:fresh --force
        print_success "Banco recriado com sucesso!"
    else
        print_error "Não conseguiu conectar no banco. Verifique:"
        print_error "1. Se o Docker está rodando: docker-compose ps"
        print_error "2. Se as credenciais no .env estão corretas"
        print_error "3. Se o banco está acessível na porta 3306"
        exit 1
    fi
fi

print_step "Executando seeders (opcional)..."
read -p "Deseja popular o banco com dados de exemplo? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    php artisan db:seed --force
    print_success "Banco populado com dados de exemplo!"
fi

print_step "Configurando storage e cache..."
php artisan storage:link
php artisan config:cache
php artisan route:cache
php artisan view:cache
print_success "Storage e cache configurados!"

print_step "Instalando dependências Node.js..."
if command -v npm &> /dev/null; then
    npm install
    print_success "Dependências Node.js instaladas!"
    
    read -p "Deseja compilar os assets agora? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm run build
        print_success "Assets compilados!"
    fi
else
    print_warning "NPM não encontrado, pulando instalação de assets..."
fi

echo ""
print_success "🎉 Recuperação concluída com sucesso!"
echo ""
echo "Para iniciar o servidor:"
echo "php artisan serve"
echo ""
echo "Para acessar o PHPMyAdmin:"
echo "http://localhost:8080"
echo ""
print_success "Projeto restaurado e pronto para uso!"