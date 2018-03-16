## Managed Disk

resource "azurerm_managed_disk" "disk" {
  name                 = "Chef"
  location             = "${azurerm_resource_group.rg.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"
}

## Linux VM

resource "azurerm_virtual_machine" "vm" {
  name                  = "ChefLinux-VM"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
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
    admin_username = "root"
    admin_password = "${var.Computer_Password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    createdby = "Terraform"
    purpose = "Chef-AGL"
}

}
