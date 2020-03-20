# dci_osp_automation

Some generic osp automation scripting to work with Rehat DCI.


## dci.yaml

Do some basic dci-opnestack-agent configuration to prep the environment for dci jobs.

Requirements:
* The dci and director vm have already been set up at this point. 
* The dci user already has access to the stack user on the director vm vi ssh keys.
* eth1 on the dci server is connected to br-trunk on the hypervisor.
* Native vlan on br-trunk is the ironic provisioning network all other vlans are trunked.

Input vars:
* dci_topic: "OSP16"
* undercloud_ip: "192.168.122.210"
* dci_ironic_provisioning_ip: "192.168.201.4"
* dci_ironic_provisioning_prefix: "24"

Outputs:

Tag | Outputs
--- | -------
config_settings | Generates /etc/dci-openstack-agent/settings.yml
config_hooks | Generates /etc/dci-openstack-agent/hooks/pre-run.yml
config_hooks | Generates /etc/dci-openstack-agent/hooks/running.yml
config_ssh | /home/dci/.ssh/id_rsa* copyied to /var/lib/dci-openstack-agent/.ssh/
config_network | Generates /etc/sysconfig/network-scripts/ifcfg-eth1


Example:

```
ansible-playbook -i inventory/lab.yml dci.yaml  -b -e @vars/OSP16-example.yml -e @vars/manual-example.yml
```

