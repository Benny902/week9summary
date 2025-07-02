# week9summary
# Week 9 – Summary Task: Terraform on Azure

this is built on top of 'week8summary' - https://github.com/Benny902/week8summary  
with the addition Objective of week 9 summary task:

### Objective
Create a complete infrastructure solution using Terraform on Azure, including networking, VM provisioning, remote state storage, and optional CI/CD automation. Document all steps and ensure a working deployment.

---

### GitHubSecrets Required (Settings > Secrets and variables > Actions): 
- VM_SSH_KEY → Contents of the private ~/.ssh/id_rsa file (not the .pub!)
- AZURE_CREDENTIALS → A service principal in JSON format to allow azure/login

<br>

Create `VM_SSH_KEY` with:
```bash
ssh-keygen -t rsa -b 2048
```
- copy the Contents of the private ~/.ssh/id_rsa file (not the .pub!) into the `VM_SSH_KEY` secret

<br>

Create `AZURE_CREDENTIALS` with:
```bash
# to login:
az login --use-device-code

# to see list of accounts associated and verify which is set as default.
az account list --output table

# then create with this: (replaced <SubscriptionId> with mine)
az ad sp create-for-rbac \
  --name "gh-actions" \
  --role contributor \
  --scopes "/subscriptions/<SubscriptionId>" \
  --sdk-auth
```
- copy the entire json output into the `AZURE_CREDENTIALS` secret

---

### Install and Configure Terraform

#### Install terraform
```bash
sudo snap install terraform --classic
```

- check that install successful `terraform -v`

---

### Create initial main.tf and initialize:
```bash
touch main.tf
terraform init
```

### Create main.tf and Define Infrastructure Resources

#### Create additional folder structure for modules  

```css
terraform-rg/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    ├── resource_group/
    │   └── main.tf
    ├── network/
    │   └── main.tf
    └── vm/
        └── main.tf
```

### `modules/resource_group/main.tf`
```bash
resource "azurerm_resource_group" "devops_rg" {
  name     = var.name
  location = var.location
}
```

### `modules/resource_group/variables.tf`
```bash
variable "name" {}
variable "location" {}
```

### `modules/resource_group/outputs.tf`
```bash
output "name" {
  value = azurerm_resource_group.devops_rg.name
}

output "location" {
  value = azurerm_resource_group.devops_rg.location
}

output "id" {
  value = azurerm_resource_group.devops_rg.id
}
```

### `modules/network/main.tf`
```bash
resource "azurerm_virtual_network" "vnet" {
  name                = "week9-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "week9-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "week9-nsg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "week9-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "nic" {
  name                = "week9-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}
```

### `modules/network/variables.tf`
```bash
variable "location" {}
variable "rg_name" {}
```

### `modules/network/outputs.tf`
```bash
output "nic_id" {
  value = azurerm_network_interface.nic.id
}

output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}
```

### `modules/vm/main.tf`
```bash
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = var.rg_name
  location              = var.location
  size                  = "Standard_B1ls"
  admin_username        = var.admin_username
  network_interface_ids = [var.nic_id]

  depends_on = [var.public_ip_dep]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
```

### `modules/vm/variables.tf`
```bash
variable "vm_name" {}
variable "location" {}
variable "rg_name" {}
variable "admin_username" {}
variable "ssh_public_key" {}
variable "nic_id" {}
variable "public_ip_dep" {}
```

### Root `main.tf`:

```bash
provider "azurerm" {
  features {}
}

module "rg" {
  source   = "./modules/resource_group"
  name     = "devops-week9-rg"
  location = var.location
}

module "network" {
  source  = "./modules/network"
  rg_name = module.rg.name
  location = var.location
}

module "vm" {
  source           = "./modules/vm"
  rg_name          = module.rg.name
  location         = var.location
  vm_name          = var.vm_name
  admin_username   = var.admin_username
  ssh_public_key   = var.ssh_public_key
  nic_id           = module.network.nic_id
  public_ip_dep    = module.network

  depends_on = [module.network]
}
```

`variables.tf`:
```bash
variable "location" {
  default = "West Europe"
}

variable "vm_name" {
  default = "week9vm"
}

variable "admin_username" {
  default = "azureuser"
}

variable "ssh_public_key" {}
```

`outputs.tf`:
```bash
# Resource Group Outputs
output "rg_name" {
  value = module.rg.name
}

output "rg_location" {
  value = module.rg.location
}

output "rg_id" {
  value = module.rg.id
}

# Network Outputs
output "nic_id" {
  value = module.network.nic_id
}

output "public_ip_address" {
  value = module.network.public_ip
}
```

### Initialize and Apply



---

## Configure Remote State with Azure Storage (with Logging & Debugging)

### Create Storage Account & Container for Remote State
