.PHONY: apply clean hosts plan ssh

clean:
	rm plan.tfplan

plan:
	terraform plan -out plan.tfplan

apply:
	terraform apply plan.tfplan

hosts:
	bin/inventory.sh

jumpbox:
	set -o errexit; \
	jumpbox_ip="$(shell terraform output --json | jq -r '.jumpbox_ip.value')"; \
	scp -r inventory "ubuntu@$$jumpbox_ip":. && \
	ssh -A -l ubuntu "$$jumpbox_ip"
