variable "esxi_mngmt_host" {
  type    = string
  default = "192.168.1.60"
}

variable "esxi_mngmt_ssh_port" {
  type    = number
  default = 22
}

variable "esxi_mngmt_https_port" {
  type    = number
  default = 443
}

variable "esxi_mngmt_user" {
  type = string
}

variable "esxi_mngmt_password" {
  type      = string
  sensitive = true
}

variable "azure_mngmt_subscription_id" {
  type      = string
  sensitive = true
}

variable "ssh_public_key" {
  type = string
}

variable "ssh_private_key" {
  type = string
}
