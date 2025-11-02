#!/bin/bash

# 🔧 Script de Resolução de Dependências - Coin Manager
# Este script resolve problemas comuns de dependências no Ubuntu/Pop!_OS/Debian

echo "🔧 Resolvendo dependências do sistema..."

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

# Detectar distribuição
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
fi

print_step "Sistema detectado: $OS $VER"

# Verificar se é Ubuntu/Debian baseado
if [[ $OS == *"Ubuntu"* ]] || [[ $OS == *"Pop"* ]] || [[ $OS == *"Debian"* ]]; then
    print_step "Atualizando repositórios..."
    sudo apt update

    print_step "Instalando dependências básicas..."
    sudo apt install -y \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release \
        curl \
        wget \
        git \
        unzip

    # Verificar versão do PHP
    if command -v php &> /dev/null; then
        PHP_VERSION=$(php -v | head -n 1 | cut -d " " -f 2 | cut -d "." -f1,2)
        print_success "PHP $PHP_VERSION encontrado"
    else
        print_warning "PHP não encontrado, instalando..."
        sudo apt install -y php php-cli
        PHP_VERSION=$(php -v | head -n 1 | cut -d " " -f 2 | cut -d "." -f1,2)
    fi

    print_step "Instalando extensões PHP..."
    sudo apt install -y \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-tokenizer \
        php${PHP_VERSION}-json \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-dom

    # Verificar Composer
    if ! command -v composer &> /dev/null; then
        print_step "Instalando Composer..."
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
        sudo chmod +x /usr/local/bin/composer
        print_success "Composer instalado!"
    else
        print_success "Composer já está instalado"
    fi

    # Verificar Node.js e npm
    if ! command -v node &> /dev/null; then
        print_step "Instalando Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs
        print_success "Node.js instalado!"
    else
        NODE_VERSION=$(node -v)
        print_success "Node.js $NODE_VERSION já está instalado"
    fi

    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        print_step "Instalando Docker..."
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        sudo usermod -aG docker $USER
        print_success "Docker instalado! (Faça logout/login para usar sem sudo)"
    else
        DOCKER_VERSION=$(docker --version)
        print_success "Docker já está instalado: $DOCKER_VERSION"
    fi

    # Verificar Docker Compose
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null 2>&1; then
        print_step "Instalando Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        print_success "Docker Compose instalado!"
    else
        if command -v docker-compose &> /dev/null; then
            COMPOSE_VERSION=$(docker-compose --version)
        else
            COMPOSE_VERSION=$(docker compose version)
        fi
        print_success "Docker Compose já está instalado: $COMPOSE_VERSION"
    fi

    print_step "Verificando extensões PHP instaladas..."
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
        "json"
        "dom"
    )

    missing_extensions=()
    for ext in "${required_extensions[@]}"; do
        if ! php -m | grep -i "^$ext$" > /dev/null 2>&1; then
            missing_extensions+=("$ext")
        fi
    done

    if [ ${#missing_extensions[@]} -eq 0 ]; then
        print_success "Todas as extensões PHP necessárias estão instaladas!"
    else
        print_error "Extensões ainda faltando: ${missing_extensions[*]}"
        print_warning "Tente reinstalar o PHP: sudo apt install --reinstall php${PHP_VERSION}"
    fi

else
    print_error "Sistema não suportado por este script. Suporte apenas para Ubuntu/Pop!_OS/Debian."
    echo "Para outras distribuições:"
    echo "- Instale PHP >= 8.2 com extensões: mbstring, xml, curl, zip, intl, pdo, pdo_mysql, bcmath, gd, fileinfo, tokenizer"
    echo "- Instale Composer: https://getcomposer.org/download/"
    echo "- Instale Node.js: https://nodejs.org/"
    echo "- Instale Docker: https://docs.docker.com/engine/install/"
    exit 1
fi

echo ""
print_success "🎉 Todas as dependências foram verificadas/instaladas!"
echo ""
echo "Agora você pode executar:"
echo "./setup.sh"
echo ""
print_warning "IMPORTANTE: Se instalou o Docker, faça logout/login para usar sem sudo"