output "droplet_ip" {
  description = "La dirección IP pública del droplet"
  value       = digitalocean_droplet.mi_droplet.ipv4_address
}

output "droplet_name" {
  description = "El nombre del droplet desplegado"
  value       = digitalocean_droplet.mi_droplet.name
}

output "droplet_status" {
  description = "Estado del droplet (active, off, archive)"
  value       = digitalocean_droplet.mi_droplet.status
}
