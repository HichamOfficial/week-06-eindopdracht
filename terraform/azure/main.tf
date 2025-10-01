terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.4.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id = var.subscription_id
}

resource "azurerm_ssh_public_key" "skylab" {
  name                = "week-06-skylab-key"
  location            = var.location
  resource_group_name = var.resource_group_name
  public_key          = file(var.public_key)
}

resource "azurerm_virtual_network" "vnet" {
  name                = "week-06-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "week-06-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}



# -------------------------------
# Network Security Group
# -------------------------------

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_group" "nsg" {
  name                = "week-06-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


# -------------------------------
# Public IP's
# -------------------------------
resource "azurerm_public_ip" "pip" {
  count               = var.vm_count
  name                = "week-06-pip-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# -------------------------------
# NIC's
# -------------------------------
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "week-06-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

# -------------------------------
# Linux VM's
# -------------------------------
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  # Als het de eerste VM is → webserver, anders database
  name = "week-06-azurevm-${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "iac"

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }


  admin_ssh_key {
    username   = "iac"
    public_key = azurerm_ssh_public_key.skylab.public_key
  }

custom_data = base64encode(templatefile("${path.module}/userdata.yaml", {
  ssh_key = azurerm_ssh_public_key.skylab.public_key
}))

} 


# ----------------- -------
# IP-adressen naar bestand (Azure)
# ------------------------

# Database IP
output "database_ip_azure" {
  value = azurerm_public_ip.pip[0].ip_address
}

# Webserver IP's (alle behalve de eerste)
output "webserver_ips_azure" {
  value = [for ip in slice(azurerm_public_ip.pip[*].ip_address, 1, length(azurerm_public_ip.pip[*].ip_address)) : ip]
}

# Bestand wegschrijven
resource "local_file" "azure_ips" {
  filename = "${path.module}/azure-ips.txt"
  content  = <<EOF
Azure:
${join("\n", azurerm_public_ip.pip[*].ip_address)}
EOF
}

