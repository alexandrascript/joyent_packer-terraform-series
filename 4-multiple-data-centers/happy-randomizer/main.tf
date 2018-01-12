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
  
  email             = "{var.email}"
  token             = "{var.token}"

  service_instance_count = "${module.east.blue_count + module.sw.blue_count + module.west.blue_count}"
  service_instance_list  = "${concat(module.east.blue_ips, module.sw.blue_ips, module.west.blue_ips)}"

  staging_service_instance_count = "${module.east.green_count + module.sw.green_count + module.west.green_count}"
  staging_service_instance_list  = "${concat(module.east.green_ips, module.sw.green_ips, module.west.green_ips)}"
}