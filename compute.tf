resource "azurerm_network_interface" "backend_nic_1" {
  name                = "BackendVM1-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.backend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "backend_nic_2" {
  name                = "BackendVM2-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.backend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "backend_vm_1" {
  name                = "BackendVM1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"

  admin_username = "azureuser"
  admin_password = "Password1234!"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.backend_nic_1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "backend_vm_2" {
  name                = "BackendVM2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"

  admin_username = "azureuser"
  admin_password = "Password1234!"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.backend_nic_2.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
resource "azurerm_virtual_machine_extension" "backend_vm_1_nginx" {
  name                 = "nginx"
  virtual_machine_id   = azurerm_linux_virtual_machine.backend_vm_1.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
{
  "commandToExecute": "sudo apt-get update && sudo apt-get install -y nginx && echo 'BackendVM1' | sudo tee /var/www/html/index.html"
}
SETTINGS
}
resource "azurerm_virtual_machine_extension" "backend_vm_2_nginx" {
  name                 = "nginx"
  virtual_machine_id   = azurerm_linux_virtual_machine.backend_vm_2.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
{
  "commandToExecute": "sudo apt-get update && sudo apt-get install -y nginx && echo 'BackendVM2' | sudo tee /var/www/html/index.html"
}
SETTINGS
}
