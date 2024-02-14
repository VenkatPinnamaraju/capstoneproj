variable "resource_group_name" {
    type = string
}

variable "cluster_name" {
    type = string
}

variable "keyvault_name" {
  type        = string
  description = "Key Vault Secret name in Azure"
}

variable "secret_name" {
  type        = string
  description = "Key Vault Secret name in Azure"
}

variable "secret_value" {
  type        = string
  description = "Key Vault Secret value in Azure"
  sensitive   = true
}