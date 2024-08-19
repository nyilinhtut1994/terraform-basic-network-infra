variable "vpc_cidr_block" {

}

variable "name" {

}

variable "public_cidr" {
 default =  ["192.100.10.0/24", "192.100.20.0/24", "192.100.30.0/24"]
}

variable "private_cidr" {
 default = ["192.100.40.0/24", "192.100.50.0/24", "192.100.60.0/24"]
}

variable "availability_zone" {
 default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}