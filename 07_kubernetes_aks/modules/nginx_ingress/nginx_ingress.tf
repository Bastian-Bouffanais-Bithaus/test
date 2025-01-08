provider "helm" {
  kubernetes {
    host                   = var.helm_provider_config["host"]
token                  = var.service_account_token
  }
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
    name  = "controller.publishService.enabled"
    value = "true"
  }

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
}


