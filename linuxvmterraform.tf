variable "subscriptionid" {
  type = "string"
}

variable "clientid" {
  type = "string"
}
variable "tenantid" {
  type = "string"
}
variable "clientsecret" {
  type = "string"
}

variable "location" {
    default = "centralus"
  
}

provider "azurerm" {
    subscription_id = "${var.subscriptionid}"
    client_id       = "${var.clientid}"
   client_secret   = "${var.clientsecret}"
   tenant_id       = "${var.tenantid}"
  
}

resource "azurerm_resource_group" "tfrg" {
    name = "suresh"
    location = "${var.location}"
  
}

resource "azurerm_virtual_network" "tfvnet" {
    name = "vnet"
    resource_group_name = "${azurerm_resource_group.tfrg.name}"
    address_space = ["10.10.0.0/16"]
    location = "${var.location}"
  
}

resource "azurerm_subnet" "tfsubnet" {
    name = "data"
    virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
    resource_group_name = "${azurerm_resource_group.tfrg.name}"
    address_prefix = "10.10.0.0/24"
  
}
resource "azurerm_subnet" "tfsubnet1" {
    name = "web"
    virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
    resource_group_name = "${azurerm_resource_group.tfrg.name}"
    address_prefix = "10.10.1.0/24"
}
resource "azurerm_public_ip" "tfpip" {
    name = "mypublicip"
    resource_group_name = "${azurerm_resource_group.tfrg.name}"
    location = "${var.location}"
    public_ip_address_allocation = "dynamic"
  
}

resource "azurerm_network_interface" "tfnic" {
    name = "myniccard"
    resource_group_name = "${azurerm_resource_group.tfrg.name}"
    location = "${var.location}"

    ip_configuration {
        name = "myipconfig"
        subnet_id = "${azurerm_subnet.tfsubnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.tfpip.id}"
    }
}
resource "azurerm_virtual_machine" "tfvm" {
    name = "terraformdevops"
    resource_group_name = "${azurerm_resource_group.tfrg.name}"
    location = "${var.location}"
    network_interface_ids = ["${azurerm_network_interface.tfnic.id}"]
    vm_size               = "Standard_B1s"

     storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
    }

    storage_os_disk {
        name              = "myosdisk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

  os_profile {
        computer_name  = "terraformdevops"
        admin_username = "qtdevops"
        admin_password = "motherindia@123"
    }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    connection {
      user     = "qtdevops"
      password = "motherindia@123"
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install apache2 -y"
    ]
  }
}

output "machineip" {
  value = "${azurerm_public_ip.tfpip.ip_address}"
}
  












