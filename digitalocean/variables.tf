variable "do_token" {
  description = "DO Token"
  type        = string
  sensitive   = true
}

variable "domain_file" {
  description = "YAML with root domain as keys and a list of subdomain fragments as the value"
  type        = string
  default     = "../general/domains.yml"
}

variable "cloud_init" {
  description = "cloud_init content for droplet"
  type        = string
  default     = "https://raw.githubusercontent.com/guppy0130/cloud-init-configs/main/digitalocean.yml"
}

variable "ssh_keys" {
  description = "List of SSH keys to get by name"
  type        = set(string)
}
