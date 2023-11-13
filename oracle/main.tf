terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
  region       = var.region
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# the 200g block volume you can have
# resource "oci_core_volume" "big_boi_1" {
#   availability_domain  = data.oci_identity_availability_domains.ads.availability_domains[0].name
#   compartment_id       = var.tenancy_ocid
#   size_in_gbs          = 200
#   is_auto_tune_enabled = false
#   vpus_per_gb          = 0
#   display_name         = "big_boi_1"
# }

# the free permanent public ip addr
resource "oci_core_public_ip" "oracle-vm-1" {
  compartment_id = var.tenancy_ocid
  lifetime       = "RESERVED"
  display_name   = "oracle-vm-1"
}

# for vms to communicate externally
resource "oci_core_vcn" "vcn" {
  compartment_id = var.tenancy_ocid
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "vcn"
}

# subnet for vm?
resource "oci_core_subnet" "subnet" {
  cidr_block     = "10.0.0.0/24"
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "subnet"
}

# TODO: determine if necessary for k3s - you should be able to use traefik to
# revproxy this out to HTTP/S
# terraform import oci_core_security_list.k3s [security list OCID]
# resource "oci_core_security_list" "k3s" {
#   compartment_id = var.tenancy_ocid
#   vcn_id         = oci_core_vcn.vcn.id
#   egress_security_rules {
#     description      = "k3s flannel"
#     destination      = "10.0.0.0/8"
#     destination_type = "CIDR_BLOCK"
#     protocol         = "17"
#     stateless        = true

#     udp_options {
#       max = 8472
#       min = 8472
#     }
#   }
#   egress_security_rules {
#     description      = "k3s testing"
#     destination      = "0.0.0.0/0"
#     destination_type = "CIDR_BLOCK"
#     protocol         = "6"
#     stateless        = true

#     tcp_options {
#       max = 8081
#       min = 8081
#     }
#   }

#   ingress_security_rules {
#     description = "k3s flannel"
#     protocol    = "17"
#     source      = "10.0.0.0/8"
#     source_type = "CIDR_BLOCK"
#     stateless   = true

#     udp_options {
#       max = 8472
#       min = 8472
#     }
#   }
#   ingress_security_rules {
#     description = "k3s metrics"
#     protocol    = "6"
#     source      = "10.0.0.0/8"
#     source_type = "CIDR_BLOCK"
#     stateless   = false

#     tcp_options {
#       max = 10250
#       min = 10250
#     }
#   }
#   ingress_security_rules {
#     description = "k3s testing"
#     protocol    = "6"
#     source      = "0.0.0.0/0"
#     source_type = "CIDR_BLOCK"
#     stateless   = true

#     tcp_options {
#       max = 8081
#       min = 8081
#     }
#   }
#   ingress_security_rules {
#     description = "k3s api"
#     protocol    = "6"
#     source      = "0.0.0.0/0"
#     source_type = "CIDR_BLOCK"
#     stateless   = false

#     tcp_options {
#       max = 6443
#       min = 6443
#     }
#   }
# }

resource "oci_core_instance_configuration" "x86_instance_configuration" {
  compartment_id = var.tenancy_ocid
  display_name   = "x86_instance_configuration"
  instance_details {
    instance_type = "compute"
    launch_details {
      compartment_id = var.tenancy_ocid
      create_vnic_details {
        subnet_id = oci_core_subnet.subnet.id
      }
      shape = var.x86_shape_name
      source_details {
        source_type = "image"
        image_id    = var.x86_oci_boot_image[terraform.workspace]
        # don't declare the boot volume size, default is sane enough
      }
    }
  }
}

resource "oci_core_instance_configuration" "arm_instance_configuration" {
  compartment_id = var.tenancy_ocid
  display_name   = "arm_instance_configuration"
  instance_details {
    instance_type = "compute"
    launch_details {
      compartment_id = var.tenancy_ocid
      create_vnic_details {
        subnet_id = oci_core_subnet.subnet.id
      }
      shape = var.arm_shape_name
      shape_config {
        memory_in_gbs = 24 / var.arm_pool_count
        ocpus         = 4 / var.arm_pool_count
      }
      source_details {
        source_type = "image"
        image_id    = var.arm_oci_boot_image[terraform.workspace]
        # don't declare the boot volume size, default is sane enough
      }
    }
  }
}

# the actual VMs
# two pools max on free tier?
# this is the ARM pool - note that you can configure # of VMs and stay within
# the free tier limits thanks to math
resource "oci_core_instance_pool" "arm_pool" {
  compartment_id            = var.tenancy_ocid
  instance_configuration_id = oci_core_instance_configuration.arm_instance_configuration.id
  size                      = var.arm_pool_count
  display_name              = "arm_pool"
  placement_configurations {
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    primary_subnet_id   = oci_core_subnet.subnet.id
  }
}

# and the x86 pool
resource "oci_core_instance_pool" "x86_pool" {
  compartment_id            = var.tenancy_ocid
  instance_configuration_id = oci_core_instance_configuration.x86_instance_configuration.id
  size                      = 2
  display_name              = "x86_pool"
  placement_configurations {
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    primary_subnet_id   = oci_core_subnet.subnet.id
  }
}
