output "azure_ip" {
  value = module.azure_app.public_ip
}

output "esxi_ip" {
  value = module.esxi_app.vm_ip
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = templatefile("${path.module}/inventory.tpl", {
    azure_ip = module.azure_app.public_ip
    esxi_ip  = module.esxi_app.vm_ip
  })
}
