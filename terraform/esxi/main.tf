terraform {
  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "~> 1.6"
    }
  }
}

locals {
  ssh_key                       = file(var.ssh_public_key_path)
  ssh_azure_private_key_base64  = base64encode(file(var.ssh_azure_private_key_path))
}


data "template_file" "Default" {
  template = file("${path.module}/userdata.yml")
  vars = {
    ssh_key = local.ssh_key
    ssh_azure_private_key_base64 = local.ssh_azure_private_key_base64
  }
}

resource "esxi_guest" "esxi_app_vm" {
  guest_name = "esxi-portainer"
  disk_store = var.disk_store
  ovf_source = var.ubuntu_image_url

  network_interfaces {
    virtual_network = var.virtual_network
  }

  guestinfo = {
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.Default.rendered)
  }

  memsize = 1024
  numvcpus = 1
}
