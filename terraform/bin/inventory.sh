#!/bin/bash
# Generates ansible inventory from terraform output

set -o errexit
set -o pipefail
set -o nounset

project_dir="$(pwd)/$(dirname $0)/../.."
terraform_output=$(mktemp)
inventory_dir="${project_dir}/terraform/inventory"

function cleanup () {
  rm "$terraform_output"
}

function group_hosts () {
  local output=${1}
  jq -r ".${output}?.value[]?" "$terraform_output"
}

function inventory_file () {
  local file="$1"
  mkdir -p "$(dirname "$file")"
  cat > "$file"
}

trap cleanup EXIT

cd "$project_dir/terraform"
terraform output --json > "$terraform_output"

jumpbox_ip="$(grep jumpbox_ip "$terraform_output" | cut -d = -f 2)"
catalog_harvester_hosts=$(group_hosts harvester_ips)
inventory_hosts=$(group_hosts inventory_hosts)


# Create the hosts file
inventory_file "$inventory_dir/hosts" <<EOF
# This inventory is generated from terraform/bin/inventory.sh

[catalog-web]

[catalog-harvester]
${catalog_harvester_hosts}

[solr]

[inventory-web]
${inventory_hosts}

[crm-web]

[dashboard-web]

[wordpress-web]

[jekyll-web]

[elasticsearch]

[kibana]

[efk_nginx]
EOF

# catalog vars
inventory_file "$inventory_dir/group_vars/catalog-harvester/vars.yml" <<EOF
# These variables are generated from terraform/bin/inventory.sh
redis_password: redispassword
EOF
