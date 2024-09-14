output "resource_group_name" {
  value = azurerm_resource_group.default.name
}

output "subnet_id" {
  value = azurerm_subnet.default.id
}