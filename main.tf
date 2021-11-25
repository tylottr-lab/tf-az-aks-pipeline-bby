#############
# Monitoring
#############

resource "azurerm_log_analytics_workspace" "main" {
  count = var.enable_monitoring && var.log_analytics_workspace_id != null ? 1 : 0

  name                = "${local.resource_prefix}-oms"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  tags                = var.tags

  sku               = "PerGB2018"
  retention_in_days = 30
}

##########
# Storage
##########

locals {
  acr_name                     = lower(replace("${local.resource_prefix}acr", "/[-_]/", ""))
  acr_georeplication_locations = length(var.acr_georeplication_locations) < 1 ? [] : var.acr_georeplication_locations
}

resource "azurerm_container_registry" "main" {
  count = var.enable_acr ? 1 : 0

  name                = local.acr_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  tags                = var.tags

  sku = var.acr_sku

  dynamic "georeplications" {
    for_each = local.acr_georeplication_locations
    iterator = georeplication

    content {
      location = georeplication
      tags     = var.tags
    }
  }

  admin_enabled = var.enable_acr_admin
}

resource "azurerm_role_assignment" "main_acr_pull" {
  count = var.enable_acr ? 1 : 0

  scope                = azurerm_container_registry.main[count.index].id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

##########
# Compute
##########

locals {
  aks_network_plugin = var.enable_aks_advanced_networking ? "azure" : "kubenet"
  aks_pod_cidr       = var.enable_aks_advanced_networking ? null : "10.244.0.0/16"
  aks_dns_service_ip = cidrhost(var.aks_service_cidr, 10)

  log_analytics_workspace_id = var.enable_monitoring ? coalesce(var.log_analytics_workspace_id, azurerm_log_analytics_workspace.main[0].id) : null
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = local.resource_prefix
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  tags                = var.tags

  kubernetes_version        = var.aks_kubernetes_version == null ? data.azurerm_kubernetes_service_versions.current.latest_version : var.aks_kubernetes_version
  automatic_channel_upgrade = var.aks_automatic_channel_upgrade
  maintenance_window {
    dynamic "allowed" {
      for_each = var.aks_allowed_maintenance_windows

      content {
        day   = allowed.value["day"]
        hours = allowed.value["hours"]
      }
    }
  }

  dns_prefix                      = local.resource_prefix
  private_cluster_enabled         = var.enable_private_cluster
  private_dns_zone_id             = var.enable_private_cluster ? var.aks_private_dns_zone_id : null
  api_server_authorized_ip_ranges = var.aks_api_server_authorized_ranges
  local_account_disabled          = var.aks_disable_local_account

  sku_tier = var.aks_sku_tier

  identity {
    type                      = var.user_assigned_identity_id == null ? "SystemAssigned" : "UserAssigned"
    user_assigned_identity_id = var.user_assigned_identity_id
  }

  role_based_access_control {
    enabled = true

    dynamic "azure_active_directory" {
      for_each = var.enable_aks_aad_rbac ? [true] : []

      content {
        managed                = true
        tenant_id              = var.aks_aad_tenant_id
        admin_group_object_ids = var.aks_aad_admin_group_object_ids
        azure_rbac_enabled     = true
      }
    }
  }

  network_profile {
    network_plugin    = local.aks_network_plugin
    load_balancer_sku = var.aks_load_balancer_sku

    pod_cidr           = local.aks_pod_cidr
    network_policy     = var.aks_network_policy
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = var.aks_service_cidr
    dns_service_ip     = local.aks_dns_service_ip
  }

  default_node_pool {
    name = var.aks_default_node_pool_name
    type = "VirtualMachineScaleSets"
    tags = var.tags

    enable_auto_scaling    = var.aks_node_min_count == null && var.aks_node_max_count == null ? false : true
    enable_host_encryption = var.enable_aks_default_node_pool_host_encryption
    enable_node_public_ip  = var.enable_aks_default_node_pool_public_ip
    ultra_ssd_enabled      = var.enable_aks_default_node_pool_ultra_ssd

    vm_size            = var.aks_node_size
    node_count         = var.aks_node_count
    min_count          = var.aks_node_min_count
    max_count          = var.aks_node_min_count
    availability_zones = var.aks_default_node_pool_availability_zones

    vnet_subnet_id = var.enable_aks_advanced_networking ? data.azurerm_subnet.node_pool[0].id : null

    node_labels = var.aks_default_node_pool_labels


  }

  addon_profile {
    oms_agent {
      // Ignore tfsec rule relating to configuring monitoring.
      #tfsec:ignore:AZU009
      enabled                    = var.enable_monitoring
      log_analytics_workspace_id = local.log_analytics_workspace_id
    }

    azure_policy {
      enabled = var.enable_azure_policy
    }

    ingress_application_gateway {
      enabled      = var.enable_aks_ingress_application_gateway
      gateway_id   = var.aks_ingress_application_gateway_id
      gateway_name = var.aks_ingress_application_gateway_name
      subnet_id    = var.aks_ingress_application_subnet_id
      subnet_cidr  = var.aks_ingress_application_subnet_cidr
    }
  }

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count, kubernetes_version]
  }
}

data "azurerm_monitor_diagnostic_categories" "main_aks" {
  resource_id = azurerm_kubernetes_cluster.main.id
}

resource "azurerm_monitor_diagnostic_setting" "main_aks" {
  count = var.enable_monitoring ? 1 : 0

  name                       = "${local.resource_prefix}-diag"
  target_resource_id         = azurerm_kubernetes_cluster.main.id
  log_analytics_workspace_id = local.log_analytics_workspace_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.main_aks.logs
    iterator = log_category

    content {
      category = log_category.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.diagnostic_retention_days
      }
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.main_aks.metrics
    iterator = metric_category

    content {
      category = metric_category.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.diagnostic_retention_days
      }
    }
  }
}
