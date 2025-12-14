variable "subscription_id" {
  type        = string
  sensitive = true
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "S1183761"
}

variable "location" {
  description = "Azure location"
  type        = string
  default     = "West Europe"
}

variable "ssh_key_name" {
  type        = string
  default     = "student"
  sensitive = true
}

variable "ssh_public_key" {
  type = string
}
