terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-backend-rg"
    storage_account_name = "tfstateweek916023184876"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
