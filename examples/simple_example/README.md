# Simple Example

This example illustrates how to use the `dell-marketplace` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| b\_project | Enter a GCP project name where the CR solution will be deployed | `string` | n/a | yes |
| c\_region | Enter a GCP region name where the CR solution will be deployed. E.g. us-east1 | `string` | n/a | yes |
| d\_zone | Enter a GCP zone name where the CR solution will be deployed. E.g. us-east1-b | `string` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
