variable "tenancy_ocid" {
  description = "Tenant OCID"
  type        = string
}

variable "user_ocid" {
  description = "User OCID"
  type        = string
}

variable "fingerprint" {
  description = "Key fingerprint"
  type        = string
}

variable "private_key" {
  description = "Key contents"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
}

# Example source
# https://docs.oracle.com/en-us/iaas/images/image/d961e5a6-dba4-4547-8733-06b58eecc95e/
# this is Ubuntu 22.04 aarch64 2023.09.27
variable "arm_oci_boot_image" {
  description = "OCID of image to boot from"
  type        = map(string)
  default = {
    default = "ocid1.image.oc1.us-sanjose-1.aaaaaaaavkvvub7kaqfykobntskk6hi7ukw4g5docvhxjztd3sinr3gkjyya"
  }
}

# this is x86 version
# https://docs.oracle.com/en-us/iaas/images/image/84a75e6a-f775-4fb8-b934-6104d7c5ea0d/
variable "x86_oci_boot_image" {
  description = "OCID of image to boot from"
  type        = map(string)
  default = {
    default = "ocid1.image.oc1.us-sanjose-1.aaaaaaaapdrlfiworksfy3yby6t3fisqtp4qxg2axudbsavqbrggmxktlosq"
  }
}

variable "arm_shape_name" {
  description = "Name of shape for ARM machines"
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "x86_shape_name" {
  description = "Name of shape for x86 machines"
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "arm_pool_count" {
  description = "Number of VMs in ARM pool"
  type        = number
  default     = 2
}
