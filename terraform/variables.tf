variable "esxi_app_host" {
  description = "The FQDN/IP of the ESXI host"
  type        = string
  default     = "192.168.1.60"
}

variable "esxi_app_ssh_port" {
  description = "The SSH port use for the esxi_app module to connect over SSH."
  type        = number
  default     = 22
}

variable "esxi_app_https_port" {
  description = "The https port use for the esxi_app module to connect over https."
  type        = number
  default     = 443
}

variable "esxi_app_user" {
  description = "The username the esxi_app module uses to connect to the esxi host."
  type        = string
}

variable "esxi_app_password" {
  description = "The password for the user the esxi_app module uses to connect to the esxi host."
  type        = string
  sensitive   = true
}

variable "azure_app_subscription_id" {
  description = "The subcription_id used for the azure provider."
  type        = string
  sensitive   = true
}