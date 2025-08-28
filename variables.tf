variable "project_name" {
  type        = string
}

variable "region" {
    type = string
}

variable "vpc_cidr" {
  type = string
  default = "CIDR principal da VPC"
}

variable "vpc_additional_cidrs" {
  type = list(string)
  description = "Lista de CIDRs adicionais para a VPC"
  default = []
  
}

variable "public_subnets" {
  description = "Lista de subnets públicas"
  type = list(object({
    name = string
    cidr_block = string
    az         = string
  }))  
}

variable "private_subnets" {
  description = "Lista de subnets privadas"
  type = list(object({
    name = string
    cidr_block = string
    az         = string
  }))  
}