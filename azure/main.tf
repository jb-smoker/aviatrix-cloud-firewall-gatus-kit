resource "azurerm_resource_group" "this" {
  name     = "aviatrix"
  location = var.region
}

resource "azurerm_nat_gateway" "this" {
  location            = azurerm_resource_group.this.location
  name                = "aviatrix-nat"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_public_ip" "nat" {
  name                = "aviatrix-nat-ip"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

resource "azurerm_route_table" "public" {
  location            = azurerm_resource_group.this.location
  name                = "aviatrix-public"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_route_table" "private" {
  location            = azurerm_resource_group.this.location
  name                = "aviatrix-private"
  resource_group_name = azurerm_resource_group.this.name
}

module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.7.1"

  address_space       = [var.cidr]
  location            = azurerm_resource_group.this.location
  name                = "aviatrix"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "public" {
  count                           = var.number_of_subnets
  name                            = "public-${count.index + 1}"
  resource_group_name             = azurerm_resource_group.this.name
  virtual_network_name            = module.vnet.name
  address_prefixes                = [local.public_subnets[count.index]]
  default_outbound_access_enabled = true
}

resource "azurerm_subnet_route_table_association" "public" {
  count          = var.number_of_subnets
  subnet_id      = azurerm_subnet.public[count.index].id
  route_table_id = azurerm_route_table.public.id
}

resource "azurerm_subnet" "private" {
  count                           = var.number_of_subnets
  name                            = "private-${count.index + 1}"
  resource_group_name             = azurerm_resource_group.this.name
  virtual_network_name            = module.vnet.name
  address_prefixes                = [local.private_subnets[count.index]]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet_route_table_association" "private" {
  count          = var.number_of_subnets
  subnet_id      = azurerm_subnet.private[count.index].id
  route_table_id = azurerm_route_table.private.id
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  count          = var.number_of_subnets
  subnet_id      = azurerm_subnet.private[count.index].id
  nat_gateway_id = azurerm_nat_gateway.this.id
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"
}

module "gatus_instances" {
  count               = var.number_of_subnets
  source              = "Azure/avm-res-compute-virtualmachine/azurerm"
  version             = "0.18.0"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  name                = "gatus-az${count.index + 1}"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd1234!" # Use a more secure password or SSH key
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "24_04-lts-gen2"
    version   = "latest"
  }
  zone = count.index + 1
  network_interfaces = {
    network_interface_1 = {
      name = module.naming.network_interface.name_unique
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${module.naming.network_interface.name_unique}-ipconfig1"
          private_ip_subnet_resource_id = azurerm_subnet.private[count.index].id
        }
      }
    }
  }
}

# module "az_gatus1" {
#   for_each       = toset(local.cps)
#   source         = "github.com/aviatrix-internal-only-org/avxlabs-mc-instance"
#   name           = "${each.value}-egress-az1"
#   resource_group = azurerm_resource_group.paas.name
#   subnet_id      = module.vnet[each.value].subnets["subnet1"].resource_id
#   location       = azurerm_resource_group.this.location
#   cloud          = "azure"
#   instance_size  = "Standard_B1ms"
#   public_key     = local.tfvars.ssh_public_key
#   password       = local.tfvars.workload_instance_password
#   private_ip     = "10.2.${index(local.cps, each.value) + 1}.10"

#   user_data_templatefile = templatefile("${path.module}/templates/egress.tpl",
#     {
#       name     = "${each.value}-egress-az1"
#       https    = local.https
#       http     = local.http
#       password = local.tfvars.workload_instance_password
#       interval = "5"
#   })
# }

# module "az_gatus_dashboard" {
#   for_each       = toset(local.cps)
#   source         = "github.com/aviatrix-internal-only-org/avxlabs-mc-instance?ref=v1.0.9"
#   name           = "${each.value}-dashboard"
#   resource_group = azurerm_resource_group.paas.name
#   subnet_id      = module.vnet[each.value].subnets["subnet4"].resource_id
#   location       = azurerm_resource_group.this.location
#   cloud          = "azure"
#   public_key     = local.tfvars.ssh_public_key
#   password       = local.tfvars.workload_instance_password
#   instance_size  = "Standard_B1ms"
#   common_tags    = {}
#   public_ip      = true
#   inbound_tcp = {
#     22  = ["${chomp(data.http.myip.response_body)}/32"]
#     443 = [module.nginx.public_ip]
#   }

#   user_data_templatefile = templatefile("${path.module}/templates/dashboard.tpl",
#     {
#       name      = "${each.value}-dashboard"
#       gatus     = each.value
#       instances = ["${module.az_gatus1[each.value].private_ip}", "${module.az_gatus2[each.value].private_ip}", "${module.az_gatus3[each.value].private_ip}"]
#       pwd       = local.tfvars.workload_instance_password
#       cloud     = "Azure"
#   })
# }
