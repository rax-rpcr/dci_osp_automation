# undercloud role

Configure and install the undercloud on the director vm

## Requirements

* dci vm is prepped and dci.yml has ran to configure the dci-openstack-agent.

## Input vars

Variable | Description
-------- | -----------
dci_topic | Used to pull vars/ospXX.yml for osp version specific vars.
rhsm_user, rhsm_pass & rhsm_pool | Redhat subscription variables.
undercloud_repositories | Repos needed by the undercloud pulled from vars/ospXX.yml
network_service_rpms | Rpms needed for network configuration pullef rom vars/ospXX.yml.
internal_network_cidr | cidr of the overcloud internal network
internal_vlan | vlan of the overcloud internal network
gw_net_network_cidr | cidr of the overcloud neutron gateway network
gw_net_vlan | vlan of the overcloud neutron gateway network
ipmi_network_cidr | cidr of the overcloud ipmi network
ipmi_vlan | vlan of the overcloud ipmi network
undercloud_ipmi_ip | ipmi ip address to use for ipmi access
stor_mgmt_network_cidr | cidr of the storage management network
stor_mgmt_vlan | vlan of the overcloud storage network
ironic_provisioning_network | Ironic provisioning network in cidr format.
domain_name | used in undercloud.conf and /etc/hosts.
tripleoclient_pkg_name | tripoclient package name pulled from vars/ospXX.yml.
ceph_tools_repo | Repo to add to the undercloud for ceph tools install from vars/ospXX.yml
ceph_ansible_pkg_name | Ceph rpm packages to install on the undercloud vm from vars/opsXX.yml
rhregistry_user & rhregistry_pass | Service account creds for redhat docker registry.
ssl_working_dir | Dir used when creating certs. Default: /home/stack/sslfiles
ssl_C, ssl_ST, ssl_L, ssl_O, ssl_CN_prefix and ansible_fqdn | SSL Cert info. Defaults: US, Texas, San Antonio, RPC-R, ca & undercloud fqdn.
haproxy_ssl_dir | Dir to store haproxy ssl cert. Default: /etc/pki/instack-certs
haproxy_ssl_cert | Haproxy cert location. Default /etc/pki/instack-certs/undercloud.pem
undercloud_hiera_overrides_file | File for undercloud hiera data overrides. Default: heira-overrides.yaml(in /home/stack)
enable_pci | Enables /home/stack/heira-overrides.yaml for tls settings. Default: true
undercloud_local_interface | defaults to eth1 for undercloud.conf
undercloud_local_mtu | defaults to 1500 for undercloud.conf
undercloud_nameservers | Defaults to IAD nameservers for undercloud box
undercloud_ntp_servers | Defautls to IAD ntp servers. Same as nameservers for RS.
enable_self_signed_certs | Enables config of local ca and cert config for undercloud. Default: true
enable_ceph | Enable install of ceph repo and ceph-ansible. Default: true
enable_undercloud_debug | Default: false
prep_group_validations | Default: 512e, service-status, undercloud-{cpu,disk-space,ram,selinux-mode} 
overcloud_image_pkg_names | Package names containing glance images. Pulled from vars/ospXX.yml.


## Outputs:

Tag | Outputs
--- | -------
undercloud_registration | Sync time with chronyd
undercloud_registration | Register the system with defined pool.
undercloud_registration | Enable repos needed for the undercloud. 
config_network | Install packages needed to roll back network manager
config_network | Disable Networkmanger & enable network service
config_network | Enable ip forwarding.
config_network | Generate and enable /etc/sysconfig/network-scripts/ifcfg-eth1 (no ip)
config_network | Generate and enable /etc/sysconfig/network-scripts/ifcfg-eth1.(internal net vlan w/generated ip)
config_network | Generate and enable /etc/sysconfig/network-scripts/ifcfg-eth1.(gw net vlan w/generated ip)
config_network | Generate and enable /etc/sysconfig/network-scripts/ifcfg-eth1.(ipmi net vlan w/predefined ip)
config_network | Generate and enable /etc/sysconfig/network-scripts/ifcfg-eth1.(stor mgmt vlan w/generated ip)
undercloud_prep | Create /home/stack/{images,templates}
undercloud_prep | Edit /etc/hosts with director host info(external_prov_ip hostname short_hostname)
undercloud_prep | Update packages, reboot and wait.
undercloud_prep | Install python3-tripleoclient
install_ceph_ansible | if enable_ceph set up ceph repo and install ceph ansible
prepare_container_images | (osp16+)Create /home/stack/templates/container_overrides.yaml with image repo login creds.
prepare_container_images | (osp16+)Generate /home/stack/containers-prepare-parameter.yaml with an openstack command.
setup_ssl_certs | Generates ssl ca & signed service certs under /home/stack/sslfiles/
setup_ssl_certs | Generates /etc/pki/instack-certs/undercloud.pem with service cert-n-key with selinux rules.
setup_ssl_certs | Copy ca cert to /etc/pki/ca-trust/source/anchors/ and runs update-ca-trust
pci_config | Generates /home/stack/heira-overrides.yaml for tls settings
config_undercloud | Generates /home/stack/undercloud.conf
prep_group_validations | (osp16+)Create /usr/share/openstack-tripleo-validations/undercloud.ini for local inventory.
prep_group_validations | (osp16+)Create /usr/share/openstack-tripleo-validations/ansible.cfg for pre-install validation run.
prep_group_validations | (osp16+)Run ansible playbooks based on validation names provided in prep_group_validations.
install_undercloud | Runs "openstack undercloud install" for the undercloud install.
overcloud_glance_images | Downloads, unzip, uncompresses and uploads overcloud glance images.
add_exnet_masquerade | Generates /home/stack/scripts/add_ex-net_masquerade.sh 
add_exnet_masquerade | Runs script to add iptables masquerade for anything going out eth0 from gw_net_network_cidr for external VM connectivity.

