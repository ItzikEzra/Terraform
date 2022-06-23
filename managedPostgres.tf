
resource "azurerm_postgresql_flexible_server" "psqlservice" {
  name                   = var.psqlservicesName
  resource_group_name    = azurerm_resource_group.resourceGroup.name
  location               = var.location
  version                = "13"
  delegated_subnet_id    = azurerm_subnet.PrivateSubnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.dns.id
  administrator_login    = var.postgres_username
  administrator_password = var.postgres_password
  zone                   = "1"
  create_mode            = "Default"
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  depends_on             = [azurerm_private_dns_zone_virtual_network_link.dns_link]

  # database

}
resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.mangedPostgresName
  server_id = azurerm_postgresql_flexible_server.psqlservice.id
  collation = "en_US.utf8"
  charset   = "utf8"

}

# fw

resource "azurerm_postgresql_flexible_server_firewall_rule" "fwconfig" {
  name      = "example-fw"
  server_id = azurerm_postgresql_flexible_server.psqlservice.id

  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
# diseble ssl
resource "azurerm_postgresql_flexible_server_configuration" "flexible_server_configuration" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.psqlservice.id
  value     = "off"
}

resource "azurerm_private_dns_zone" "dns" {
  name                = "tracker.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.resourceGroup.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "dns_link"
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = azurerm_virtual_network.Vnet-week05.id
  resource_group_name   = azurerm_resource_group.resourceGroup.name
}