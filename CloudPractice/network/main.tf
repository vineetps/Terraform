#################################################################

## Vnet

resource "azurerm_virtual_network" "vnet" {
  name                = "Terraform-VNet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}
 
## Subnet- Public A

resource "azurerm_subnet" "PublicSubnetA" {
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    name           = "PublicSubnetA"
    address_prefix = "10.0.1.0/24"
  }

## Subnet- Private A

resource "azurerm_subnet" "PrivateSubnetA" {
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    name           = "PrivateSubnetA"
    address_prefix = "10.0.2.0/24"
  }


## Subnet- Public B

resource "azurerm_subnet" "PublicSubnetB" {
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    name           = "PublicSubnetB"
    address_prefix = "10.0.3.0/24"
  }

## Subnet- Private B

resource "azurerm_subnet" "PrivateSubnetB" {
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    name           = "PrivateSubnetB"
    address_prefix = "10.0.4.0/24"
  }


## Security Group

resource "azurerm_network_security_group" "securitygroup" {
    name                = "Terraform-SG"
    location            = "westus"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    tags {
       createdby  = "Terraform"
    }    
}

## Security Group Ingress

resource "azurerm_network_security_rule" "ingress" {
        name                       = "Any"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
	resource_group_name         = "${azurerm_resource_group.rg.name}"
  	network_security_group_name = "${azurerm_network_security_group.securitygroup.name}"
    }


## Public IP

resource "azurerm_public_ip" "eip" {
  name                         = "Terraform-PublicIP"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Static"
  domain_name_label = "linuxdemo"
  tags {
   createdby = "Terraform"
  }
}

## Network Interface- Private IP

resource "azurerm_network_interface" "networkinterface" {
  name                = "Terraform-NetworkInterface"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.securitygroup.id}"
  tags {
        createdby = "Terraform"
    }
  ip_configuration {
    name                          = "Terraform"
    subnet_id                     = "${azurerm_subnet.PublicSubnetA.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.eip.id}"
    }
}

## Route Table


resource "azurerm_route_table" "routetable" {
  name                = "Terraform-Routetable"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_route" "routeentry" {
  name                = "Terraform_RouteEnry"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  route_table_name    = "${azurerm_route_table.routetable.name}"
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "internet"
}
