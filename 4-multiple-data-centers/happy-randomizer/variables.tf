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

#
# Details for our DNS provider
# Uncomment the defaults if not saved in environment variables
#
variable "cf_user" {
  type        = "string"
  description = "Email address associated with Cloudflare"
}

variable "cf_global_api_key" {
  type        = "string"
  description = "Key for using the Cloudflare API."
}

#
# Details about the deployments for each data center
#
module "east" {
  source      = "./modules/service"
  region_name = "us-east-1"

  blue_count  = 3
  green_count = 3

  service_production = "${var.service_production}"
  service_name       = "${var.service_name}"
  service_networks   = "${var.service_networks}"

  blue_image_name     = "${var.blue_image_name}"
  blue_image_type     = "${var.blue_image_type}"
  blue_image_version  = "${var.blue_image_version}"
  blue_package_name   = "${var.blue_package_name}"
  green_image_name    = "${var.green_image_name}"
  green_image_type    = "${var.green_image_type}"
  green_image_version = "${var.green_image_version}"
  green_package_name  = "${var.green_package_name}"
}

output "east_datacenter_green_ips" {
  value = ["${module.east.green_ips}"]
}

output "east_datacenter_blue_ips" {
  value = ["${module.east.blue_ips}"]
}

module "sw" {
  source      = "./modules/service"
  region_name = "us-sw-1"

  blue_count  = 0
  green_count = 3

  service_production = "${var.service_production}"
  service_name       = "${var.service_name}"
  service_networks   = "${var.service_networks}"

  blue_image_name     = "${var.blue_image_name}"
  blue_image_type     = "${var.blue_image_type}"
  blue_image_version  = "${var.blue_image_version}"
  blue_package_name   = "${var.blue_package_name}"
  green_image_name    = "${var.green_image_name}"
  green_image_type    = "${var.green_image_type}"
  green_image_version = "${var.green_image_version}"
  green_package_name  = "${var.green_package_name}"
}

output "sw_datacenter_green_ips" {
  value = ["${module.sw.green_ips}"]
}

output "sw_datacenter_blue_ips" {
  value = ["${module.sw.blue_ips}"]
}

module "west" {
  source      = "./modules/service"
  region_name = "us-west-1"

  blue_count  = 3
  green_count = 0

  service_production = "${var.service_production}"
  service_name       = "${var.service_name}"
  service_networks   = "${var.service_networks}"

  blue_image_name     = "${var.blue_image_name}"
  blue_image_type     = "${var.blue_image_type}"
  blue_image_version  = "${var.blue_image_version}"
  blue_package_name   = "${var.blue_package_name}"
  green_image_name    = "${var.green_image_name}"
  green_image_type    = "${var.green_image_type}"
  green_image_version = "${var.green_image_version}"
  green_package_name  = "${var.green_package_name}"
}

output "west_datacenter_green_ips" {
  value = ["${module.west.green_ips}"]
}

output "west_datacenter_blue_ips" {
  value = ["${module.west.blue_ips}"]
}

#
# Details for Cloudflare
#
module "dns" {
  source = "./modules/dns"

  zone_name         = "alexandra.space"
  host_name         = "@"
  staging_host_name = "staging"
  ttl               = "300"

  service_instance_count = "${module.east.blue_count + module.sw.blue_count + module.west.blue_count}"
  service_instance_list  = "${concat(module.east.blue_ips, module.sw.blue_ips, module.west.blue_ips)}"

  staging_service_instance_count = "${module.east.green_count + module.sw.green_count + module.west.green_count}"
  staging_service_instance_list  = "${concat(module.east.green_ips, module.sw.green_ips, module.west.green_ips)}"
}
