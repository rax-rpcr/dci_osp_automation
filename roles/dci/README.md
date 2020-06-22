# dci.yaml playbook

Do some basic dci-openstack-agent configuration to prep the environment for dci jobs.

## Requirements:

* The dci and director vm have already been set up at this point.
* The dci user already has access to the stack user on the director vm vi ssh keys.
* eth1 on the dci server is connected to br-trunk on the hypervisor.
* Native vlan on br-trunk is the ironic provisioning network all other vlans are trunked.


## Input vars:

Variable | Description
-------- | -----------
dci_topic | "OSP16" is the only thing currently tested
undercloud_ip | Ip of the undercloud node. ex: "192.168.122.210"
dci_ironic_provisioning_ip | DCI prov net ip. 1,2,3 are taken by the undercloud. ex: "192.168.201.4"
dci_ironic_provisioning_prefix |  Network prefix to be used for the prov ip above. ex: "24"
gw_net_vlan | Neutron gateway(ext-net) network vlan
gw_net_dhcp_from | Neutron gateway subnet(ext-subnet) dhcp start
gw_net_dhcp_to | Neutron gateway subnet(ext-subnet) dhcp end
gw_net_gateway | Neutron gateway subnet(ext-subnet) gateway ip
gw_net_network_cidr | Neutron gateway subnet(ext-subnet) cidr


## Outputs:

Tag | Outputs
--- | -------
config_settings | Generates /etc/dci-openstack-agent/settings.yml
config_hooks | Generates /etc/dci-openstack-agent/hooks/pre-run.yml
config_hooks | Generates /etc/dci-openstack-agent/hooks/running.yml
config_hooks | Generates /etc/dci-openstack-agent/hooks/success.yml
config_ssh | /home/dci/.ssh/id_rsa* copyied to /var/lib/dci-openstack-agent/.ssh/
config_network | Generates /etc/sysconfig/network-scripts/ifcfg-eth1


