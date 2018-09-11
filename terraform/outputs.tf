output "jumpbox_ip" {
  value = "${aws_instance.jumpbox.public_ip}"
}

output "jumpbox_dns_name" {
  value = "${aws_instance.jumpbox.public_dns}"
}

output "db_catalog_master" {
  value = "${module.db_catalog.master}"
}

output "db_catalog_replicas" {
  value = ["${module.db_catalog.replicas}"]
}

output "db_pycsw_master" {
  value = "${module.db_pycsw.master}"
}

output "db_pycsw_replicas" {
  value = ["${module.db_pycsw.replicas}"]
}

output "harvester_ips" {
  value = ["${module.catalog_harvester.instance_ips}"]
}

output "inventory_dns_name" {
  value = "${module.inventory.elb_dns_name}"
}

output "inventory_hosts" {
  value = ["${module.inventory.instance_hosts}"]
}
