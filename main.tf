# 1. Configuration du fournisseur Azure
provider "azurerm" {
  features {}
}

# 2. Création du groupe de ressources
resource "azurerm_resource_group" "rg" {
  name     = "CountDemo"
  location = "eastus"
}

# 3. Définition du réseau virtuel (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "count-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# 4. Création du sous-réseau (Subnet)
resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/26"]
}

# 5. Création des interfaces réseau (NIC) avec la fonction count
resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "nic-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  # Dépendance explicite pour s'assurer que le subnet existe avant la NIC
  depends_on = [azurerm_subnet.subnet]
}

# 6. Création des machines virtuelles (VM)
# Le paramètre count permet de créer plusieurs instances avec un identifiant unique via count.index [1]
resource "azurerm_virtual_machine" "vm" {
  count                 = 2
  name                  = "vm-${count.index + 1}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  # Note : Pour que ce code soit complet, Azure nécessite généralement 
  # un bloc 'storage_os_disk' et 'os_profile' (non fournis dans votre snippet initial).
  storage_os_disk {
    name              = "myosdisk-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname-${count.index + 1}"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}