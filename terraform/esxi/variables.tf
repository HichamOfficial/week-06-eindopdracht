variable "disk_store" {
  description = "Datastore name in ESXi"
  type        = string
}

variable "memory_mb" {
  description = "VM memory size (MB)"
  type        = number
  default     = 1024
}

variable "num_cpus" {
  description = "Number of CPUs"
  type        = number
  default     = 1
}

variable "ovf_source" {
  description = "Path to the Ubuntu OVA/OVF file"
  type        = string
}

variable "network" {
  description = "ESXi network name"
  type        = string
  default     = "VM Network"
}
