#create network interface for DBvm
resource "azurerm_network_interface" "DB-NI" {
  name                = "DB-NI"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "internal-IP-DBVM"
    subnet_id                     = azurerm_subnet.PrivateSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
#create DBVM using vm module
module "DBVM" {
  source = "./VMmodule"
  UbuntuVersion = var.UbuntuVersion
  VMSize = var.VMSize
  diskName = "Disk-DB"
  location = var.location
  machineName = "DBVM"
  networkInterfaceid =[azurerm_network_interface.DB-NI.id]
  password = var.password
  resourceGroupName = var.resourceGroupName
  username = var.username
}