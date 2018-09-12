module "inventory" {
  source = "./modules/ckan"
  count_instances = 1
  prefix = "${var.prefix}-inventory"
  subnet_id = "${module.vpc.private_subnets[0]}"
  public_subnets = ["${module.vpc.public_subnets}"]
  security_groups = ["${aws_security_group.jumpbox_access.id}", "${module.db_inventory.security_group_id}", "${module.db_inventory_datastore.security_group_id}"]
  admin_key_name = "${aws_key_pair.admin.key_name}"
  owner = "${var.owner}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "db_inventory" {
  source = "./modules/db"
  cluster_name = "${var.prefix}-inventory"
  vpc_id = "${module.vpc.vpc_id}"
  db_name = "ckan_inventory"
  db_user = "ckan"
  db_password = "ckanpassword"
  subnet_ids = ["${module.vpc.private_subnets}"]
}

module "db_inventory_datastore" {
  source = "./modules/db"
  cluster_name = "${var.prefix}-inventory-datastore"
  vpc_id = "${module.vpc.vpc_id}"
  db_name = "ckan_inventory"
  db_user = "ckan"
  db_password = "ckanpassword"
  subnet_ids = ["${module.vpc.private_subnets}"]
}
