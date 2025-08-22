variable "git_repo" {
  description = "Repositorio Git donde está el proyecto Laravel"
  type        = string
}

variable "git_token" {
  description = "Token de acceso para clonar el repositorio privado"
  type        = string
  sensitive   = true
}

# Token de DO
variable "do_token" {
  description = "Token de acceso a DigitalOcean"
  type        = string
  sensitive   = true
}

# Nombre del Droplet iniciando la depuración.
variable "droplet_name" {
  description = "Nombre del servidor"
  type        = string
  default     = "mi-droplet-barato"
}
