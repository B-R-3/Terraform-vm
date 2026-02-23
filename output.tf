output "resource_group_id" {
  description = "L'ID du groupe de ressources créé"
  value       = azurerm_resource_group.tp_rg.id
}

output "vnet_name" {
  description = "Le nom du réseau virtuel"
  value       = azurerm_virtual_network.tp_vnet.name
}

output "subnet_id" {
  description = "L'ID du subnet"
  value       = azurerm_subnet.tp_subnet.id
}

output "load_balancer_public_ip" {
  description = "L'IP publique pour accéder aux serveurs Nginx"
  value       = azurerm_public_ip.lb_pip.ip_address
}