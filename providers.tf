terraform {

   required_version = ">=0.12"

   required_providers {
     azurerm = {
       source = "hashicorp/azurerm"
       version = "~>2.0"
     }
   }
   backend "azurerm" {
    resource_group_name  = "tfstateRG01"
    storage_account_name = "tfstate011226676390"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"

}
 }




 provider "azurerm" {
   features {}
 }
