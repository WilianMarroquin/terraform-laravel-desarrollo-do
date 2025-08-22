output "droplet_ip" {
  description = "La dirección IP pública del droplet"
  value       = digitalocean_droplet.laravel_app.ipv4_address
}

output "droplet_name" {
  description = "El nombre del droplet desplegado"
  value       = digitalocean_droplet.laravel_app.name
}

