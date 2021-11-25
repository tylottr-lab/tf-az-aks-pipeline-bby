data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_subnet" "node_pool" {
  count = var.enable_aks_advanced_networking ? 1 : 0

  name                 = var.aks_node_pool_subnet_name
  virtual_network_name = var.aks_node_pool_subnet_vnet_name
  resource_group_name  = var.aks_node_pool_subnet_vnet_resource_group_name
}

resource "azurerm_role_assignment" "main_aks_network_contributor" {
  count = var.enable_aks_advanced_networking ? 1 : 0

  scope                = data.azurerm_subnet.node_pool[0].id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}
