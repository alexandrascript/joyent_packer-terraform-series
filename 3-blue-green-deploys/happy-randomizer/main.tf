#
# You must have installed Terraform v 0.10.0 or above.
#
terraform {
  required_version = ">= 0.10.0"
}

#
# The provider uses TRITON_URL, TRITON_ACCOUNT, and TRITON_KEY_ID
# environment vars as defaults.
#
provider "triton" {}

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
  type        = "lx-dataset"
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
# Outputs from the "blue" deployment
#
output "blue_ips" {
  value = ["${triton_machine.blue_machine.*.primaryip}"]
}

output "blue_domains" {
  value = ["${triton_machine.blue_machine.*.domain_names}"]
}

#
# Details about the "green" deployment
#
data "triton_image" "green_image" {
  name        = "${var.green_image_name}"
  version     = "${var.green_image_version}"
  type        = "lx-dataset"
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

#
# Outputs from the "green" deployment
#
output "green_ips" {
  value = ["${triton_machine.green_machine.*.primaryip}"]
}

output "green_domains" {
  value = ["${triton_machine.green_machine.*.domain_names}"]
}