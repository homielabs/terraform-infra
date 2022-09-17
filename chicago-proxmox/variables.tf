variable "login_approle_role_id" {
  description = "Vault approle role_id"
  type        = string
}

variable "login_approle_secret_id" {
  description = "Vault approle secret"
  type        = string
  sensitive   = true
}

# variable "k3s_controller_count" {
#   description = "Number of k3s controllers"
#   type        = number
#   default     = 3
# }

# variable "proxmox_nodes" {
#   description = "`proxmox`-prefixed nodes"
#   type        = list(string)
#   default     = ["proxmox1", "proxmox2", "proxmox3"]
# }
