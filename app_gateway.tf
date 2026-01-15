resource "azurerm_public_ip" "ag_pip" {
  name                = "AGPublicIPAddress"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "agw" {
  name                = "ContosoAppGateway"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.ag_subnet.id
  }

  frontend_port {
    name = "httpPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "publicFrontend"
    public_ip_address_id = azurerm_public_ip.ag_pip.id
  }

  backend_address_pool {
    name = "BackendPool"

    ip_addresses = [
      azurerm_linux_virtual_machine.backend_vm_1.private_ip_address,
      azurerm_linux_virtual_machine.backend_vm_2.private_ip_address
    ]
  }

  backend_http_settings {
    name                  = "HTTPSetting"
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
    request_timeout       = 20
  }

  http_listener {
    name                           = "Listener"
    frontend_ip_configuration_name = "publicFrontend"
    frontend_port_name             = "httpPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "RoutingRule"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = "Listener"
    backend_address_pool_name  = "BackendPool"
    backend_http_settings_name = "HTTPSetting"
  }

  # ✅ REQUIRED: Explicit modern TLS policy
  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }
}
