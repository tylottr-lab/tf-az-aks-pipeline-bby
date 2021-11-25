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
