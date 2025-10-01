variable "public_key" {
  description = "Publieke SSH key voor de VM's"
  type        = string
}

variable "ssh_username" {
  default     = "student"
}

variable "memory_mb" {
  description = "RAM grootte per VM"
  type        = number
  default     = 2048
}

variable "num_cpus" {
  description = "Aantal vCPU's per VM"
  type        = number
  default     = 1
}

variable "disk_store" {
  description = "Naam van de datastore op ESXi"
  type        = string
  default     = "datastore1"
}

variable "ovf_source" {
  description = "Pad naar het Ubuntu cloud image"
  type        = string
  default     = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"
}

variable "network" {
  description = "Virtueel netwerk in ESXi"
  type        = string
  default     = "VM Network"
}
