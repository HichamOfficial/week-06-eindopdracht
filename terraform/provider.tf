terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "=4.4.0" }
    esxi    = { source = "josenk/esxi", version = "~> 1.6" }
  }
}

provider "esxi" {
  esxi_hostname = var.esxi_mngmt_host
  esxi_hostport = var.esxi_mngmt_ssh_port
  esxi_hostssl  = var.esxi_mngmt_https_port
  esxi_username = var.esxi_mngmt_user
  esxi_password = var.esxi_mngmt_password
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = var.azure_mngmt_subscription_id
}