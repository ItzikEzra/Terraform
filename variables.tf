variable "psqlservicesName" {
  default = "psqlservicesname"
  
}
variable "mangedPostgresName" {
  default = "postgres-db"
  
}
variable "vnet-addressprefix" {
  default = ["10.0.0.0/16"]
  
}
variable "location" {
  type=string 
  default     = "eastus"
  description = "Choosen Location variable."
}
variable "resourceGroupName" {
  type=string 
  default     = "Staging"
  description = "Choosen Resource group name variable"
}

variable "VMSize" {
  default = "Standard_DS1_v2"
  description = "Choosen size for the VM variable"
}
variable "UbuntuVersion" {
  type = string
  default ="20_04-lts-gen2"
  description = "Choosen ubuntu version for the VM variable"
}