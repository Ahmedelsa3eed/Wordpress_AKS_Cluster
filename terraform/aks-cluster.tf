# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "azurerm" {
  features {}

  subscription_id = "f83eff73-875b-4477-9896-31e0d0d63fc3"
}

resource "azurerm_resource_group" "default" {
  name     = "demo-rg"
  location = var.location

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_virtual_network" "default" {
  name                = "demo-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_subnet" "default" {
  name                 = "demo-subnet"
  resource_group_name  = azurerm_resource_group.default.name
  address_prefixes     = ["192.168.1.0/24"]
  virtual_network_name = azurerm_virtual_network.default.name
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "demo-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "demo-k8s"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_A2_v2"
    os_sku              = "Ubuntu"
    os_disk_size_gb     = 30
    vnet_subnet_id      = azurerm_subnet.default.id
    enable_auto_scaling = true
    max_count           = 3
    min_count           = 2
  }

  lifecycle {
    ignore_changes = [ 
      default_node_pool.0.node_count,
    ]
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  storage_profile {
    disk_driver_enabled = true
  }

  role_based_access_control_enabled = true
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true
  azure_policy_enabled              = true

  tags = {
    environment = "Demo"
  }
}