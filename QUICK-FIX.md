# 🚨 Resolução Rápida do Erro

O erro que você está enfrentando é comum no Pop!_OS/Ubuntu quando a extensão `php-intl` não está instalada.

## ⚡ Solução Rápida

Execute um dos comandos abaixo:

### Opção 1: Script Automático (Recomendado)
```bash
./fix-dependencies.sh
```

### Opção 2: Instalação Manual
```bash
sudo apt update
sudo apt install php-intl php-mbstring php-xml php-curl php-zip php-bcmath php-gd php-mysql
```

### Opção 3: Instalação Completa
```bash
sudo apt update
sudo apt install php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-intl php-tokenizer
```

## 🔄 Após Instalar

Execute novamente o setup:
```bash
./setup.sh
```

## 🧪 Verificar Extensões

Para verificar se as extensões estão instaladas:
```bash
php -m | grep -E "(intl|mbstring|xml|curl|zip|bcmath|gd|mysql)"
```

## 📋 Extensões Necessárias

- php-intl (Normalizer)
- php-mbstring
- php-xml
- php-curl  
- php-zip
- php-bcmath
- php-gd
- php-mysql
- php-tokenizer
- php-json