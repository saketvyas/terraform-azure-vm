output "resource_group_name" {
  description = "Name of the Resource Group"
  value       = azurerm_resource_group.nginx.name
}

output "vm_id" {
  description = "ID of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.nginx.id
}

output "vm_name" {
  description = "Name of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.nginx.name
}

output "public_ip_address" {
  description = "Public IP address of the Nginx server"
  value       = azurerm_public_ip.nginx.ip_address
}

output "nginx_url" {
  description = "URL to access Nginx"
  value       = "http://${azurerm_public_ip.nginx.ip_address}"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i <your-private-key> azureuser@${azurerm_public_ip.nginx.ip_address}"
}

output "private_ip_address" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.nginx.private_ip_address
}

output "virtual_network_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.nginx.id
}

output "network_security_group_id" {
  description = "ID of the Network Security Group"
  value       = azurerm_network_security_group.nginx.id
}
