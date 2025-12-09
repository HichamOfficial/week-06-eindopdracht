output "azure_ip" {
  value = module.azure_app.azure_vm_public_ip
}

output "esxi_ip" {
  value = module.esxi_app.esxi_vm_ip
}

resource "local_file" "ansible_inventory" {
  depends_on = [module.azure_app]
  content = templatefile("${path.module}/inventory.tpl", {
    azure_ip = module.azure_app.azure_vm_public_ip
    esxi_ip  = module.esxi_app.esxi_vm_ip
  })
  filename = "${path.module}/../ansible/inventory.ini"
}
