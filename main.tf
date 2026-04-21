terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Resource Group
resource "azurerm_resource_group" "nginx" {
  name       = var.resource_group_name
  location   = var.location

  tags = {
    Environment = "production"
    Name        = "nginx-rg"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "nginx" {
  name                = "${var.vm_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.nginx.location
  resource_group_name = azurerm_resource_group.nginx.name

  tags = {
    Name = "nginx-vnet"
  }
}

# Subnet
resource "azurerm_subnet" "nginx" {
  name                 = "${var.vm_name}-subnet"
  resource_group_name  = azurerm_resource_group.nginx.name
  virtual_network_name = azurerm_virtual_network.nginx.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "nginx" {
  name                = "${var.vm_name}-nsg"
  location            = azurerm_resource_group.nginx.location
  resource_group_name = azurerm_resource_group.nginx.name

  # Allow HTTP
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTPS
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow SSH
  security_rule {
    name                       = "AllowSSH"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh_source_address
    destination_address_prefix = "*"
  }

  tags = {
    Name = "nginx-nsg"
  }
}

# Network Interface
resource "azurerm_network_interface" "nginx" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.nginx.location
  resource_group_name = azurerm_resource_group.nginx.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.nginx.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nginx.id
  }

  tags = {
    Name = "nginx-nic"
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "nginx" {
  subnet_id                 = azurerm_subnet.nginx.id
  network_security_group_id = azurerm_network_security_group.nginx.id
}

# Public IP
resource "azurerm_public_ip" "nginx" {
  name                = "${var.vm_name}-pip"
  location            = azurerm_resource_group.nginx.location
  resource_group_name = azurerm_resource_group.nginx.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [var.availability_zone]

  tags = {
    Name = "nginx-pip"
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "nginx" {
  name                = var.vm_name
  location            = azurerm_resource_group.nginx.location
  resource_group_name = azurerm_resource_group.nginx.name
  size                = var.vm_size
  zone                = var.availability_zone

  admin_username = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  network_interface_ids = [
    azurerm_network_interface.nginx.id,
  ]

  custom_data = base64encode(templatefile("${path.module}/user_data.sh", {}))

  tags = {
    Name = "nginx-vm"
  }
}
