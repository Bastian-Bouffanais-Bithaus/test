terraform {
  required_providers {
    kubectl = {
      source  = "hashicorp/kubectl"
      version = "1.11.3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.76.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.1.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.1.2"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

variable "resource_group_name" {
  default = "cummins-medium-test"
}

variable "location" {
  default = "eastus"
}

variable "cluster_name" {
  default = "terraform-aks-test"
}

variable "kubernetes_version" {
  default = "1.21.9"
}

variable "system_node_count" {
  default = 3
}

variable "tenant_id" {
  default = "YOUR_TENANT_ID"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  node_resource_group = lower(format("%s-%s", var.cluster_name, "rg"))

  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = false
    min_count           = 1
    max_count           = 5
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "azure"
  }

  local_account_disabled = true

  azure_active_directory_role_based_access_control {
    managed = true
  }
}

resource "azurerm_role_assignment" "aks_to_keyvault" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

resource "azurerm_key_vault" "keyvault" {
  name                = "my-keyvault-${random_string.random.result}"
  location            = azurerm_kubernetes_cluster.aks.location
  resource_group_name = azurerm_kubernetes_cluster.aks.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = azurerm_kubernetes_cluster.aks.identity[0].principal_id
    secret_permissions = ["get", "list"]
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "ExampleSecret"
  value        = "SuperSecretValue"
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-test"
  namespace  = "default"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.12"

  set {
    name  = "controller.replicaCount"
    value = "1"
  }

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
  
  set {
    name  = "controller.admissionWebhooks.enabled"
    value = "true"
  }
  
}

resource "kubectl_manifest" "nginx_ingress" {
  path            = "path/to/your/manifest.yaml"
  force_new       = true
  depends_on      = [helm_release.nginx_ingress]
}

resource "random_string" "random" {
  length  = 8
  special = false
}
