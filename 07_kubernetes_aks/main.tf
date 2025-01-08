module "aks_cluster" {
  source               = "./modules/aks_cluster"
  cluster_name         = var.cluster_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  kubernetes_version   = var.kubernetes_version
  system_node_count    = var.system_node_count
  client_id            = var.client_id
  tenant_id            = var.tenant_id
  client_secret        = var.client_secret
  subscription_id      = var.subscription_id
  service_account_token = data.kubernetes_secret.terraform.data["token"]
}

data "azurerm_key_vault" "kv" {
  name                = "keyvaultesting"
  resource_group_name = "cummins-medium-test"
}

data "azurerm_key_vault_secret" "service_account_token" {
  name         = "ServiceAccountToken"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "kubernetes_service_account" "terraform" {
  metadata {
    name      = "terraform"
    namespace = "default"
  }
}

data "kubernetes_secret" "terraform" {
  metadata {
    name      = "terraform-token"  
    namespace = "default"
  }
  depends_on = [kubernetes_service_account.terraform]
}

module "nginx_ingress" {
  source               = "./modules/nginx_ingress"
  helm_provider_config = {
    host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  }
  service_account_token  = data.kubernetes_secret.terraform.data["token"]
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = module.aks_cluster.cluster_name
  resource_group_name = module.aks_cluster.resource_group_name
}
