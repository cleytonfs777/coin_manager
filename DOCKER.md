# 🐳 Docker Setup - Coin Manager

Este documento contém informações específicas sobre o uso do Docker no projeto Coin Manager.

## 📋 Serviços Disponíveis

### MariaDB
- **Container:** `coin_manager_db`
- **Porta:** 3306
- **Database:** `coin_manager_db`
- **Usuário:** `coin_user`
- **Senha:** `coin_password`
- **Root Password:** `root123`

### PHPMyAdmin
- **Container:** `coin_manager_pma`
- **URL:** http://localhost:8080
- **Usuário:** `root`
- **Senha:** `root123`

## 🚀 Comandos Essenciais

### Iniciar todos os serviços:
```bash
docker-compose up -d
```

### Parar todos os serviços:
```bash
docker-compose down
```

### Parar e remover volumes (⚠️ apaga todos os dados):
```bash
docker-compose down -v
```

### Ver logs em tempo real:
```bash
# Todos os serviços
docker-compose logs -f

# Apenas MariaDB
docker-compose logs -f mariadb

# Apenas PHPMyAdmin
docker-compose logs -f phpmyadmin
```

### Verificar status dos containers:
```bash
docker-compose ps
```

## 🗄️ Gerenciamento do Banco de Dados

### Acessar MySQL via linha de comando:
```bash
# Como usuário coin_user
docker-compose exec mariadb mysql -u coin_user -p coin_manager_db

# Como root
docker-compose exec mariadb mysql -u root -p
```

### Fazer backup do banco:
```bash
docker-compose exec mariadb mysqldump -u coin_user -p coin_manager_db > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restaurar backup:
```bash
docker-compose exec -T mariadb mysql -u coin_user -p coin_manager_db < backup.sql
```

### Executar SQL direto:
```bash
docker-compose exec -T mariadb mysql -u coin_user -p coin_manager_db <<EOF
SHOW TABLES;
EOF
```

## 🔧 Configurações Avançadas

### Variáveis de Ambiente Disponíveis

Você pode customizar o `docker-compose.yml` ou criar um `docker-compose.override.yml`:

```yaml
# docker-compose.override.yml
version: '3.8'

services:
  mariadb:
    environment:
      MYSQL_ROOT_PASSWORD: sua_senha_personalizada
      MYSQL_DATABASE: seu_banco_personalizado
      MYSQL_USER: seu_usuario_personalizado
      MYSQL_PASSWORD: sua_senha_personalizada
    ports:
      - "3307:3306"  # Porta customizada
```

### Persistência de Dados

Os dados do banco são persistidos no volume `mariadb_data`. Para inspecionar:

```bash
# Listar volumes
docker volume ls

# Inspecionar volume
docker volume inspect coin_manager_mariadb_data
```

### Configuração de Memória

Para aumentar os limites de memória do MariaDB, adicione no `docker-compose.override.yml`:

```yaml
services:
  mariadb:
    command: >
      --max-connections=200
      --innodb-buffer-pool-size=256M
      --innodb-log-file-size=64M
```

## 🛠️ Troubleshooting

### Container não inicia:
```bash
# Ver logs detalhados
docker-compose logs mariadb

# Recriar container
docker-compose down
docker-compose up -d --force-recreate mariadb
```

### Porta 3306 já em uso:
```bash
# Verificar o que está usando a porta
sudo netstat -tlnp | grep :3306

# Ou alterar a porta no docker-compose.yml
ports:
  - "3307:3306"
```

### Problemas de conexão:
```bash
# Verificar se o container está rodando
docker-compose ps

# Testar conectividade
docker-compose exec mariadb mysqladmin ping -h localhost -u root -p
```

### Reset completo (⚠️ Remove todos os dados):
```bash
docker-compose down -v
docker volume prune
docker-compose up -d
```

## 📊 Monitoramento

### Ver uso de recursos:
```bash
docker stats
```

### Informações do container:
```bash
docker-compose exec mariadb mysql -u root -p -e "SHOW PROCESSLIST;"
docker-compose exec mariadb mysql -u root -p -e "SHOW ENGINE INNODB STATUS\G"
```

## 🔒 Segurança

Para produção, sempre altere as senhas padrão no arquivo `.env` ou `docker-compose.override.yml`:

```yaml
services:
  mariadb:
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_PASSWORD: ${DB_PASSWORD}
```

E configure no seu `.env`:
```env
DB_ROOT_PASSWORD=sua_senha_super_segura
DB_PASSWORD=sua_senha_segura
```

## 📝 Notas Importantes

1. **Sempre use volumes** para persistir dados importantes
2. **Faça backups regulares** do banco de dados
3. **Monitore o uso de recursos** em produção
4. **Use senhas fortes** em ambientes de produção
5. **Mantenha as imagens atualizadas** para segurança