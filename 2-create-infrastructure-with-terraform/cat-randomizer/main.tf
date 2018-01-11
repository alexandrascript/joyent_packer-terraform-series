terraform {
  required_version = ">= 0.10.0"
}

provider "triton" {
    # Commenting these out because they will take the SDC_URL, SDC_ACCOUNT, and SDC_KEY_ID env vars as defaults
    # url = "https://${var.dc_name}.api.joyent.com"
    # account = "${var.triton_account}"
    # key_id = "${var.triton_key_id}"
}

#
# Details about all deployments of this application
#
data "triton_network" "service_networks" {
  count = "${length(var.service_networks)}"
  name = "${element(var.service_networks, count.index)}"
}

#
# Details about the deployment
#
data "triton_image" "cats_image" {
    name = "${var.image_name}"
    version = "${var.image_version}"
    type = "lx-dataset"
    most_recent = true
}

resource "triton_machine" "cats_machine" {
    name = "cats_randomizer"
    package = "${var.package_name}"
    image = "${data.triton_image.image.id}"
    networks = ["${data.triton_network.service_networks.*.id}"]
    cns {
        services = ["${var.service_name}"]
    }
}