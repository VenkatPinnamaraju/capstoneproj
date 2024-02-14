terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "ven-stg"
    storage_account_name = "venstg123"
    container_name = "vencap"
    key = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    
  }
}


resource "azurerm_resource_group" "ven1_aks_rg" {
  name     = var.resource_group_name
  location = "UK South"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                        = var.keyvault_name
  location                    = azurerm_resource_group.ven1_aks_rg.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

    sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
    ]

    storage_permissions = [
      "Get",
      "List",
    ]
  }
depends_on = [ azurerm_kubernetes_cluster.ven1_aks ]
  
}

resource "azurerm_key_vault_secret" "client-pwd" {
  name         = var.secret_name
  value        = var.secret_value
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_kubernetes_cluster" "ven1_aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.ven1_aks_rg.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name       = "venpool1"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  service_principal {
    client_id     = "990b7bfc-6f00-48b1-941e-58476eeaf976"
    client_secret = azurerm_key_vault_secret.client-pwd.value
  }
  depends_on = [ azurerm_key_vault.keyvault, azurerm_key_vault_secret.client-pwd ]
}


