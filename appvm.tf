#create app vms using module 
module "APP-VM1" {
  source = "./VMmodule"
count = 3
  UbuntuVersion = var.UbuntuVersion
  VMSize = var.VMSize
  location = var.location
  machineName = "APP-VM-0${count.index+1}"
  
  networkInterfaceid = [element(azurerm_network_interface.nics.*.id,count.index)]
  password = var.password
  resourceGroupName = var.resourceGroupName
  username = var.username
  diskName = "Disk-app-0${count.index+1}"
}
resource "azurerm_network_interface" "nics" {
  count = 4
  name                = "NI-APP-0${count.index+1}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "internal-IP-VM${count.index+1}"
    subnet_id                     = azurerm_subnet.PublicSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}


/*
module "APP-VM2" {
  source = "./VMmodule"

  UbuntuVersion = var.UbuntuVersion
  VMSize = var.VMSize
  location = var.location
  machineName = "APP-VM-02"
  networkInterfaceid = [azurerm_network_interface.NIC-APP-02.id]
  password = var.password
  resourceGroupName = var.resourceGroupName
  username = var.username
  diskName = "Disk-app-02"
}

module "APP-VM3" {
  source = "./VMmodule"

  UbuntuVersion = var.UbuntuVersion
  VMSize = var.VMSize
  location = var.location
  machineName = "APP-VM-03"
  networkInterfaceid = [azurerm_network_interface.NIC-APP-03.id]
  password = var.password
  resourceGroupName = var.resourceGroupName
  username = var.username
  diskName = "Disk-app-03"
}*/
#create NI for vms
/*
resource "azurerm_network_interface" "NIC-APP-01" {
  name                = "NI-APP-01"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "internal-IP-VM1"
    subnet_id                     = azurerm_subnet.PublicSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "NIC-APP-02" {
  name                = "NI-APP-02"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "internal-IP-VM2"
    subnet_id                     = azurerm_subnet.PublicSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_network_interface" "NIC-APP-03" {
  name                = "NI-APP-03"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "internal-IP-VM3"
    subnet_id                     = azurerm_subnet.PublicSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
*/
