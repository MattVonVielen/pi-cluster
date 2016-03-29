export ANSIBLE_HOST_KEY_CHECKING=False

provision_leader:
	ansible-playbook -i inventory -e leader_ip=$(LEADER_IP) leader.yml

provision_workers:
	ansible-playbook -i inventory -e leader_ip=$(LEADER_IP) workers.yml
