<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.10.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_domain.domains](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/domain) | resource |
| [digitalocean_droplet.master](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_record.records](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/record) | resource |
| [digitalocean_ssh_key.ssh_keys](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/ssh_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_init"></a> [cloud\_init](#input\_cloud\_init) | cloud\_init content for droplet | `string` | `"../general/cloud_init.yml"` | no |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | DO Token | `string` | n/a | yes |
| <a name="input_domain_file"></a> [domain\_file](#input\_domain\_file) | YAML with root domain as keys and a list of subdomain fragments as the value | `string` | `"../general/domains.yml"` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | List of SSH keys to get by name | `set(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
