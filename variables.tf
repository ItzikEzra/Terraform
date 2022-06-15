variable "location" {
  type=string 
  default     = "eastus"
  description = "Location of the resource group."
}
variable "resourceGroupName" {
  type=string 
  default     = "Terraform-Week-05"
}

variable "VMSize" {
  default = "Standard_DS1_v2"
}
variable "UbuntuVersion" {
  type = string
  default = "18.04-LTS"
}