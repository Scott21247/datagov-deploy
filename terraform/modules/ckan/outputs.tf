output "instance_ips" {
  value = ["${aws_instance.ckan.*.private_ip}"]
}

output "instance_hosts" {
  value = ["${aws_instance.ckan.*.private_dns}"]
}

output "elb_dns_name" {
  value = "${module.ckan_lb.this_elb_dns_name}"
}
