#!/bin/bash
# Generates ansible inventory from terraform output
# Requires `jq` to be installed.

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

# Set static variables
export redis_password=redispassword

# Variables from terraform output
export jumpbox_ip="$(grep jumpbox_ip "$terraform_output" | cut -d = -f 2)"
export catalog_harvester_hosts=$(group_hosts harvester_ips)
export inventory_web_hosts=$(group_hosts inventory_hosts)
export db_inventory_master=$(group_hosts db_inventory_master)
export db_inventory_datastore_master=$(group_hosts db_inventory_datastore_master)

# Template out the inventory
inventory_template_dir="$project_dir/terraform/_inventory"
for template in $(find "$inventory_template_dir" -name '*.tpl' -type f -printf '%P\n'); do
  dir=$(dirname "$template")
  base=$(basename "$template" .tpl)
  mkdir -p "$inventory_dir/$dir"
  envsubst '
    $catalog_harvester_hosts
    $catalog_web_hosts
    $db_inventory_master
    $db_inventory_datastore_master
    $inventory_web_hosts
    $redis_password
    $solr_hosts
    ' < "$inventory_template_dir/$template" > "$inventory_dir/$dir/$base"
done
