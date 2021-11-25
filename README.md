# Terraform Module - CHANGE_ME

#### Table of Contents

1. [Usage](#usage)
2. [Requirements](#requirements)
3. [Inputs](#inputs)
4. [Outputs](#outputs)
5. [Resources](#resources)
6. [Examples](#examples)

## Usage

This document will describe what the module is for and what is contained in it. It will be generated using [terraform-docs](https://terraform-docs.io/) which is configured to append to the existing README.md file.

Ensure that you have [pre-commit](https://pre-commit.com/) installed to make the most of this template, and use `pre-commit run -a` after adding files. See [.pre-commit-config.yaml](.pre-commit-config.yaml) for information on the dependencies needed, including `terraform-docs`, `tflint` and `tfsec`.

Things to update:
- README.md header
- README.md header content - description of module and its purpose
- Update [terraform.tf](terraform.tf) required_versions

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.86.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The location of this deployment. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of an existing resource group. | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | A prefix for the name of the resource, used to generate the resource names. | `string` | n/a | yes |
| <a name="input_acr_georeplication_locations"></a> [acr\_georeplication\_locations](#input\_acr\_georeplication\_locations) | Georeplication locations for ACR. (Premium tier required) | `list(string)` | `[]` | no |
| <a name="input_acr_sku"></a> [acr\_sku](#input\_acr\_sku) | SKU of the ACR. | `string` | `"Basic"` | no |
| <a name="input_aks_aad_admin_group_object_ids"></a> [aks\_aad\_admin\_group\_object\_ids](#input\_aks\_aad\_admin\_group\_object\_ids) | Object IDs of AAD Groups that have Admin role over the cluster. | `list(string)` | `null` | no |
| <a name="input_aks_aad_tenant_id"></a> [aks\_aad\_tenant\_id](#input\_aks\_aad\_tenant\_id) | Tenant ID used for AAD RBAC. (defaults to current tenant) | `string` | `null` | no |
| <a name="input_aks_allowed_maintenance_windows"></a> [aks\_allowed\_maintenance\_windows](#input\_aks\_allowed\_maintenance\_windows) | A map of maintance windows using a day and list of acceptable hours. | <pre>map(object({<br>    day   = string<br>    hours = list(number)<br>  }))</pre> | `{}` | no |
| <a name="input_aks_api_server_authorized_ranges"></a> [aks\_api\_server\_authorized\_ranges](#input\_aks\_api\_server\_authorized\_ranges) | CIDRs authorized to communicate with the API Server. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_aks_automatic_channel_upgrade"></a> [aks\_automatic\_channel\_upgrade](#input\_aks\_automatic\_channel\_upgrade) | Upgrade channel for the Kubernetes cluster. | `string` | `null` | no |
| <a name="input_aks_default_node_pool_availability_zones"></a> [aks\_default\_node\_pool\_availability\_zones](#input\_aks\_default\_node\_pool\_availability\_zones) | Availability zones to use with the default node pool. | `list(number)` | `null` | no |
| <a name="input_aks_default_node_pool_labels"></a> [aks\_default\_node\_pool\_labels](#input\_aks\_default\_node\_pool\_labels) | Node labels to apply to the default node pool. | `map(string)` | `null` | no |
| <a name="input_aks_default_node_pool_name"></a> [aks\_default\_node\_pool\_name](#input\_aks\_default\_node\_pool\_name) | Name of the default node pool. | `string` | `"default"` | no |
| <a name="input_aks_disable_local_account"></a> [aks\_disable\_local\_account](#input\_aks\_disable\_local\_account) | Whether to disable the local AKS account. | `bool` | `false` | no |
| <a name="input_aks_ingress_application_gateway_id"></a> [aks\_ingress\_application\_gateway\_id](#input\_aks\_ingress\_application\_gateway\_id) | The ID of the Application Gateway to integrate with AKS. | `string` | `null` | no |
| <a name="input_aks_ingress_application_gateway_name"></a> [aks\_ingress\_application\_gateway\_name](#input\_aks\_ingress\_application\_gateway\_name) | The name of the Application Gateway to integrate with AKS or create in the Nodepool resource group. | `string` | `null` | no |
| <a name="input_aks_ingress_application_subnet_cidr"></a> [aks\_ingress\_application\_subnet\_cidr](#input\_aks\_ingress\_application\_subnet\_cidr) | The CIDR used when creating an Application Gateway. | `string` | `null` | no |
| <a name="input_aks_ingress_application_subnet_id"></a> [aks\_ingress\_application\_subnet\_id](#input\_aks\_ingress\_application\_subnet\_id) | The ID of the Subnet the Application Gateway will be created on. | `string` | `null` | no |
| <a name="input_aks_kubernetes_version"></a> [aks\_kubernetes\_version](#input\_aks\_kubernetes\_version) | Version of Kubernetes to use in the cluster - leave blank for latest. | `string` | `null` | no |
| <a name="input_aks_load_balancer_sku"></a> [aks\_load\_balancer\_sku](#input\_aks\_load\_balancer\_sku) | SKU to use for the AKS Load Balancer. | `string` | `"Standard"` | no |
| <a name="input_aks_network_policy"></a> [aks\_network\_policy](#input\_aks\_network\_policy) | Network policy that should be used. ('calico' or 'azure') | `string` | `null` | no |
| <a name="input_aks_node_count"></a> [aks\_node\_count](#input\_aks\_node\_count) | Default number of nodes in the AKS cluster. | `number` | `2` | no |
| <a name="input_aks_node_max_count"></a> [aks\_node\_max\_count](#input\_aks\_node\_max\_count) | Maximum number of nodes in the AKS cluster. aks\_node\_min\_count must also be set for this to function. | `number` | `null` | no |
| <a name="input_aks_node_min_count"></a> [aks\_node\_min\_count](#input\_aks\_node\_min\_count) | Minimum number of nodes in the AKS cluster. aks\_node\_max\_count must also be set for this to function. | `number` | `null` | no |
| <a name="input_aks_node_pool_subnet_name"></a> [aks\_node\_pool\_subnet\_name](#input\_aks\_node\_pool\_subnet\_name) | Name of the subnet for Azure CNI. (Ignored if enable\_aks\_advanced\_networking is false) | `string` | `null` | no |
| <a name="input_aks_node_pool_subnet_vnet_name"></a> [aks\_node\_pool\_subnet\_vnet\_name](#input\_aks\_node\_pool\_subnet\_vnet\_name) | Name of the aks\_subnet\_name's VNet for Azure CNI. (Ignored if enable\_aks\_advanced\_networking is false) | `string` | `null` | no |
| <a name="input_aks_node_pool_subnet_vnet_resource_group_name"></a> [aks\_node\_pool\_subnet\_vnet\_resource\_group\_name](#input\_aks\_node\_pool\_subnet\_vnet\_resource\_group\_name) | Name of the resource group for aks\_subnet\_vnet\_name for Azure CNI. (Ignored if enable\_aks\_advanced\_networking is false) | `string` | `null` | no |
| <a name="input_aks_node_size"></a> [aks\_node\_size](#input\_aks\_node\_size) | Size of nodes in the AKS cluster. | `string` | `"Standard_B2ms"` | no |
| <a name="input_aks_private_dns_zone_id"></a> [aks\_private\_dns\_zone\_id](#input\_aks\_private\_dns\_zone\_id) | The Private DNS Zone ID - can alternatively by System to be AKS-managed or None to bring your own DNS. | `string` | `null` | no |
| <a name="input_aks_service_cidr"></a> [aks\_service\_cidr](#input\_aks\_service\_cidr) | Service CIDR for AKS. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_aks_sku_tier"></a> [aks\_sku\_tier](#input\_aks\_sku\_tier) | The SKU tier of AKS. | `string` | `"Free"` | no |
| <a name="input_diagnostic_retention_days"></a> [diagnostic\_retention\_days](#input\_diagnostic\_retention\_days) | Number of days to store metrics stored in Log Analytics. | `number` | `7` | no |
| <a name="input_enable_acr"></a> [enable\_acr](#input\_enable\_acr) | Whether to enable ACR. | `bool` | `false` | no |
| <a name="input_enable_acr_admin"></a> [enable\_acr\_admin](#input\_enable\_acr\_admin) | Whether to enable ACR Admin. | `bool` | `false` | no |
| <a name="input_enable_aks_aad_rbac"></a> [enable\_aks\_aad\_rbac](#input\_enable\_aks\_aad\_rbac) | Whether to enable AAD RBAC Integration. | `bool` | `false` | no |
| <a name="input_enable_aks_advanced_networking"></a> [enable\_aks\_advanced\_networking](#input\_enable\_aks\_advanced\_networking) | Whether to enable Azure CNI. | `bool` | `false` | no |
| <a name="input_enable_aks_default_node_pool_host_encryption"></a> [enable\_aks\_default\_node\_pool\_host\_encryption](#input\_enable\_aks\_default\_node\_pool\_host\_encryption) | Whether to enable host encryption on the default node pool. | `bool` | `null` | no |
| <a name="input_enable_aks_default_node_pool_public_ip"></a> [enable\_aks\_default\_node\_pool\_public\_ip](#input\_enable\_aks\_default\_node\_pool\_public\_ip) | Whether to enable public IP on the default node pool. | `bool` | `false` | no |
| <a name="input_enable_aks_default_node_pool_ultra_ssd"></a> [enable\_aks\_default\_node\_pool\_ultra\_ssd](#input\_enable\_aks\_default\_node\_pool\_ultra\_ssd) | Whether to enable Ultra SSD on the default node pool. | `bool` | `false` | no |
| <a name="input_enable_aks_ingress_application_gateway"></a> [enable\_aks\_ingress\_application\_gateway](#input\_enable\_aks\_ingress\_application\_gateway) | Whether to enable the Ingress Application Gateway plugin. | `bool` | `false` | no |
| <a name="input_enable_azure_policy"></a> [enable\_azure\_policy](#input\_enable\_azure\_policy) | Whether to enable the Azure Policy plugin. | `bool` | `false` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Whether to enable Log Analytics for monitoring the deployed resources. | `bool` | `false` | no |
| <a name="input_enable_private_cluster"></a> [enable\_private\_cluster](#input\_enable\_private\_cluster) | Whether to enable the private cluster feature of AKS. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log analytics workspace ID to use - defaults to creating a log analytics workspace. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags given to the resources created by this template. | `map(string)` | `{}` | no |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | The user assigned identity used with AKS. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_admin_password"></a> [acr\_admin\_password](#output\_acr\_admin\_password) | Admin password for the container registry. |
| <a name="output_acr_admin_user"></a> [acr\_admin\_user](#output\_acr\_admin\_user) | Admin user for the container registry. |
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | Resource ID of the container registry. |
| <a name="output_acr_login_server"></a> [acr\_login\_server](#output\_acr\_login\_server) | Login server of the container registry. |
| <a name="output_acr_name"></a> [acr\_name](#output\_acr\_name) | Name of the container registry. |
| <a name="output_aks_id"></a> [aks\_id](#output\_aks\_id) | Resource ID of the AKS Cluster. |
| <a name="output_aks_kubeconfig"></a> [aks\_kubeconfig](#output\_aks\_kubeconfig) | Kubeconfig for the AKS Cluster. |
| <a name="output_aks_kubeconfig_client_certificate"></a> [aks\_kubeconfig\_client\_certificate](#output\_aks\_kubeconfig\_client\_certificate) | AKS Cluster Client Certificate. |
| <a name="output_aks_kubeconfig_client_key"></a> [aks\_kubeconfig\_client\_key](#output\_aks\_kubeconfig\_client\_key) | AKS Cluster Client Key. |
| <a name="output_aks_kubeconfig_cluster_ca_certificate"></a> [aks\_kubeconfig\_cluster\_ca\_certificate](#output\_aks\_kubeconfig\_cluster\_ca\_certificate) | AKS Cluster CA Certificate. |
| <a name="output_aks_kubeconfig_host"></a> [aks\_kubeconfig\_host](#output\_aks\_kubeconfig\_host) | AKS Cluster Host. |
| <a name="output_aks_name"></a> [aks\_name](#output\_aks\_name) | Name of the AKS Cluster. |
| <a name="output_aks_node_resource_group_name"></a> [aks\_node\_resource\_group\_name](#output\_aks\_node\_resource\_group\_name) | Name of the AKS Cluster Resource Group. |
| <a name="output_aks_principal_id"></a> [aks\_principal\_id](#output\_aks\_principal\_id) | Principal ID of the AKS Cluster identity. |

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_kubernetes_cluster.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_log_analytics_workspace.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_diagnostic_setting.main_aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_role_assignment.main_acr_pull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.main_aks_network_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_kubernetes_service_versions.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_service_versions) | data source |
| [azurerm_monitor_diagnostic_categories.main_aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | data source |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.node_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Examples

```hcl
provider "azurerm" {
  features {}
}

locals {
  resource_prefix = "example-terraform"
  location        = "UK South"
  tags = {
    environment = "Development"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "${local.resource_prefix}-rg"
  location = local.location
  tags     = local.tags
}

module "example" {
  source = "../"

  // Module Inputs
  resource_group_name = azurerm_resource_group.example.name
  location            = local.location

  resource_prefix = local.resource_prefix
  tags            = local.tags

  aks_kubernetes_version        = "latest"
  aks_automatic_channel_upgrade = "stable"
  aks_allowed_maintenance_windows = {
    saturday = {
      day   = "Saturday"
      hours = [22, 23, 0]
    }
    sunday = {
      day   = "Sunday"
      hours = [22, 23, 0]
    }
  }

  aks_node_count = 2

  // Add a group ID into this list to allow cluster management.
  #aks_aad_admin_group_object_ids = []
  enable_aks_aad_rbac = true

  enable_acr       = true
  enable_acr_admin = true

  // Explicit dependency on azurerm_resource_group.main used due to a problem with the
  // module not picking up the implicit dependency.
  depends_on = [azurerm_resource_group.example]
}
```
<!-- END_TF_DOCS -->
