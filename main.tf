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
    client_secret = "iJO8Q~yxUiuOuM1uRUq3ZYQWb1Mh9ifh3fRhicAw"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "ven1_np" {
  name                  = "vennp1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.ven1_aks.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1

  tags = {
    Environment = "test"
  }
}
