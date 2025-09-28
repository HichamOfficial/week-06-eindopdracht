variable "ssh_username" {
  description = "SSH username for the VM"
  type        = string
  default     = "student"
}

variable "public_key" {
  description = "SSH public key"
  type        = string
}
