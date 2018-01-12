#
# Details about all deployments of this application
#
variable "service_production" {
  type        = "string"
  description = "Which deployment is considered 'production'? The other is 'staging'. Value can be one of 'blue' or 'green'."
  default     = "blue"
}

variable "service_name" {
  type        = "string"
  description = "The name of the service in CNS."
  default     = "happiness"
}

variable "service_networks" {
  type    = "list"
  default = ["Joyent-SDC-Public"]
}

#
# Details about the "blue" deployment
#
variable "blue_image_name" {
  type        = "string"
  description = "The name of the image for the 'blue' deployment."
  default     = "happy_randomizer"
}

variable "blue_image_type" {
  type    = "string"
  default = "lx-dataset"
}

variable "blue_image_version" {
  type        = "string"
  description = "The version of the image for the 'blue' deployment."
  default     = "1.0.0"
}

variable "blue_package_name" {
  type        = "string"
  description = "The package to use when making a blue deployment."
  default     = "g4-highcpu-128M"
}

#
# Details about the "green" deployment
#
variable "green_image_name" {
  type        = "string"
  description = "The name of the image for the 'green' deployment."
  default     = "happy_randomizer"
}

variable "green_image_type" {
  type    = "string"
  default = "lx-dataset"
}

variable "green_image_version" {
  type        = "string"
  description = "The version of the image for the 'green' deployment."
  default     = "1.1.0"
}

variable "green_package_name" {
  type        = "string"
  description = "The package to use when making a green deployment."
  default     = "g4-highcpu-128M"
}
