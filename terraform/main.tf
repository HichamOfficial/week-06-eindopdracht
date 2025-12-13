module "esxi_app" {
  source = "./esxi"

  esxi_host     = var.esxi_mngmt_host
  esxi_user     = var.esxi_mngmt_user
  esxi_password = var.esxi_mngmt_password

  ssh_public_key  = var.ssh_public_key
  ssh_private_key = var.ssh_private_key
}

module "azure_app" {
  source = "./azure"

  subscription_id = var.azure_mngmt_subscription_id
  ssh_public_key  = var.ssh_public_key
}
