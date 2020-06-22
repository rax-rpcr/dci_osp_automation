# overcloud role

Configure and install the overcloud from the director vm

## Requirements

* dci vm is prepped and dci.yml has ran to configure the dci-openstack-agent.
* undercloud role tasks have completed without issue

## Input vars

Variable | Description
-------- | -----------
dci_topic | Used to pull vars/ospXX.yml for osp version specific vars.
required_overcloud_repos | List of repos from vars/ospXX.yml required for the overcloud install.
ironic_nodes | Contains array of data needed for ironic node registration
ironic_nodes['mac'] | mac address of nic used for pxe boot for instackenv.json.
ironic_nodes['name'] | Ironic node name(fqdn) for instackenv.json.
ironic_nodes['cpu'] | 'cpu' in instackenv.json.
ironic_nodes['memory'] | 'memory' in instackenv.json.
ironic_nodes['disk'] | 'disk' in instackenv.json.
ironic_nodes['arch'] | 'arch' in instackenv.json.
ironic_nodes['pm_type'] | 'pm_type' in instackenv.json.  Defaults to "pxe_ipmitool". 
ironic_nodes['pm_user'] | iLO/Drac username.  'pm_user' in instackenv.json. Also used for fencing config.
ironic_nodes['pm_password'] | iLO/Drac password. 'pm_password' in instackenv.json. Also used for fencing config.
ironic_nodes['pm_addr'] | iLO/Drac ip addr. 'pm_addr' in instackenv.json Also used for fencing foncifg.
ironic_nodes['profile'] | Used in ironic node 'profile' and 'node' capability settings. 'control', 'compute' and 'ceph-storage'
ironic_nodes['node_index'] | Used in ironic node 'node' capability. Increments on each node by profile. Starts at 0. Also used for fencing config.
ironic_nodes['role'] | Used in 'node' and 'ips-from-pool-all' templates. Values: 'Controller', 'Compute' and 'CephStorage'.
pre_introspection_group_validations | List of pre introspection validations to run. See list in defaults/main.yml
python_command | Needed for python(osp13) and python3(osp16) on certain commands.
domain_name | used in undercloud.conf and /etc/hosts.
overcloud_endpoint_fqdn | Defaults to openstack.(domain_name)
ssl_working_dir | Dir used when creating certs. Default: /home/stack/sslfiles
ssl_C, ssl_ST, ssl_L, ssl_O | SSL Cert info. Defaults: US, Texas, San Antonio, RPC-R 
enable_self_signed_certs | Enables config of local ca and cert config for undercloud. Default: true
rhsm_user, rhsm_pass & rhsm_pool | Redhat subscription variables.
lab_network_environment | Used for environment specific template entries such as custom-nics.
ironic_provisioning_network | Ironic provisioning network in cidr format.
external_controller_ips | Ips pulled from core(or ironic-on-ironic) host(external) network. 
external_network_cidr | CIDR of external network.
external_network_gateway | Gateway ip of external network.
external_floating_ip | Floating/cluster ip of external network.(used for public openstack endpoints)
internal_network_cidr | CIDR of internal(management) network
internal_vlan | VLAN of internal network.
internal_dhcp_from | Internal network dhcp start.
internal_dhcp_to | Internal network dhcp end.
internal_floating_ip | Floating/cluster ip of internal network.(used for internal/admin openstack endpoints)
storage_network_cidr | CIDR of storage network.
storage_vlan | VLAN of storage network.
storage_dhcp_from | Storage network dhcp start.
storage_dhcp_to | Storage network dhcp end.
stor_mgmt_network_cidr | CIDR of storage management network.
stor_mgmt_vlan | VLAN of storage management network.
stor_mgmt_dhcp_from | Storage management network dhcp start.
stor_mgmt_dhcp_to | Storage management network dhcp end.
manilla_network_cidr | CIDR of manilla network.
manilla_vlan | VLAN of manilla network.
manilla_dhcp_from | Manilla network dhcp start.
manilla_dhcp_to | Manilla network dhcp end.
tenant_network_cidr | CIDR of tenant(vxlan/gre) network.
tenant_vlan | VLAN of tenant network.
tenant_dhcp_from | Tenant network dhcp start.
tenant_dhcp_to | Tenant network dhcp end.
overcloud_nameservers | DNS server list for the overcloud nodes.
enable_pci | Enables /home/stack/heira-overrides.yaml for tls settings. Default: true
enable_ceph | Enable install of ceph repo and ceph-ansible. Default: true
overcloud_ntpservers | NTP servers to use for the overcloud nodes.
gw_net_network_cidr | cidr of the overcloud neutron gateway network(ext-net)
gw_net_vlan | vlan of the overcloud neutron gateway network(ext-net)
gw_net_dhcp_from | Neutron gateway(ext-net) network dhcp start.
gw_net_dhcp_to | Neturon gateway(ext-net) network dhcp end.
inside_net_network_cidr | cidr of the overcloud neutron inside network(int-net)
inside_net_vlan | vlan of the overcloud neutron inside network(int-net)
inside_net_dhcp_from | Neutron inside(int-net) network dhcp start.
inside_net_dhcp_to | Neturon inside(int-net) network dhcp end.




## Outputs:

Tag | Outputs
--- | -------
enable_overcloud_repos | Enable repos defined in the required_overcloud_repos var
register_ironic_nodes | Generate /home/stack/instackenv.json using ironic_nodes array.
register_ironic_nodes | Run baremetal commands to see if overcloud needs registered.
register_ironic_nodes | Run validate on /home/stack/instackenv.json
register_ironic_nodes | Run the ironic node import command against instackenv.json.
pre_introspection_group_validations | (osp16+) Run pre introspection validations.
run_introspection | Run introspection on all nodes in 'manageable' state and set up 'provide' after.
run_introspection | Generate /home/stack/introspection_data_dump/{{ curnode.name }}.json by dumping introspection data for each node.
run_introspection | Set 'profile' and 'node' capabilites on the ironic nodes for routing and predectible naming. 
run_introspection | Profile taken from ironic_nodes['profile'] and  'node' set to 'ironic_nodes['profile']-ironic_nodes['node_index']'
setup_ssl_certs | Generates the overcloud key and csr files.
setup_ssl_certs | Signs csr with CA generated during overcloud install. 
setup_ssl_certs | End result is the creation of /home/stack/sslfiles/{{ overcloud_endpoint_fqdn }}.{key,csr,crt} files.
overcloud_registration | (osp16+) Generate /home/stack/templates/rhsm.yaml
overcloud_registration | (osp13) Copy /usr/share/openstack-tripleo-heat-templates/extraconfig/pre_deploy/rhel-registration to /home/stack/templates/
overcloud_registration | (osp13) Edit /home/stack/templates/rhel-registration/environment-rhel-registration.yaml with proper values.
overcloud_registration | Generate helper playbook to register post install. /home/stack/playbooks/register_overcloud.yml
overcloud_registration | Generate helper playbook to unregister post install. /home/stack/playbooks/unregister_overcloud.yml
overcloud_env_templates | Register the ca certificate contents for later use.
overcloud_env_templates | Register the overcloud cert and key from /home/stack/sslfiles/ for later use.
overcloud_env_templates | (osp16+) Generate /home/stack/templates/node-info.yaml
overcloud_env_templates | (osp16+) Generate /home/stack/templates/inject-trust-anchor-hiera.yaml
overcloud_env_templates | (osp16+) Generate /home/stack/templates/network-environmnet.yaml
overcloud_env_templates | (osp13) Generate /home/stack/templates/00-node-info.yaml
overcloud_env_templates | (osp13) Generate /home/stack/templates/31-inject-trust-anchor-hiera.yaml
overcloud_env_templates | (osp13) Generate /home/stack/templates/20-network-environmnet.yaml
overcloud_env_templates | (osp13) Generate /home/stack/templates/40-ips-from-pool-all.yaml
overcloud_env_templates | Create custom-nics dir. custom-nics templates use 'lab_network_environment' var to find env related nic templates.
overcloud_env_templates | Generate /home/stack/templates/custom-nics/controller.yaml
overcloud_env_templates | Generate /home/stack/templates/custom-nics/compute.yaml
overcloud_env_templates | Generate /home/stack/templates/custom-nics/ceph-storage.yaml
overcloud_env_templates | Generate /home/stack/templates/roles/roles_data.yaml
overcloud_env_templates | (osp16+) Generate /home/stack/templates/enable-tls.yaml
overcloud_env_templates | (osp13) Generate /home/stack/templates/33-enable-tls.yaml
overcloud_env_tempaltes | (osp16+) Generate /home/stack/templates/octavia.yaml
overcloud_env_templates | (osp13) Generate /home/stack/templates/55-octavia.yaml
overcloud_env_tempaltes | (osp16+) Generate /home/stack/templates/ceph-ansible.yaml
overcloud_env_tempaltes | (osp16+) Generate /home/stack/templates/ceph-config.yaml
overcloud_env_tempaltes | (osp13) Generate /home/stack/templates/50-ceph-ansible.yaml
overcloud_env_tempaltes | (osp13) Generate /home/stack/templates/51-ceph-config.yaml
overcloud_env_tempaltes | (osp13) Generate /home/stack/templates/52-ceph-rgw.yaml
overcloud_env_tempaltes | (osp13) Generate /home/stack/templates/60-rackspace-tuning.yaml
generate_scripts | Create /home/stack/scripts
generate_scripts | Generate /home/stack/scripts/environment_args. (Sources to include "-e envfile" entries used by many openstack scripts.)
generate_scripts | Generate /home/stack/scripts/deploy_overcloud.sh
generate_scripts | Generate /home/stack/scripts/container_image_prepare.sh
generate_scripts | Generate /home/stack/scripts/update_overcloud_plan_only.sh
public_endpoint_hosts | Add the public endpoint dns entry to /etc/hosts to match overcloud certificate
pre_deploy_group_validations | (osp16+) Run /home/stack/scripts/update_overcloud_plan_only.sh to get a plan for validations.
pre_deploy_group_validations | (osp16+) Run pre deployment validations.  See defaults/main.yml pre_deployment_group_validations for details.
container_image_prepare | (osp13) Run /home/stack/scripts/container_image_prepare.sh to generate /home/stack/templates/01-overcloud-images.yaml
run_overcloud_deploy | Run /home/stack/scripts/deploy_overcloud.sh for overcloud depl.oy.
run_overcloud_deploy | Dump output to /home/stack/deploy_overcloud.log for deployer viewing.
post_deploy_group_validations | (osp16+) Run post deploy validations. See defaults/main.yml post_deployment_group_validations for details.
configure_fencing | Create /home/stack/playbooks/configure_fencing.sh with steps to configure fencing.
configure_fencing | Create /home/stack/playbooks/configure_fencing.yml to copy the scripts over and run via ansible.
configure_fencing | Run the configure_fencing.yml playbook to run the configuration on one of the control nodes.
config_etc_hosts | Generate /home/stack/playbooks/config_etc_hosts.yml playbook that runs openstack commands to add overcloud hosts to /etc/hosts.
config_etc_hosts | Run /home/stack/playbooks/config_etc_hosts.yml with ansible.
update_octavia_quotas | Run openstack commands to up service project quotas for octavia.
gen_openstacksdk_config | Create a script that generates the /home/stack/scripts/gen_openstacksdk_config.sh script to create openstacksdk config.
gen_openstacksdk_config | Run /home/stack/scripts/gen_openstacksdk_config.sh
overcloud_network | Create script to generate overcloud neutron networks /home/stack/scripts/overcloud_network.sh.
overcloud_network | Run /home/stack/scripts/overcloud_network.sh (needs ran again after tempest testing from dci)
