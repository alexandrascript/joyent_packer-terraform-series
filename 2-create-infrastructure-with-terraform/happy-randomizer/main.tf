terraform {
  required_version = ">= 0.10.0"
}

provider "triton" {
  # The provider takes the following environment variables:
  # TRITON_URL, TRITON_ACCOUNT, and TRITON_KEY_ID
}

#
# Details about the deployment
#
data "triton_image" "happy_image" {
  name        = "${var.image_name}"
  version     = "${var.image_version}"
  type        = "${var.image_type}"
  most_recent = true
}

data "triton_network" "service_networks" {
  count = "${length(var.service_networks)}"
  name  = "${element(var.service_networks, count.index)}"
}

resource "triton_machine" "happy_machine" {
  name     = "happy_randomizer"
  package  = "${var.package_name}"
  image    = "${data.triton_image.happy_image.id}"
  networks = ["${data.triton_network.service_networks.*.id}"]

  cns {
    services = ["${var.service_name}"]
  }
}

output "primaryIp" {
  value = ["${triton_machine.happy_machine.*.primaryip}"]
}

output "dns_names" {
  value = ["${triton_machine.happy_machine.*.domain_names}"]
}
