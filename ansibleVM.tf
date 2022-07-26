/*module "AnsibleVM" {
  source = "./VMmodule"

  UbuntuVersion = var.UbuntuVersion
  VMSize = "Standard_DS1_v2"
  location = var.location
  machineName = "Agent"
  networkInterfaceid = [azurerm_network_interface.NIC-Ansible.id]
  password = var.password
  resourceGroupName = var.resourceGroupName
  username = var.username
  diskName = "Disk-Agent"
}
resource "azurerm_network_interface" "NIC-Ansible" {
  name                = "NI-Agent"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "internal-IP-Agent"
    subnet_id                     = azurerm_subnet.PublicSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

*/