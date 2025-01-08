variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  description = "Resources location in Azure"
}

variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
}

variable "aad_admin_group_object_ids" {
  description = "List of Azure AD Group Object IDs for admin access to the AKS cluster"
  type        = list(string)
  default     = [""] 
}

variable "aad_tenant_id" {
  description = "The Azure AD Tenant ID"
  type        = string
  default = ""
}

variable "client_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "tenant_id" {}
