# oracle

## Workspaces

These workspace names refer to the following locations:

* default (San Jose)
* toronto (Toronto)

## Reconfiguring Pools

You cannot scale up the ARM pool without deleting it first (because we overwrite
the instance configuration). Attempting to do so will error with `409-Conflict`.

```console
$ terraform apply -var-file=oci-yanglangthang.tfvars -var arm_pool_count=2
<trimmed output>

$ terraform apply -var-file=oci-yanglangthang.tfvars -var arm_pool_count=4
Terraform will perform the following actions:
  oci_core_instance_configuration.arm_instance_configuration must be replaced
  oci_core_instance_pool.arm_pool will be updated in-place

│ Error: 409-Conflict 
│ Provider version: 4.33.0, released on 2021-06-30. This provider is 1 update(s) behind to current. 
│ Service: Core Instance Configuration 
│ Error Message: The Instance Configuration <OCID> is associated to one or more Instance Pools. 
│ OPC request ID: <long string>
│ Suggestion: The resource is in a conflicted state. Please retry again or contact support for help with service: Core Instance Configuration

$ terraform apply -var-file=oci-yanglangthang.tfvars -var arm_pool_count=4 -replace="oci_core_instance_pool.arm_pool"
Terraform will perform the following actions:
  oci_core_instance_configuration.arm_instance_configuration must be replaced
  oci_core_instance_pool.arm_pool will be replaced, as requested
Apply complete! Resources: 2 added, 0 changed, 2 destroyed.
```
