resource "azurerm_kubernetes_cluster" "default" {
  name                = "demo-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "demo-k8s"

  default_node_pool {
    name                = "default"
    vm_size             = var.vm_size
    os_sku              = "Ubuntu"
    os_disk_size_gb     = 30
    vnet_subnet_id      = var.subnet_id
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