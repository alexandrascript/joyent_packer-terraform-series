terraform {
  required_version = ">= 0.10.0"
}

provider "triton" {
    # Commenting these out because they will take the TRITON_URL, TRITON_ACCOUNT, and TRITON_KEY_ID env vars as defaults
    # url = "${var.triton_url}"
    # account = "${var.triton_account}"
    # key_id = "${var.triton_key_id}"
}

#
# Details about the deployment
#
data "triton_image" "happy_image" {
    name = "${var.image_name}"
    version = "${var.image_version}"
    type = "lx-dataset"
    most_recent = true
}

data "triton_network" "service_networks" {
  count = "${length(var.service_networks)}"
  name = "${element(var.service_networks, count.index)}"
}

resource "triton_machine" "happy_machine" {
    name = "happy_randomizer"
    package = "${var.package_name}"
    image = "${data.triton_image.happy_image.id}"
    networks = ["${data.triton_network.service_networks.*.id}"]
    cns {
        services = ["${var.service_name}"]
    }
}