output "sa_token" {
  value      = data.kubernetes_secret.terraform.data["token"]
  sensitive  = true
}

output "service_account_token" {
  value      = data.azurerm_key_vault_secret.service_account_token.value
  sensitive  = true
}

output "aks_id" {
  value = module.aks_cluster.cluster_id
}

output "aks_fqdn" {
  value = module.aks_cluster.cluster_fqdn
}

output "aks_node_rg" {
  value = module.aks_cluster.node_resource_group
}
