## Provider

provider "azurerm" {
 subscription_id = "${var.subscription_id}"
 tenant_id = "${var.tenant_id}"
 client_id = "${var.client_id}"
 client_secret = "${var.client_secret}"
}

## Resource Group

data "azurerm_resource_group" "rg" {
  name = "CloudPractice-SCE"
}

## Security Group

resource "azurerm_network_security_group" "securitygroup" {
  name                = "SCE-terraform"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
tags {
    createdby = "Terraform"
  }
  security_rule {
    name                       = "All-TCP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

## Vnet

data "azurerm_virtual_network" "vnet" {
  name                 = "CloudPractice-SCE-vnet"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

## Subnet

data "azurerm_subnet" "subnet" {
  name                 = "default"
  virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

## Public IP

resource "azurerm_public_ip" "eip" {
  name                         = "Terraform-eip"
  location                     = "${data.azurerm_resource_group.rg.location}"
  resource_group_name          = "${data.azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "static"

  tags {
    createdby = "Terraform"
  }
}

## Network Interface

resource "azurerm_network_interface" "networkinterface" {
  name                = "Terraform-NetworkInterface"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.securitygroup.id}"
  tags {
        createdby = "Terraform"
    }
  ip_configuration {
    name                          = "Terraform"
    subnet_id                     = "${data.azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.eip.id}"
    }
}


## Managed Disk

resource "azurerm_managed_disk" "disk" {
  name                 = "Chef"
  location             = "${data.azurerm_resource_group.rg.location}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"
}

## Linux VM

resource "azurerm_virtual_machine" "vm" {
  name                  = "ChefLinux-VM"
  location              = "${data.azurerm_resource_group.rg.location}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.networkinterface.id}"]
  vm_size               = "Standard_DS1_v2"

  
   delete_os_disk_on_termination = true
  
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7.3"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.disk.name}"
    managed_disk_id = "${azurerm_managed_disk.disk.id}"
    create_option   = "Attach"
    lun             = 0
    disk_size_gb    = "${azurerm_managed_disk.disk.disk_size_gb}"
  }

  os_profile {
    computer_name  = "Chef"
    admin_username = "vineet"
    admin_password = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    createdby = "Terraform"
    purpose = "Chef-AGL"
}

}
