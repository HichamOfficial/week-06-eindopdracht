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

locals {
  templatevars = {
    public_key   = file(var.public_key)
    ssh_username = var.ssh_username
  }
}

# ------------------------
# 2 Webservers
# ------------------------
resource "esxi_guest" "webservers" {
  count      = 2
  guest_name = "week-06-webserver${count.index + 1}"
  disk_store = var.disk_store
  memsize    = var.memory_mb
  numvcpus   = var.num_cpus
  ovf_source = var.ovf_source

  network_interfaces {
    virtual_network = var.network
  }

  guestinfo = {
  "userdata"          = base64encode(templatefile("${path.module}/userdata.yaml", local.templatevars))
  "userdata.encoding" = "base64"
}


}

# ------------------------
# 1 Database server
# ------------------------
resource "esxi_guest" "dbserver" {
  guest_name = "week-06-database"
  disk_store = var.disk_store
  memsize    = var.memory_mb
  numvcpus   = var.num_cpus
  ovf_source = var.ovf_source

  network_interfaces {
    virtual_network = var.network
  }

guestinfo = {
  "userdata"          = base64encode(templatefile("${path.module}/userdata.yaml", local.templatevars))
  "userdata.encoding" = "base64"
}


}

# ------------------------
# IP-adressen naar bestand
# ------------------------
resource "local_file" "write_ips_to_file" {
  filename = "${path.module}/vm-ips.txt"
  content  = <<EOF
Webservers:
${join("\n", [for instance in esxi_guest.webservers : instance.ip_address])}

Database Server:
${esxi_guest.dbserver.ip_address}
EOF
}

output "webserver_ips" {
  value = [for instance in esxi_guest.webservers : instance.ip_address]
}

output "database_ip" {
  value = esxi_guest.dbserver.ip_address
}
