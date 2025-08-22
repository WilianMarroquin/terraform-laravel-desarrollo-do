resource "digitalocean_droplet" "laravel_app" {
  name   = var.droplet_name
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-22-04-x64"

  user_data = <<-EOF
    #!/bin/bash
    exec > >(tee -a /var/log/user-data.log) 2>&1
    set -xe

    log() {
      echo "[SETUP] $1"
    }

    log "Actualizando sistema..."
    apt update && apt upgrade -y

    log "Instalando paquetes base..."
    apt install -y software-properties-common curl zip unzip git ufw

    log "Instalando PHP y extensiones..."
    apt install -y php php-cli php-common php-mbstring php-xml php-bcmath php-curl php-zip php-tokenizer php-json php8.3-fpm

    log "Instalando Composer..."
    curl -sS https://getcomposer.org/installer | php || { log "ERROR instalando Composer"; exit 1; }
    mv composer.phar /usr/local/bin/composer

    log "Instalando Nginx..."
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx

    log "Configurando firewall..."
    ufw allow OpenSSH
    ufw allow 'Nginx Full'
    echo "y" | ufw enable

    log "Clonando proyecto Laravel..."
    mkdir -p /var/www/laravel
    cd /var/www
    git clone https://${var.git_token}@${var.git_repo} laravel || { log "ERROR clonando el repositorio"; exit 1; }
    cd laravel

    log "Instalando dependencias de Laravel..."
    composer install --no-dev --optimize-autoloader || { log "ERROR instalando dependencias"; exit 1; }

    log "Configurando permisos..."
    chown -R www-data:www-data /var/www/laravel
    chmod -R 775 /var/www/laravel/storage /var/www/laravel/bootstrap/cache

    log "Creando configuración de Nginx..."
    cat > /etc/nginx/sites-available/laravel <<NGINX_CONF
    server {
        listen 80;
        server_name _;
        root /var/www/laravel/public;

        index index.php index.html;

        location / {
            try_files \$uri \$uri/ /index.php?\$query_string;
        }

        location ~ \.php\$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
            include fastcgi_params;
        }

        location ~ /\.ht {
            deny all;
        }
    }
    NGINX_CONF

    ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/ || true
    nginx -t && systemctl restart nginx

    log "✅ Laravel instalado con éxito 🚀"
  EOF
}
