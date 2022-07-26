
# Create virtual network
resource "azurerm_virtual_network" "Vnet-week05" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
}
# Create subnet for public use
resource "azurerm_subnet" "PublicSubnet" {
  name                 = "APPsubnet"
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.Vnet-week05.name
  address_prefixes     = ["10.0.0.0/24"]
}
resource "azurerm_subnet" "PrivateSubnet" {
  name                 = "DBsubnet"
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.Vnet-week05.name
  address_prefixes     = ["10.0.2.0/24"]
  #   delegation for the DB
  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}
#create NSG
resource "azurerm_network_security_group" "PublicNSG" {
  name                = "public-NSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  security_rule {
    name                       = "8080"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "rule_22"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Port_8080"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [
    azurerm_resource_group.resourceGroup,
  ]
}
#create NSG
resource "azurerm_network_security_group" "PrivateNSG" {
  name                = "private-NSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  security_rule {
    name                       = "5432_ruleIn"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "5432"
    destination_port_range     = "5432"
    source_address_prefix      = "10.0.0.0/24"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "5432_ruleOut"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "5432"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.0.0/24"
  }
  /*
  security_rule {
    name                       = "22_rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.0.0/24"
    destination_address_prefix = "*"
  }
  */
  /*
    security_rule {
    name                       = "closeAzuredefault"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
  */
  depends_on = [
    azurerm_resource_group.resourceGroup,
  ]
}

resource "azurerm_subnet_network_security_group_association" "PublicNSG" {
  subnet_id                 = azurerm_subnet.PublicSubnet.id
  network_security_group_id = azurerm_network_security_group.PublicNSG.id
}

resource "azurerm_subnet_network_security_group_association" "PrivateNSG" {
  subnet_id                 = azurerm_subnet.PrivateSubnet.id
  network_security_group_id = azurerm_network_security_group.PrivateNSG.id
}

resource "azurerm_public_ip" "nat_ip" {
  name                = "nat-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_nat_gateway" "NatG" {
  name                    = "nat-Gateway"
  location                = var.location
  resource_group_name     = azurerm_resource_group.resourceGroup.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10

}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.NatG.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "AssocPrivate" {
  subnet_id      = azurerm_subnet.PrivateSubnet.id
  nat_gateway_id = azurerm_nat_gateway.NatG.id
}
resource "azurerm_subnet_nat_gateway_association" "AssocPublic" {
  subnet_id      = azurerm_subnet.PublicSubnet.id
  nat_gateway_id = azurerm_nat_gateway.NatG.id
}
##########################################
#Associate Neteork interfaces to NSG's
##########################################
resource "azurerm_network_interface_security_group_association" "AssocAPPVM1" {
  network_interface_id      = azurerm_network_interface.NIC-APP-01.id
  network_security_group_id = azurerm_network_security_group.PublicNSG.id
}

resource "azurerm_network_interface_security_group_association" "AssocAPPVM2" {
  network_interface_id      = azurerm_network_interface.NIC-APP-02.id
  network_security_group_id = azurerm_network_security_group.PublicNSG.id
}

resource "azurerm_network_interface_security_group_association" "AssocAPPVM3" {
  network_interface_id      = azurerm_network_interface.NIC-APP-03.id
  network_security_group_id = azurerm_network_security_group.PublicNSG.id
}
/*
resource "azurerm_network_interface_security_group_association" "AssocDBVM" {
  network_interface_id      = azurerm_postgresql_flexible_server.psqlservice.id
  network_security_group_id = azurerm_network_security_group.PrivateNSG.id
}*/