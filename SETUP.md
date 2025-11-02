# 🚀 Configuração do Projeto Coin Manager

Este documento contém o passo a passo completo para configurar o projeto **Coin Manager** após fazer um `git clone`.

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **PHP** >= 8.2
- **Composer** (gerenciador de dependências PHP)
- **Node.js** e **npm** (para assets frontend)
- **Docker** e **Docker Compose** (recomendado para banco de dados)
- **MariaDB/MySQL** (alternativa local ao Docker)
- **Git**

## 🔧 Passo a Passo da Configuração

### Método 0: Resolver Dependências (Se necessário)

Se encontrar erros relacionados a extensões PHP ou dependências:
```bash
./fix-dependencies.sh
```

### Método 1: Configuração Automática (Recomendado)

Execute o script de configuração automática:
```bash
./setup.sh
```

O script irá:
- Instalar todas as dependências
- Configurar o ambiente automaticamente
- Dar opção de usar Docker para o banco de dados
- Executar migrações e seeders
- Configurar permissões e cache

### Método 2: Configuração Manual

### 1. Clone do Repositório
```bash
git clone <url-do-repositorio>
cd coin_manager
```

### 2. Instalação das Dependências PHP
```bash
composer install
```

### 3. Instalação das Dependências Node.js
```bash
npm install
```

### 4. Configuração do Banco de Dados com Docker (Recomendado)

#### 4.1. Iniciar os containers:
```bash
docker-compose up -d
```

Este comando irá:
- Criar um container MariaDB na porta 3306
- Criar um container PHPMyAdmin na porta 8080
- Configurar automaticamente o banco `coin_manager_db`
- Criar o usuário `coin_user` com senha `coin_password`

#### 4.2. Copiar o arquivo de ambiente Docker:
```bash
cp .env.docker .env
```

#### 4.3. Gerar a chave da aplicação:
```bash
php artisan key:generate
```

**🎉 Pronto! O banco já está configurado e pronto para uso.**

**Credenciais do banco (já configuradas no .env.docker):**
- Host: 127.0.0.1
- Porta: 3306
- Database: coin_manager_db
- Usuário: coin_user
- Senha: coin_password

**PHPMyAdmin:** http://localhost:8080
- Usuário: root
- Senha: root123

### 5. Configuração Alternativa - Banco Local

Se preferir usar um banco local em vez do Docker:

### 5. Configuração Alternativa - Banco Local

Se preferir usar um banco local em vez do Docker:

#### 5.1. Copiar o arquivo de exemplo:
```bash
cp .env.example .env
```

### 6. Executar Migrações e Seeders

#### 6.1. Executar as migrações:
```bash
php artisan key:generate
```

#### 5.3. Configurar as variáveis de ambiente no arquivo `.env`:

Abra o arquivo `.env` e configure as seguintes variáveis conforme seu ambiente:

```env
# Configurações da Aplicação
APP_NAME="Coin Manager"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

# Configurações do Banco de Dados
DB_CONNECTION=mariadb
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=coin_manager_db
DB_USERNAME=seu_usuario
DB_PASSWORD=sua_senha
```

**⚠️ Importante:** Altere os valores `DB_DATABASE`, `DB_USERNAME` e `DB_PASSWORD` conforme sua configuração local.

#### 5.4. Criar o banco de dados:
Acesse seu MariaDB/MySQL e execute:
```sql
CREATE DATABASE coin_manager_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 6. Executar Migrações e Seeders
```bash
php artisan migrate
```

#### 6.2. Popular o banco com dados iniciais (opcional):
```bash
php artisan db:seed
```

### 7. Configurações de Storage e Cache

### 7. Configurações de Storage e Cache

#### 7.1. Criar link simbólico para storage:
```bash
php artisan storage:link
```

#### 7.2. Limpar e configurar cache:
```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### 8. Compilar Assets Frontend
```bash
npm run build
```

### 9. Iniciar o Servidor de Desenvolvimento
```bash
php artisan serve
```

O projeto estará disponível em: `http://localhost:8000`

## 🔄 Comandos Úteis para Desenvolvimento

### Comandos Laravel:

### Assets em modo de desenvolvimento (watch):
```bash
npm run dev
```

### Limpar todas as caches:
```bash
php artisan optimize:clear
```

### Recriar o banco de dados:
```bash
php artisan migrate:fresh --seed
```

### Verificar rotas:
```bash
php artisan route:list
```

### Executar testes:
```bash
php artisan test
```

### Comandos Docker:

### Iniciar containers:
```bash
docker-compose up -d
```

### Parar containers:
```bash
docker-compose down
```

### Ver logs do banco:
```bash
docker-compose logs mariadb
```

### Acessar o container do banco:
```bash
docker-compose exec mariadb mysql -u coin_user -p coin_manager_db
```

### Backup do banco:
```bash
docker-compose exec mariadb mysqldump -u coin_user -p coin_manager_db > backup.sql
```

### Restaurar backup:
```bash
docker-compose exec -T mariadb mysql -u coin_user -p coin_manager_db < backup.sql
```

## 📁 Estrutura do Projeto

- **app/Models/**: Modelos Eloquent (User, Coin, Categoria)
- **app/Http/Controllers/**: Controladores da aplicação
- **database/migrations/**: Arquivos de migração do banco
- **database/seeders/**: Seeders para popular o banco
- **resources/views/**: Templates Blade
- **routes/web.php**: Definição das rotas web
- **public/**: Arquivos públicos (CSS, JS, imagens)

## 🛠️ Troubleshooting

### Erro "Class Normalizer not found":
```bash
# Instalar extensão intl
sudo apt install php-intl

# Ou executar o script de correção
./fix-dependencies.sh
```

### Erro de extensões PHP:
```bash
# Ubuntu/Pop!_OS/Debian
sudo apt update
sudo apt install php php-cli php-mbstring php-xml php-curl php-zip php-intl php-pdo php-mysql php-bcmath php-gd php-fileinfo php-tokenizer

# Ou usar o script automático
./fix-dependencies.sh
```

### Erro de permissão:
```bash
sudo chown -R $USER:$USER .
chmod -R 755 storage bootstrap/cache
```

### Erro de cache:
```bash
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear
```

### Erro de autoload:
```bash
composer dump-autoload
```

## 📝 Notas Importantes

1. **Nunca commite o arquivo `.env`** - ele contém informações sensíveis
2. **Sempre rode `composer install`** após fazer pull de novas alterações
3. **Execute `php artisan migrate`** se houver novas migrações
4. **Rode `npm install` e `npm run build`** se houver mudanças nos assets

## 🆘 Precisa de Ajuda?

Se encontrar algum problema durante a configuração:

1. Verifique se todos os pré-requisitos estão instalados
2. Confirme se as configurações do banco de dados estão corretas
3. Verifique as permissões dos diretórios `storage` e `bootstrap/cache`
4. Consulte os logs em `storage/logs/laravel.log`

---

**✅ Projeto configurado com sucesso!** 

Agora você pode começar a desenvolver no Coin Manager! 🎉