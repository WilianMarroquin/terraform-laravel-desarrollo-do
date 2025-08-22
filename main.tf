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
      name = "terraform-laravel-desarrollo-do"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}
