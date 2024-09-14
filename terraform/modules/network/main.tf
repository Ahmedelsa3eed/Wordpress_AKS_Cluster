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