variable "zone_name" {
  type        = "string"
  description = "The domain to add the DNS record to."
}

variable "host_name" {
  type        = "string"
  description = "The name of the DNS host. For production, this is represented by '@'."
}

variable "staging_host_name" {
  type        = "string"
  description = "The name of the DNS host. For staging, this is the subdomain 'staging'."
}

variable "ttl" {
  type        = "string"
  description = "TTL for the DNS record."
}

variable "service_instance_list" {
  type = "list"
}

variable "service_instance_count" {
  type = "string"
}

variable "staging_service_instance_list" {
  type = "list"
}

variable "staging_service_instance_count" {
  type = "string"
}

provider "cloudflare" { }

resource "cloudflare_record" "production" {
  count  = "${var.service_instance_count}"
  domain = "${var.zone_name}"
  name   = "${var.host_name}"
  value  = "${element(var.service_instance_list, count.index)}"
  type   = "A"
  ttl    = "${var.ttl}"
}

resource "cloudflare_record" "staging" {
  count  = "${var.staging_service_instance_count}"
  domain = "${var.zone_name}"
  name   = "${var.staging_host_name}"
  value  = "${element(var.staging_service_instance_list, count.index)}"
  type   = "A"
  ttl    = "${var.ttl}"
}
