variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "6490c530-4945-4ec0-87f4-536adda320b2"
  sensitive   = true
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "nginx-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "centralindia"
}

variable "availability_zone" {
  description = "Availability Zone (1, 2, or 3)"
  type        = string
  default     = "1"
}

variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
  default     = "nginx-vm"
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_B2ats_v2"
}

variable "public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_source_address" {
  description = "Source IP address/CIDR for SSH access (use your IP for security)"
  type        = string
  default     = "*" # Change this to restrict SSH access
}
