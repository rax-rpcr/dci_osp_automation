# dci_osp_automation

Some generic osp automation scripting to work with Rehat DCI.


## dci.yaml playbook

Do some basic dci-opnestack-agent configuration to prep the environment for dci jobs.

### Requirements:
* The dci and director vm have already been set up at this point. 
* The dci user already has access to the stack user on the director vm vi ssh keys.
* eth1 on the dci server is connected to br-trunk on the hypervisor.
* Native vlan on br-trunk is the ironic provisioning network all other vlans are trunked.

### Input vars:

Variable | Description
-------- | -----------
dci_topic | "OSP16" is the only thing currently tested
undercloud_ip | Ip of the undercloud node. ex: "192.168.122.210"
dci_ironic_provisioning_ip | DCI prov net ip. 1,2,3 are taken by the undercloud. ex: "192.168.201.4"
dci_ironic_provisioning_prefix |  Network prefix to be used for the prov ip above. ex: "24"

### Outputs:

Tag | Outputs
--- | -------
config_settings | Generates /etc/dci-openstack-agent/settings.yml
config_hooks | Generates /etc/dci-openstack-agent/hooks/pre-run.yml
config_hooks | Generates /etc/dci-openstack-agent/hooks/running.yml
config_ssh | /home/dci/.ssh/id_rsa* copyied to /var/lib/dci-openstack-agent/.ssh/
config_network | Generates /etc/sysconfig/network-scripts/ifcfg-eth1


## dci.yml playbook example:

```
ansible-playbook -i inventory/lab.yml dci.yaml  -b -e @vars/OSP16-example.yml -e @vars/manual-example.yml
```



## undercloud.yml playbook

Configure and install the undercloud on the director vm

## Input vars

Variable | Description
-------- | -----------
internal_network_cidr | cidr of the overcloud internal network
internal_vlan | vlan of the overcloud internal network
gw_net_network_cidr | cidr of the overcloud neutron gateway network
gw_net_vlan | vlan of the overcloud neutron gateway network
ipmi_network_cidr | cidr of the overcloud ipmi network
ipmi_vlan | vlan of the overcloud ipmi network
ironic_provisioning_network | Ironic provisioning network in cidr format.
rhsm_user & rhsm_pass | Redhat creds to auth against image repo.
enable_pci | Enables /home/stack/heira-overrides.yaml for tls settings. Default: true
undercloud_local_interface | defaults to eth1 for undercloud.conf
undercloud_local_mtu | defaults to 1500 for undercloud.conf
domain_name | used in undercloud.conf same as system domain.
undercloud_nameservers | IAD nameservers for undercloud box
undercloud_ntp_servers | IAD ntp servers. Same as nameservers for RS.
enable_self_signed_certs | Enables config of local ca and cert config for undercloud. Default: true
enable_ceph | Enable install of ceph repo and ceph-ansible. Default: true


### Outputs:

Tag | Outputs
--- | -------
config_network | Disable Networkmanger & enable network service
config_network | Generate and enable /etc/sysconfig/network-scripts/ifcfg-eth1 (no ip)
config_network | Generate and enable /etc/sysconfig/network-scripts/ifcfg-eth1.<internal net vlan>
config_network | Generate and enable /etc/sysconfig/network-scripts/ifcfg-eth1.<gw net vlan>
config_network | Generate and enable /etc/sysconfig/network-scripts/ifcfg-eth1.<ipmi net vlan>
undercloud_prep | Create /home/stack/{images,templates}
undercloud_prep | Edit /etc/hosts with director host info(<external prov ip ending> hostname short_hostname)
undercloud_prep | Update packages, reboot and wait.
undercloud_prep | Install python3-tripleoclient
install_ceph_ansible | if enable_ceph set up ceph repo and install ceph ansible
prepare_container_images | Create /home/stack/templates/container_overrides.yaml with image repo login creds.
prepare_container_images | Generate /home/stack/containers-prepare-parameter.yaml with an openstack command.
setup_ssl_certs | Generates ssl ca & signed service certs under /home/stack/sslfiles/
setup_ssl_certs | Generates /etc/pki/instack-certs/undercloud.pem with service cert-n-key with selinux rules.
setup_ssl_certs | Copy ca cert to /etc/pki/ca-trust/source/anchors/ and runs update-ca-trust
pci_config | Generates /home/stack/heira-overrides.yaml for tls settings 
config_undercloud | Generates /home/stack/undercloud.conf
install_undercloud | Runs "openstack undercloud install" for the undercloud install.

### Example(ran from /etc/dci-openstack/agent/hooks/running.yml)
```
cd /var/lib/dci-openstack-agent/repos/dci_osp_automation/
ansible-playbook undercloud.yaml \
    -i inventory/lab.yml  \
    -e @/etc/dci-openstack-agent/settings.yml \
    -e @/etc/dci-openstack-agent/theforeman-dci-vars.yml \
    -e @/etc/dci-openstack-agent/non-theforeman-dci-vars.yml
```

