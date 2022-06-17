variable "location" {
  type=string 
  default     = "eastus"
  description = "Choosen Location variable."
}
variable "resourceGroupName" {
  type=string 
  default     = "Terraform-Week-05"
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