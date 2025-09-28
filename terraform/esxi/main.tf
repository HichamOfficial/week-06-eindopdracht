terraform {
  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "1.10.3"
    }
  }
}

provider "esxi" {
  esxi_hostname = "192.168.1.60"
  esxi_hostport = "22"
  esxi_hostssl  = "443"
  esxi_username = "root"
  esxi_password = "Welkom01!"
}

# Webservers
resource "esxi_guest" "webservers" {
  count      = 2
  guest_name = "webserver-${count.index + 1}"
  disk_store = var.disk_store
  memsize    = var.memory_mb
  numvcpus   = var.num_cpus
  ovf_source = var.ovf_source

  network_interfaces {
    virtual_network = var.network
  }
}

# Database server
resource "esxi_guest" "dbserver" {
  guest_name = "dbserver"
  disk_store = var.disk_store
  memsize    = var.memory_mb
  numvcpus   = var.num_cpus
  ovf_source = var.ovf_source

  network_interfaces {
    virtual_network = var.network
  }
}
