variable "public_key" {
  description = "Pad naar de publieke SSH key"
  type        = string
}

variable "ssh_username" {
  description = "Gebruikersnaam voor Azure VM's"
  type        = string
  default     = "iac"
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default = "80452be3-adee-4b39-ac16-56f3e1e38536"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-iac-se"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "Sweden Central"
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 2
}

variable "ssh_key_name" {
  description = "Name of the Azure SSH public key"
  type        = string
  default     = "skylab"
}