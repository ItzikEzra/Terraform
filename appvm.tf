module "APP-VM1" {
  source = "./VMmodule"

  UbuntuVersion = var.UbuntuVersion
  VMSize = var.VMSize
  location = var.location
  machineName = "APP-VM-01"
  networkInterfaceid = [azurerm_network_interface.NIC-APP-01.id]
  password = var.password
  resourceGroupName = var.resourceGroupName
  username = var.username
  diskName = "Disk-app-01"
}

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
}
/*
resource "azurerm_virtual_machine" "APPVM-01" {
  name                  = "APP-VM-01"
  location              = var.location
  resource_group_name   = var.resourceGroupName
  network_interface_ids = [azurerm_network_interface.NIC-APP-01.id]
  vm_size               = var.VMSize
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.UbuntuVersion
    version   = "latest"
  }
  storage_os_disk {
    name              = "Disk-app-01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.username
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "APPVM-02" {
  name                  = "APP-VM-02"
  location              = var.location
  resource_group_name   = var.resourceGroupName
  network_interface_ids = [azurerm_network_interface.NIC-APP-02.id]
  vm_size               = var.VMSize
delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.UbuntuVersion
    version   = "latest"
  }
  storage_os_disk {
    name              = "Disk-app-02"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.username
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}
resource "azurerm_virtual_machine" "APPVM-03" {
  name                  = "APP-VM-03"
  location              = var.location
  resource_group_name   = var.resourceGroupName
  network_interface_ids = [azurerm_network_interface.NIC-APP-03.id]
  vm_size               = var.VMSize
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.UbuntuVersion
    version   = "latest"
  }
  storage_os_disk {
    name              = "Disk-app-03"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.username
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}*/
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