#!/bin/bash

# 🚀 Script de Configuração Automática - Coin Manager
# Este script automatiza a configuração inicial do projeto após git clone

echo "🚀 Iniciando configuração do Coin Manager..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
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

# Verificar extensões PHP necessárias
print_step "Verificando extensões PHP necessárias..."

# Lista de extensões necessárias
required_extensions=(
    "mbstring"
    "xml" 
    "curl"
    "zip"
    "intl"
    "pdo"
    "pdo_mysql"
    "bcmath"
    "gd"
    "fileinfo"
    "tokenizer"
)

missing_extensions=()

for ext in "${required_extensions[@]}"; do
    if ! php -m | grep -i "^$ext$" > /dev/null 2>&1; then
        missing_extensions+=("$ext")
    fi
done

if [ ${#missing_extensions[@]} -ne 0 ]; then
    print_warning "Extensões PHP faltando: ${missing_extensions[*]}"
    echo ""
    echo "Para instalar no Ubuntu/Pop!_OS/Debian, execute:"
    echo "sudo apt update"
    echo "sudo apt install php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-intl php-tokenizer"
    echo ""
    read -p "Deseja que o script tente instalar automaticamente? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_step "Instalando extensões PHP..."
        sudo apt update
        sudo apt install -y php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-intl php-tokenizer
        print_success "Extensões PHP instaladas!"
    else
        print_error "Por favor, instale as extensões PHP necessárias antes de continuar."
        exit 1
    fi
else
    print_success "Todas as extensões PHP necessárias estão instaladas!"
fi

# 1. Instalar dependências PHP
print_step "Instalando dependências PHP com Composer..."
if command -v composer &> /dev/null; then
    # Limpar cache do composer se houver problemas
    composer clear-cache
    
    # Tentar install primeiro
    if composer install; then
        print_success "Dependências PHP instaladas!"
    else
        print_warning "Erro no composer install, tentando composer update..."
        if composer update; then
            print_success "Dependências PHP atualizadas!"
        else
            print_error "Falha no Composer. Tentando regenerar autoload..."
            composer dump-autoload
            if [ -f "vendor/autoload.php" ]; then
                print_success "Autoload regenerado!"
            else
                print_error "Composer falhando. Verifique as extensões PHP."
                print_error "Execute: ./fix-dependencies.sh"
                exit 1
            fi
        fi
    fi
    
    # Verificar se autoload foi criado
    if [ ! -f "vendor/autoload.php" ]; then
        print_error "vendor/autoload.php não foi criado!"
        print_error "Execute primeiro: ./fix-dependencies.sh"
        exit 1
    fi
else
    print_error "Composer não encontrado! Execute primeiro: ./fix-dependencies.sh"
    exit 1
fi

# 2. Instalar dependências Node.js
print_step "Instalando dependências Node.js..."
if command -v npm &> /dev/null; then
    npm install
    print_success "Dependências Node.js instaladas!"
else
    print_warning "NPM não encontrado! Pule este passo se não usar assets frontend."
fi

# 3. Configurar arquivo .env
print_step "Configurando arquivo de ambiente..."

echo ""
echo "Escolha uma opção para configuração do banco de dados:"
echo "1) Usar Docker (MariaDB em container) - Recomendado"
echo "2) Usar banco local (configuração manual)"
echo ""
read -p "Digite sua escolha (1 ou 2): " -n 1 -r db_choice
echo ""

if [ ! -f ".env" ]; then
    if [[ $db_choice == "1" ]]; then
        cp .env.docker .env
        print_success "Arquivo .env criado com configurações Docker!"
    else
        cp .env.example .env
        print_success "Arquivo .env criado!"
    fi
else
    print_warning "Arquivo .env já existe!"
fi

# 4. Gerar chave da aplicação
print_step "Gerando chave da aplicação..."
php artisan key:generate
print_success "Chave da aplicação gerada!"

# 5. Configurar banco de dados
print_step "Configuração do banco de dados..."

if [[ $db_choice == "1" ]]; then
    echo ""
    print_step "Iniciando banco de dados com Docker..."
    
    if command -v docker-compose &> /dev/null || command -v docker &> /dev/null; then
        # Verificar se docker-compose existe, senão usar docker compose
        if command -v docker-compose &> /dev/null; then
            DOCKER_COMPOSE_CMD="docker-compose"
        else
            DOCKER_COMPOSE_CMD="docker compose"
        fi
        
        echo "Iniciando containers Docker..."
        $DOCKER_COMPOSE_CMD up -d
        
        echo "Aguardando banco de dados ficar pronto..."
        sleep 15
        
        print_success "Banco de dados Docker iniciado!"
        print_success "PHPMyAdmin disponível em: http://localhost:8080"
        print_success "Credenciais: usuário 'root', senha 'root123'"
    else
        print_error "Docker não encontrado! Instale o Docker primeiro ou escolha a opção 2."
        exit 1
    fi
else
    echo ""
    echo "Configure manualmente as seguintes variáveis no arquivo .env:"
    echo "- DB_DATABASE=coin_manager_db"
    echo "- DB_USERNAME=seu_usuario" 
    echo "- DB_PASSWORD=sua_senha"
    echo ""
    read -p "Pressione ENTER após configurar o banco de dados no .env..."
fi

# 6. Executar migrações
print_step "Executando migrações do banco de dados..."
if php artisan migrate --force; then
    print_success "Migrações executadas com sucesso!"
else
    print_error "Erro ao executar migrações! Verifique a configuração do banco."
    exit 1
fi

# 7. Executar seeders (opcional)
echo ""
read -p "Deseja popular o banco com dados de exemplo? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_step "Executando seeders..."
    php artisan db:seed
    print_success "Banco populado com dados de exemplo!"
fi

# 8. Criar link simbólico para storage
print_step "Criando link simbólico para storage..."
php artisan storage:link
print_success "Link simbólico criado!"

# 9. Configurar permissões
print_step "Configurando permissões..."
chmod -R 755 storage bootstrap/cache
print_success "Permissões configuradas!"

# 10. Limpar e configurar cache
print_step "Configurando cache..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
print_success "Cache configurado!"

# 11. Compilar assets (opcional)
echo ""
read -p "Deseja compilar os assets frontend agora? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v npm &> /dev/null; then
        print_step "Compilando assets..."
        npm run build
        print_success "Assets compilados!"
    else
        print_warning "NPM não encontrado! Pule a compilação de assets."
    fi
fi

echo ""
echo "🎉 Configuração concluída com sucesso!"
echo ""
echo "Para iniciar o servidor de desenvolvimento, execute:"
echo "php artisan serve"
echo ""
echo "O projeto estará disponível em: http://localhost:8000"
echo ""
print_success "Coin Manager está pronto para uso!"