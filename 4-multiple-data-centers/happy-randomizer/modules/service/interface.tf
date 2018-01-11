terraform {
  required_version = ">= 0.10.0"
}

variable "service_production" {
  description = "Which deployment is considered 'production'? The other is 'staging'. Value can be one of 'blue' or 'green'."
}

variable "service_name" {
  description = "The name of the service in CNS."
}

variable "service_networks" {
  type        = "list"
  description = "The name or ID of one or more networks the service will operate on."
}

variable "blue_image_name" {
  description = "The name of the image for the 'blue' deployment."
}

variable "blue_image_type" {
  description = "The type of the image for the 'blue' deployment."
}

variable "blue_image_version" {
  description = "The version of the image for the 'blue' deployment."
}

variable "blue_package_name" {
  description = "The package to use when making a blue deployment."
}

variable "green_image_name" {
  description = "The name of the image for the 'green' deployment."
}

variable "green_image_type" {
  description = "The type of the image for the 'green' deployment."
}

variable "green_image_version" {
  description = "The version of the image for the 'green' deployment."
}

variable "green_package_name" {
  description = "The package to use when making a green deployment."
}

provider "triton" {
  url = "https://${var.region_name}.api.joyent.com"
}

variable "blue_count" {
  description = "number of blue machines"
}

variable "green_count" {
  description = "number of green machines"
}

variable "region_name" {
  description = "number of green machines"
}

#
# Common details about both "blue" and "green" deployments
#
data "triton_network" "service_networks" {
  count = "${length(var.service_networks)}"
  name  = "${element(var.service_networks, count.index)}"
}

#
# Details about the "blue" deployment
#
data "triton_image" "blue_image" {
  name        = "${var.blue_image_name}"
  version     = "${var.blue_image_version}"
  type        = "${var.blue_image_type}"
  most_recent = true
}

resource "triton_machine" "blue_machine" {
  count    = "${var.blue_count}"
  name     = "blue_happy_${count.index + 1}"
  package  = "${var.blue_package_name}"
  image    = "${data.triton_image.blue_image.id}"
  networks = ["${data.triton_network.service_networks.*.id}"]

  cns {
    services = ["${var.service_production == "blue" ? var.service_name : "staging-${var.service_name}" }", "blue-${var.service_name}"]
  }
}

#
# Details about the "green" deployment
#
data "triton_image" "green_image" {
  name        = "${var.green_image_name}"
  version     = "${var.green_image_version}"
  type        = "${var.green_image_type}"
  most_recent = true
}

resource "triton_machine" "green_machine" {
  count    = "${var.green_count}"
  name     = "green_happy_${count.index + 1}"
  package  = "${var.green_package_name}"
  image    = "${data.triton_image.green_image.id}"
  networks = ["${data.triton_network.service_networks.*.id}"]

  cns {
    services = ["${var.service_production == "green" ? var.service_name : "staging-${var.service_name}" }", "green-${var.service_name}"]
  }
}

output "blue_ips" {
  value = ["${triton_machine.blue_machine.*.primaryip}"]
}

output "green_ips" {
  value = ["${triton_machine.green_machine.*.primaryip}"]
}

output "blue_count" {
  value = "${var.blue_count}"
}

output "green_count" {
  value = "${var.green_count}"
}
