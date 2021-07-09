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

# variable "private_key_path" {
#   description = "Key path"
#   type        = string
# }

variable "private_key" {
  description = "Key contents"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
}

# Example source
# https://docs.oracle.com/en-us/iaas/images/image/15450b83-355e-44ee-97c0-7880ac93bceb/
# this is Ubuntu 20.04 aarch64 2021.06.03-0
variable "arm_oci_boot_image" {
  description = "OCID of image to boot from"
  type        = map(string)
  default = {
    default = "ocid1.image.oc1.us-sanjose-1.aaaaaaaanfzh6js2q4rznma2kcwyrdzs2yi42p2ol5hhlm2cfcntwdcna3oq"
    toronto = "ocid1.image.oc1.ca-toronto-1.aaaaaaaarfnfahlv3oxkcjhe4lg34v3y6par2hc3yijsvna5qcnmsizrvb5a"
  }
}

# this is x86 version
# https://docs.oracle.com/en-us/iaas/images/image/70a4b033-f6be-44a5-80e9-2267091e58fb/
variable "x86_oci_boot_image" {
  description = "OCID of image to boot from"
  type        = map(string)
  default = {
    default = "ocid1.image.oc1.us-sanjose-1.aaaaaaaa4juj67ndckcob73kwhjkzacldnu7gjzgxhe4reqasc3hb76g2qwa"
    toronto = "ocid1.image.oc1.ca-toronto-1.aaaaaaaaw6dx4jxld2uwuarkbxo5ymyi6v2k2ym3ntlcbluy7ed2wl4tb2wq"
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
