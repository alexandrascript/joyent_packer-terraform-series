variable "triton_account" {
    default = "<username>"
}

variable "triton_key_id" {
    default = "<fingerprint>"
}

variable "dc_name" {
    default = "<dc_name>"
}

variable "service_name" {
    type = "string"
    description = "The name of the service in CNS."
    default = "cats"
}

variable "service_networks" {
    type = "list"
    description = "The name or ID of one or more networks the service will operate on."
    default = ["Joyent-SDC-Public"]
}

variable "image_name" {
	type = "string"
    description = "The name of the image for the deployment."
    default = "cats_randomizer"
}

variable "image_version" {
    type = "string"
    description = "The version of the image for the deployment."
    default = "1.0.0"
}

variable "package_name" {
    type = "string"
    description = "The package to use when making a deployment."
    default = "g4-highcpu-128M" 
}