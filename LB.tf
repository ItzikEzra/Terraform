resource "azurerm_public_ip" "AppLoadBalancerIP" {
  name                = "AppLoadBalancerIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "AppLoadBalancer" {
  name                = "FrontLoadBalancer"
  location            = var.location
  resource_group_name = var.resourceGroupName
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "LBPublicIPAddress"
    public_ip_address_id = azurerm_public_ip.AppLoadBalancerIP.id
  }

}

resource "azurerm_lb_backend_address_pool" "lb_back_pool_address" {
  name            = "BackendPool"
  loadbalancer_id = azurerm_lb.AppLoadBalancer.id

}

resource "azurerm_network_interface_backend_address_pool_association" "vm1-nic-assoc" {
  count = 3
  network_interface_id    = element(azurerm_network_interface.nics.*.id,count.index)
  ip_configuration_name   = "internal-IP-VM${count.index+1}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_back_pool_address.id
}
/*
resource "azurerm_network_interface_backend_address_pool_association" "vm2-nic-assoc" {
  network_interface_id    = azurerm_network_interface.NIC-APP-02.id
  ip_configuration_name   = "internal-IP-VM2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_back_pool_address.id
}
resource "azurerm_network_interface_backend_address_pool_association" "vm3-nic-assoc" {
  network_interface_id    = azurerm_network_interface.NIC-APP-03.id
  ip_configuration_name   = "internal-IP-VM3"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_back_pool_address.id
}

*/
resource "azurerm_lb_probe" "front_lb_probe" {
  resource_group_name = azurerm_resource_group.resourceGroup.name
  loadbalancer_id     = azurerm_lb.AppLoadBalancer.id
  name                = "front-probe-lb"
  port                = 8080
}
/*
resource "azurerm_lb_nat_rule" "natRule" {
  resource_group_name            = azurerm_resource_group.resourceGroup.name
  loadbalancer_id                = azurerm_lb.AppLoadBalancer.id
  name                           = "HTTPSAccess"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.AppLoadBalancer.frontend_ip_configuration[0].name
}
resource "azurerm_lb_rule" "FrontLBRuleTCP" {
  resource_group_name            = azurerm_resource_group.resourceGroup.name
  loadbalancer_id                = azurerm_lb.AppLoadBalancer.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = azurerm_lb.AppLoadBalancer.frontend_ip_configuration[0].name
  #probe_id                       = azurerm_lb_probe.front_lb_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_back_pool_address.id
}*/
resource "azurerm_lb_rule" "FrontLBRuleSSH" {
  resource_group_name            = azurerm_resource_group.resourceGroup.name
  loadbalancer_id                = azurerm_lb.AppLoadBalancer.id
  name                           = "LBRule22"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.AppLoadBalancer.frontend_ip_configuration[0].name
  #probe_id                       = azurerm_lb_probe.front_lb_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_back_pool_address.id
}


resource "azurerm_lb_rule" "FrontLBRule" {
  resource_group_name            = azurerm_resource_group.resourceGroup.name
  loadbalancer_id                = azurerm_lb.AppLoadBalancer.id
  name                           = "LBRule8080"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = azurerm_lb.AppLoadBalancer.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.front_lb_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_back_pool_address.id
}

