# terraform-infra

## Multi-account Management

Multiple accounts? Switch between them with Terraform workspaces, as they'll
automatically manage state.

```bash
terraform workspace create [location]
terraform workspace select [location]
```

Then `terraform apply -var-file=filename.tfvars` to pick the right file for the
workspace (for credential management, etc).

You can turn `string` variables into `map(string)` variables and use the
workspace as a key.

## Linting

First run is a little long as pre-commit installs + caches `checkov`, which has
a bunch of dependencies of its own. Future runs will be faster if cached.

## Documentation

```bash
terraform-docs digitalocean
```
