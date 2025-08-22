

resource "digitalocean_droplet" "laravel_app" {
  name   = var.droplet_name
  region = "nyc3"
  size   = "s-1vcpu-1gb" # el más barato 😅
  image  = "ubuntu-22-04-x64"

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Actualizar sistema
    apt update && apt upgrade -y

    # Paquetes base
    apt install -y software-properties-common curl zip unzip git ufw

    # Instalar PHP y extensiones
    apt install -y php php-cli php-common php-mbstring php-xml php-bcmath php-curl php-zip php-tokenizer php-json php8.3-fpm

    # Instalar Composer
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer

    # Instalar Nginx
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx

    # Configurar firewall
    ufw allow OpenSSH
    ufw allow 'Nginx Full'
    echo "y" | ufw enable

    # Clonar el proyecto Laravel
    mkdir -p /var/www/laravel
    cd /var/www
    git clone https://${var.git_token}@${var.git_repo} laravel
    cd laravel

    # Instalar dependencias de Laravel
    composer install --no-dev --optimize-autoloader

    # Permisos
    chown -R www-data:www-data /var/www/laravel
    chmod -R 775 /var/www/laravel/storage /var/www/laravel/bootstrap/cache

    # Configuración de Nginx
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

    ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
    nginx -t && systemctl restart nginx

    echo "Laravel instalado con éxito 🚀"
  EOF
}
