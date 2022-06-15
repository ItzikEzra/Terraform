#create VM for DB
resource "azurerm_virtual_machine" "DBVM" {
  name                  = "DBVM"
  location              = var.location
  resource_group_name   = var.resourceGroupName
  network_interface_ids = [azurerm_network_interface.DB-NI.id]
  vm_size               = var.VMSize
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.UbuntuVersion
    version   = "latest"
  }
  storage_os_disk {
    name              = "Disk-DB"
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


resource "azurerm_network_interface" "DB-NI" {
  name                = "DB-NI"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "internal-IP-DBVM"
    subnet_id                     = azurerm_subnet.PublicSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}