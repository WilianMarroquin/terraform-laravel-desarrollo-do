// main.tf
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

// variable para el token
variable "do_token" {
  type = string
}
