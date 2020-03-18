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
* /etc/dci-openstack-agent/settings.yml (tag: config_settings)
* /etc/dci-openstack-agent/hooks/pre-run.yml (tag: config_hooks)
* /etc/dci-openstack-agent/hooks/running.yml (tag: config_hooks)
* /home/dci/.ssh/id_rsa* copyied to /var/lib/dci-openstack-agent/.ssh/ (tag: config_ssh)
* /etc/sysconfig/network-scripts/ifcfg-eth1 configured  (tag: config_network)



