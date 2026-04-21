# Terraform Variables File for Azure Nginx VM

subscription_id      = "6490c530-4945-4ec0-87f4-536adda320b2"
location             = "centralindia"
availability_zone    = "1"
vm_size              = "Standard_B2ats_v2"
resource_group_name  = "nginx-rg"
vm_name              = "nginx-vm"
public_key_path      = "~/.ssh/id_rsa.pub"  # Update this path to your SSH public key
ssh_source_address   = "*"                   # Restrict this to your IP for security, e.g., "203.0.113.0/24"
