terraform {
  backend "azurerm" {
    resource_group_name  = "devops-week9-rg"
    storage_account_name = "tfstateweek916020725437"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
