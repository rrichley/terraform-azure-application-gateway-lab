variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "ContosoResourceGroup"
}

variable "vnet_cidr" {
  description = "VNet address space"
  type        = string
  default     = "10.0.0.0/16"
}
