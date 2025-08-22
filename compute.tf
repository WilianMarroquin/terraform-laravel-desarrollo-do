resource "digitalocean_droplet" "laravel_app" {
  name   = var.droplet_name
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-22-04-x64"

  user_data = <<EOF
#!/bin/bash
exec > /var/log/laravel-setup.log 2>&1
set -xe

echo "Hola Wil, el user_data SÍ se ejecutó 🚀" > /root/test.txt
EOF
}
