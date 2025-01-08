resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  node_resource_group = lower(format("%s%s", var.cluster_name, "-rg"))

  default_node_pool {
    name                 = "system"
    node_count           = var.system_node_count
    vm_size              = "Standard_DS2_v2"
    type                 = "VirtualMachineScaleSets"
    auto_scaling_enabled = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet"
  }

  local_account_disabled = true

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = [
      "c34bc108-2e03-4432-b674-61b921a075a8"
    ]
  }
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = azurerm_kubernetes_cluster.aks.name
  resource_group_name = azurerm_kubernetes_cluster.aks.resource_group_name
}
