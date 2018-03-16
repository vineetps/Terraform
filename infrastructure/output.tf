
output "Resource_Group_Name" {
  value = "${azurerm_resource_group.rg.name}"
}

## Resource Group

output "Resource_Group_Location" {
  value = "${azurerm_resource_group.rg.location}"
}


## Network Interface

output "Network_Interface" {
  value = "${azurerm_network_interface.networkinterface.id}"
}


##Public IP

output "Public_IP" {
  value = "${azurerm_public_ip.eip.ip_address}"
}

## Private IP

output "Private_IP"{
value = "${azurerm_network_interface.networkinterface.private_ip_address}"
}

## Security Group

output "Security_Group_ID" {
description = "SecurityGroup ID"
  value = "${azurerm_network_security_group.securitygroup.id}"
}
