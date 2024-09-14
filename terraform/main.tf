# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "azurerm" {
  features {}

  subscription_id = "f83eff73-875b-4477-9896-31e0d0d63fc3"
}


module "network" {
  source = "./modules/network"

  location = var.location
}

module "cluster" {
  source = "./modules/cluster"

  location            = var.location
  resource_group_name = module.network.resource_group_name
  subnet_id           = module.network.subnet_id
  appId               = var.appId
  password            = var.password
  vm_size             = "Standard_B2ms"

  depends_on = [ module.network ]
}

module "registry" {
  source = "./modules/registry"

  location            = var.location
  resource_group_name = module.network.resource_group_name
  principal_id        = var.appId
}