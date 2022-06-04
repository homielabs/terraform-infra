terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "ssh_keys" {
  for_each = var.ssh_keys
  name     = each.value
}

data "http" "cloud_init_from_network" {
  url = var.cloud_init
}

resource "digitalocean_droplet" "master" {
  image      = "ubuntu-22-04-x64"
  size       = "s-1vcpu-1gb"
  region     = "sfo3"
  name       = "master"
  monitoring = true
  ssh_keys = flatten([
    for name, key_data in data.digitalocean_ssh_key.ssh_keys : key_data.id
  ])
  user_data = data.http.cloud_init_from_network.response_body
}

# get data from disk
locals {
  domains = yamldecode(file(var.domain_file))
  # generates a list of {domain, subdomain} maps
  domain_map = flatten([
    for domain, subdomains in local.domains : [
      for subdomain in subdomains : {
        subdomain : subdomain
        domain : domain
      }
    ]
  ])
}

resource "digitalocean_domain" "domains" {
  for_each = local.domains

  name       = each.key
  ip_address = digitalocean_droplet.master.ipv4_address
}

resource "digitalocean_record" "records" {
  # for each URL, map to corresponding {domain, subdomain} object
  for_each = {
    for item in local.domain_map : "${item.subdomain}.${item.domain}" => item
  }

  domain = digitalocean_domain.domains[each.value.domain].name
  # this should really be the prefix (plex in plex.inthemainfra.me)
  name  = each.value.subdomain
  type  = "A"
  value = digitalocean_droplet.master.ipv4_address
}
