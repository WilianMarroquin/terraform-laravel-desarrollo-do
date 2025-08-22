terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  cloud {
    organization = "TU_ORG"
    workspaces {
      name = "nombre-del-workspace"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {
  type = string
}

# 🚀 Aquí va tu droplet (máquina virtual)
resource "digitalocean_droplet" "mi_vm" {
  image  = "ubuntu-22-04-x64" # Imagen base
  name   = "mi-dropletito"    # Nombre de la máquina
  region = "nyc3"             # Región (NYC3, SFO3, etc.)
  size   = "s-1vcpu-1gb"      # Tamaño (plan más barato)
}
