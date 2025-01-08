variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
}

variable "system_node_count" {
  description = "Number of nodes in the system pool"
  type        = number
}

variable "client_id" {
  description = "Azure client id"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant id"
  type        = string
}

variable "client_secret" {
  description = "Azure client secret"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription id"
  type        = string
}

variable "service_account_token" {
  description = "Service account token for Kubernetes authentication"
  type        = string
}
