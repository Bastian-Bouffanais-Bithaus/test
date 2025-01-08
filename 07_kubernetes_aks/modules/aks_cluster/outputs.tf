output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  value = azurerm_kubernetes_cluster.aks.resource_group_name
}

output "kube_config" {
  value = {
    host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
    token                  = var.service_account_token
  }
}

output "cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "cluster_fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}
