module "catalog_harvester" {
  source = "./modules/ckan"
  count_instances = 1
  prefix = "${var.prefix}-catalog-harvester"
  subnet_id = "${module.vpc.private_subnets[0]}"
  public_subnets = ["${module.vpc.public_subnets}"]
  security_groups = ["${module.db_catalog.security_group_id}"]
  admin_key_name = "${aws_key_pair.admin.key_name}"
  owner = "${var.owner}"
  vpc_id = "${module.vpc.vpc_id}"
}
