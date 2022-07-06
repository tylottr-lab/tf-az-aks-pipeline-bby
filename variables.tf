###################
# Global Variables
###################

variable "resource_group_name" {
  description = "The name of an existing resource group."
  type        = string
}

variable "location" {
  description = "The location of this deployment."
  type        = string
}

variable "resource_prefix" {
  description = "A prefix for the name of the resource, used to generate the resource names."
  type        = string
}

variable "tags" {
  description = "Tags given to the resources created by this template."
  type        = map(string)
  default     = null
}

#############
# Monitoring
#############

variable "enable_monitoring" {
  description = "Whether to enable Log Analytics for monitoring the deployed resources."
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log analytics workspace ID to use - defaults to creating a log analytics workspace."
  type        = string
  default     = null

  validation {
    condition     = var.log_analytics_workspace_id == null || can(regex("\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}", var.log_analytics_workspace_id))
    error_message = "The log_analytics_workspace_id must to be a valid UUID."
  }
}

variable "diagnostic_retention_days" {
  description = "Number of days to store metrics stored in Log Analytics."
  type        = number
  default     = 7
}

###########
# Security
###########

variable "enable_aks_aad_rbac" {
  description = "Whether to enable AAD RBAC Integration."
  type        = bool
  default     = false
}

variable "aks_aad_tenant_id" {
  description = "Tenant ID used for AAD RBAC. (defaults to current tenant)"
  type        = string
  default     = null

  validation {
    condition     = var.aks_aad_tenant_id == null || can(regex("\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}", var.aks_aad_tenant_id))
    error_message = "The aks_aad_tenant_id must to be a valid UUID."
  }
}

variable "aks_aad_admin_group_object_ids" {
  description = "Object IDs of AAD Groups that have Admin role over the cluster."
  type        = list(string)
  default     = null

  validation {
    // If null, pass. If a list, ensure we don't have any entries that aren't UUIDs.
    condition     = var.aks_aad_admin_group_object_ids == null || !can(index([for uuid in var.aks_aad_admin_group_object_ids : can(regex("\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}", uuid))], false))
    error_message = "The aks_aad_admin_group_object_ids must be valid UUIDs."
  }
}

variable "aks_api_server_authorized_ranges" {
  description = "CIDRs authorized to communicate with the API Server."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "aks_disable_local_account" {
  description = "Whether to disable the local AKS account."
  type        = bool
  default     = false
}

##########
# Storage
##########

variable "enable_acr" {
  description = "Whether to enable ACR."
  type        = bool
  default     = false
}

variable "acr_sku" {
  description = "SKU of the ACR."
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "The acr_sku must be 'Basic', 'Standard' or 'Premium'."
  }
}

variable "acr_georeplication_locations" {
  description = "Georeplication locations for ACR. (Premium tier required)"
  type        = list(string)
  default     = []
}

variable "enable_acr_admin" {
  description = "Whether to enable ACR Admin."
  type        = bool
  default     = false
}

##########
# Compute
##########

variable "aks_kubernetes_version" {
  description = "Version of Kubernetes to use in the cluster - leave blank for latest."
  type        = string
  default     = null

  validation {
    condition     = var.aks_kubernetes_version == null || var.aks_kubernetes_version == "latest" || can(regex("\\d+\\.\\d+\\.\\d+", var.aks_kubernetes_version))
    error_message = "The aks_kubernetes_version value must be 'latest' or semantic versioning e.g. '1.18.4'."
  }
}

variable "aks_automatic_channel_upgrade" {
  description = "Upgrade channel for the Kubernetes cluster."
  type        = string
  default     = null

  validation {
    condition     = var.aks_automatic_channel_upgrade == null ? true : contains(["patch", "rapid", "node-image", "stable"], var.aks_automatic_channel_upgrade)
    error_message = "The aks_automatic_channel_upgrade must be 'patch', 'rapid', 'node-image' or 'stable'."
  }
}

variable "aks_allowed_maintenance_windows" {
  description = "A map of maintance windows using a day and list of acceptable hours."
  type = map(object({
    day   = string
    hours = list(number)
  }))
  default = {}
}

variable "enable_private_cluster" {
  description = "Whether to enable the private cluster feature of AKS."
  type        = bool
  default     = false
}

variable "aks_private_dns_zone_id" {
  description = "The Private DNS Zone ID - can alternatively by System to be AKS-managed or None to bring your own DNS."
  type        = string
  default     = null
}

variable "aks_sku_tier" {
  description = "The SKU tier of AKS."
  type        = string
  default     = "Free"
}

variable "user_assigned_identity_id" {
  description = "The user assigned identity used with AKS."
  type        = string
  default     = null
}

variable "aks_load_balancer_sku" {
  description = "SKU to use for the AKS Load Balancer."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.aks_load_balancer_sku)
    error_message = "The aks_load_balancer_sku must be 'Basic' or 'Standard'."
  }
}

variable "aks_network_policy" {
  description = "Network policy that should be used. ('calico' or 'azure')"
  type        = string
  default     = null

  validation {
    condition     = var.aks_network_policy == null || var.aks_network_policy == "calico" || var.aks_network_policy == "azure"
    error_message = "The aks_network_policy must be null, 'calico' or 'azure'."
  }
}

variable "enable_aks_advanced_networking" {
  description = "Whether to enable Azure CNI."
  type        = bool
  default     = false
}

variable "aks_node_pool_subnet_name" {
  description = "Name of the subnet for Azure CNI. (Ignored if enable_aks_advanced_networking is false)"
  type        = string
  default     = null
}

variable "aks_node_pool_subnet_vnet_name" {
  description = "Name of the aks_subnet_name's VNet for Azure CNI. (Ignored if enable_aks_advanced_networking is false)"
  type        = string
  default     = null
}

variable "aks_node_pool_subnet_vnet_resource_group_name" {
  description = "Name of the resource group for aks_subnet_vnet_name for Azure CNI. (Ignored if enable_aks_advanced_networking is false)"
  type        = string
  default     = null
}

variable "aks_service_cidr" {
  description = "Service CIDR for AKS."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{2}", var.aks_service_cidr))
    error_message = "The aks_service_cidr must be a valid CIDR range."
  }
}

variable "aks_default_node_pool_name" {
  description = "Name of the default node pool."
  type        = string
  default     = "default"
}

variable "aks_node_size" {
  description = "Size of nodes in the AKS cluster."
  type        = string
  default     = "Standard_B2ms"
}

variable "enable_aks_default_node_pool_host_encryption" {
  description = "Whether to enable host encryption on the default node pool."
  type        = bool
  default     = null
}

variable "enable_aks_default_node_pool_public_ip" {
  description = "Whether to enable public IP on the default node pool."
  type        = bool
  default     = false
}

variable "enable_aks_default_node_pool_ultra_ssd" {
  description = "Whether to enable Ultra SSD on the default node pool."
  type        = bool
  default     = false
}

variable "aks_node_count" {
  description = "Default number of nodes in the AKS cluster."
  type        = number
  default     = 2
}

variable "aks_node_min_count" {
  description = "Minimum number of nodes in the AKS cluster. aks_node_max_count must also be set for this to function."
  type        = number
  default     = null

  validation {
    condition     = var.aks_node_min_count == null ? true : var.aks_node_min_count < 1
    error_message = "The aks_node_min_count is less than 1."
  }
}

variable "aks_node_max_count" {
  description = "Maximum number of nodes in the AKS cluster. aks_node_min_count must also be set for this to function."
  type        = number
  default     = null

  validation {
    condition     = var.aks_node_max_count == null ? true : var.aks_node_max_count < 1
    error_message = "The aks_node_max_count is less than 1."
  }
}

variable "aks_default_node_pool_availability_zones" {
  description = "Availability zones to use with the default node pool."
  type        = list(number)
  default     = null
}

variable "aks_default_node_pool_labels" {
  description = "Node labels to apply to the default node pool."
  type        = map(string)
  default     = null
}

variable "enable_azure_policy" {
  description = "Whether to enable the Azure Policy plugin."
  type        = bool
  default     = false
}

variable "enable_aks_ingress_application_gateway" {
  description = "Whether to enable the Ingress Application Gateway plugin."
  type        = bool
  default     = false
}

variable "aks_ingress_application_gateway_id" {
  description = "The ID of the Application Gateway to integrate with AKS."
  type        = string
  default     = null
}

variable "aks_ingress_application_gateway_name" {
  description = "The name of the Application Gateway to integrate with AKS or create in the Nodepool resource group."
  type        = string
  default     = null
}

variable "aks_ingress_application_subnet_id" {
  description = "The ID of the Subnet the Application Gateway will be created on."
  type        = string
  default     = null
}

variable "aks_ingress_application_subnet_cidr" {
  description = "The CIDR used when creating an Application Gateway."
  type        = string
  default     = null
}

#########
# Locals
#########

locals {
  resource_prefix = "${var.resource_prefix}-aks"
}
