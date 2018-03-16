## Security Group

output "Security_Group_ID" {
description = "SecurityGroup ID"
  value = "${azurerm_network_security_group.securitygroup.id}"
}

## Public IP

output "Public_IP"{
description = "Public IP"
value = "${azurerm_public_ip.eip.ip_address}"
}

## Private IP

output "Private_IP"{
value = "${azurerm_network_interface.networkinterface.private_ip_address}"
}

## VM ID

output "VM_ID"{
value = "${azurerm_virtual_machine.vm.id}"
}

## Network Interface

output "Network_Interface" {
value = "${azurerm_network_interface.networkinterface.id}"
}

## Resource Group

output "Resourrce_Group_Location" {
value = "${azurerm_resource_group.rg.location}"
}

output "Resourrce_Group_Name" {
value = "${azurerm_resource_group.rg.name}"
}

