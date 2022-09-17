terraform {
  # backend "s3" {
  #   bucket   = "terraform"
  #   key      = "terraform"
  #   endpoint = "proxmox1.home"
  #   region   = "us-east-1"
  #   skip_credentials_validation = true
  # }
  required_providers {
    proxmox = {
      source  = "TheGameProfi/proxmox"
      version = "2.9.15"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "3.23.0"
    }
  }
}

provider "vault" {
  address = "https://vault.inthemainfra.me"
  auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id   = var.login_approle_role_id
      secret_id = var.login_approle_secret_id
    }
  }
}

data "vault_kv_secret_v2" "vault_proxmox_chicago_credentials" {
  mount = "chicago"
  name  = "proxmox/terraform-prov@pve"
}

provider "proxmox" {
  # Configuration options
  pm_api_url      = data.vault_kv_secret_v2.vault_proxmox_chicago_credentials.data["url"]
  pm_user         = data.vault_kv_secret_v2.vault_proxmox_chicago_credentials.data["username"]
  pm_password     = data.vault_kv_secret_v2.vault_proxmox_chicago_credentials.data["password"]
  pm_tls_insecure = true
}

# a node can be either a controller or an agent, and it doesn't make a
# distinction as to which is which
# resource "proxmox_vm_qemu" "k3s-nodes" {
#   count            = var.k3s_controller_count
#   name             = "k3s-node-${count.index}"
#   desc             = "k3s node ${count.index}"
#   automatic_reboot = true
#   # element will automatically modulo on the list
#   target_node = element(var.proxmox_nodes, count.index)
#   pxe         = true
#   boot        = "order=net0;scsi0"
#   agent       = 1
#   bios        = "ovmf"
#   scsihw      = "virtio-scsi-single"

#   disk {
#     backup  = false
#     discard = "on"
#     size    = "10G"
#     ssd     = 1
#     storage = "local-lvm"
#     type    = "scsi"
#   }

#   cpu    = "host"
#   cores  = 2
#   memory = 2 * 1024 # in MB, so *1024 to GB

#   network {
#     bridge    = "vmbr0"
#     firewall  = false
#     link_down = false
#     model     = "virtio"
#   }
# }

resource "proxmox_vm_qemu" "k3s-node-2" {
  name        = "k3s-node-2"
  desc        = "k3s node 2"
  target_node = "proxmox2"
  pxe         = true
  boot        = "order=scsi0;net0"
  agent       = 1
  bios        = "ovmf"
  scsihw      = "virtio-scsi-single"
  cpu         = "host"
  cores       = 14
  memory      = 12288
  onboot      = true

  disk {
    backup  = false
    discard = "on"
    size    = "25G"
    ssd     = 1
    storage = "local-lvm"
    type    = "scsi"
  }

  network {
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "virtio"
  }
}

resource "proxmox_vm_qemu" "k3s-node-1" {
  name        = "k3s-node-1"
  desc        = "k3s node 1"
  target_node = "proxmox1"
  pxe         = true
  boot        = "order=scsi0;net0"
  agent       = 1
  bios        = "ovmf"
  scsihw      = "virtio-scsi-single"
  cpu         = "host"
  cores       = 6
  memory      = 10240
  onboot      = true
  machine     = "q35"

  disk {
    backup  = false
    discard = "on"
    size    = "25G"
    ssd     = 1
    storage = "local-lvm"
    type    = "scsi"
  }

  network {
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "virtio"
  }
}

resource "proxmox_vm_qemu" "k3s-node-3" {
  name        = "k3s-node-3"
  desc        = "k3s node 3"
  target_node = "proxmox3"
  pxe         = true
  boot        = "order=scsi0;net0"
  agent       = 1
  bios        = "ovmf"
  scsihw      = "virtio-scsi-single"
  cpu         = "host"
  cores       = 6
  memory      = 10240
  onboot      = true
  machine     = "q35"

  # untested
  vga {
    type = "virtio-gl"
  }

  disk {
    backup  = false
    discard = "on"
    size    = "25G"
    ssd     = 1
    storage = "local-lvm"
    type    = "scsi"
  }

  network {
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "virtio"
  }
}
