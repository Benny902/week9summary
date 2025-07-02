terraform {
  backend "azurerm" {
    resource_group_name  = "devops-week9-rg"
    storage_account_name = "tfstateweek916020817068"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
