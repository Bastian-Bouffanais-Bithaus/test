provider "azurerm" {
  features {}
  subscription_id = "e5e62d08-85ed-413e-96aa-d9dbc151dc0b"
  tenant_id       = "78bc4686-f789-41d4-bfd6-1bbd52d78344"
  resource_provider_registrations = "none"
}

provider "azuread" {
  client_id     = "282a6ab7-0128-49bd-9d1b-932733408d33"
  client_secret = "cc98Q~oksS65oBkRkEYWrws4ip4UMu3n_.qRech7"
  tenant_id     = "78bc4686-f789-41d4-bfd6-1bbd52d78344"
  use_client    = true
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args        = [
      "--environment", "AzurePublicCloud", 
      "--server-id", "6dae42f8-4368-4678-94ff-3960e28e3630",
      "--client-id", "80faf920-1908-4b52-b5ef-a8e7bedfc67a",
      "--tenant-id", "78bc4686-f789-41d4-bfd6-1bbd52d78344"
    ]
  }
}

provider "helm" {
  debug = true
  kubernetes {
    config_path = "~/.kube/config"
  }
}


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.16.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}