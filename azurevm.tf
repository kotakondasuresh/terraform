provider "azurerm" {
    subscription_id = "674d6d57-6944-4d08-8496-f65351ecbada"
 client_id = "8a66fe46-e7c4-4411-8285-405920d2b433",
  client_secret = "459b6d82-e2d1-49c9-8b17-dde6f5bb56c3",
  tenant_id = "35b71a3a-b0f0-40c3-984d-7564631b539a"
  
}

#resourse group 

resource "azurerm_resource_group" "tfgroup" {
    name = "suresh"
    location = "centralus"
}

#virtual network

resource "azurerm_virtual_network" "tfvnet" {
    name = "vnet-1"
    resource_group_name = "${azurerm_resource_group.tfgroup.name}"
    location = "${azurerm_resource_group.tfgroup.location}"
    address_space = ["10.10.0.0/16"]
}

# virtual subnet 

resource "azurerm_subnet" "tfsubnet" {
    name = "data"
    resource_group_name = "${azurerm_resource_group.tfgroup.name}"
    virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
    address_prefix = "10.10.0.0/24"
  
}
