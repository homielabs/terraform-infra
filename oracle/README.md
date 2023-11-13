# oracle

## Workspaces

These workspace names refer to the following locations:

* default (San Jose)

## Reconfiguring Pools

You cannot scale up the ARM pool without deleting it first (because we overwrite
the instance configuration). Attempting to do so will error with `409-Conflict`.

```console
$ terraform apply -var-file=oci.toronto.tfvars -var arm_pool_count=2
<trimmed output>

$ terraform apply -var-file=oci.toronto.tfvars -var arm_pool_count=4
Terraform will perform the following actions:
  oci_core_instance_configuration.arm_instance_configuration must be replaced
  oci_core_instance_pool.arm_pool will be updated in-place

│ Error: 409-Conflict 
│ Provider version: 4.33.0, released on 2021-06-30. This provider is 1 update(s) behind to current. 
│ Service: Core Instance Configuration 
│ Error Message: The Instance Configuration <OCID> is associated to one or more Instance Pools. 
│ OPC request ID: <long string>
│ Suggestion: The resource is in a conflicted state. Please retry again or contact support for help with service: Core Instance Configuration

$ terraform apply -var-file=oci.toronto.tfvars -var arm_pool_count=4 -replace="oci_core_instance_pool.arm_pool"
Terraform will perform the following actions:
  oci_core_instance_configuration.arm_instance_configuration must be replaced
  oci_core_instance_pool.arm_pool will be replaced, as requested
Apply complete! Resources: 2 added, 0 changed, 2 destroyed.
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 5.20.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_instance_configuration.arm_instance_configuration](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance_configuration) | resource |
| [oci_core_instance_configuration.x86_instance_configuration](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance_configuration) | resource |
| [oci_core_instance_pool.arm_pool](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance_pool) | resource |
| [oci_core_instance_pool.x86_pool](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance_pool) | resource |
| [oci_core_public_ip.oracle-vm-1](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_public_ip) | resource |
| [oci_core_subnet.subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.vcn](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn) | resource |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arm_oci_boot_image"></a> [arm\_oci\_boot\_image](#input\_arm\_oci\_boot\_image) | OCID of image to boot from | `map(string)` | <pre>{<br>  "default": "ocid1.image.oc1.us-sanjose-1.aaaaaaaavkvvub7kaqfykobntskk6hi7ukw4g5docvhxjztd3sinr3gkjyya"<br>}</pre> | no |
| <a name="input_arm_pool_count"></a> [arm\_pool\_count](#input\_arm\_pool\_count) | Number of VMs in ARM pool | `number` | `2` | no |
| <a name="input_arm_shape_name"></a> [arm\_shape\_name](#input\_arm\_shape\_name) | Name of shape for ARM machines | `string` | `"VM.Standard.A1.Flex"` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | Key fingerprint | `string` | n/a | yes |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | Key contents | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | OCI region | `string` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | Tenant OCID | `string` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | User OCID | `string` | n/a | yes |
| <a name="input_x86_oci_boot_image"></a> [x86\_oci\_boot\_image](#input\_x86\_oci\_boot\_image) | OCID of image to boot from | `map(string)` | <pre>{<br>  "default": "ocid1.image.oc1.us-sanjose-1.aaaaaaaapdrlfiworksfy3yby6t3fisqtp4qxg2axudbsavqbrggmxktlosq"<br>}</pre> | no |
| <a name="input_x86_shape_name"></a> [x86\_shape\_name](#input\_x86\_shape\_name) | Name of shape for x86 machines | `string` | `"VM.Standard.E2.1.Micro"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
