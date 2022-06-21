variable "location" {}
variable "resourceGroupName" {}
variable "VMSize" {}
variable "UbuntuVersion" {}
variable "username" {}
variable "password" {}
variable "networkInterfaceid" {}
variable "machineName" {}
variable "diskName" {}
resource "azurerm_virtual_machine" "VM" {
 # name                  = var.machineName
  name =                var.machineName
  location              = var.location
  resource_group_name   = var.resourceGroupName
  network_interface_ids = var.networkInterfaceid
  vm_size               = var.VMSize
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = var.UbuntuVersion
    version   = "latest"
  }
  storage_os_disk {
    name              = var.diskName
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