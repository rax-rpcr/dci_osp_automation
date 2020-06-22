# dci_osp_automation

Redhat DCI requires automation playbooks to tie into the dci-openstack-agent
hooks.  This is a collection of playbooks and roles to configure dci and 
handle the undercloud and overcloud automation.


------

## dci.yaml playbook

Configure the dci vm from within the dci vm.

* dci role:
  * [Requirements](roles/dci/README.md#requirements)  
  * [Input Vars](roles/dci/README.md#input-vars)  
  * [Outputs](roles/dci/README.md#outputs)  


* Example:

```
ansible-playbook -i inventory/lab.yml dci.yaml -b -e @vars/environment-example.yml -e @vars/OSP16-dci-settings.yml
```



------

## undercloud.yml playbook

Configure and install the undercloud on the director vm

* undercloud role:
  * [Requirements](roles/undercloud/README.md#requirements)  
  * [Input Vars](roles/undercloud/README.md#input-vars)  
  * [Outputs](roles/undercloud/README.md#outputs)  


* Example:(when ran from /etc/dci-openstack/agent/hooks/running.yml)
```
cd /var/lib/dci-openstack-agent/repos/dci_osp_automation/
ansible-playbook undercloud.yaml \
    -i inventory/lab.yml  \
    -e @/etc/dci-openstack-agent/settings.yml \
    -e @/etc/dci-openstack-agent/theforeman-dci-vars.yml \
    -e @/etc/dci-openstack-agent/non-theforeman-dci-vars.yml
```

------

## overcloud.yml playbook

Configure and install the overcloud from the director vm

* overcloud role:
  * [Requirements](roles/overcloud/README.md#requirements)  
  * [Input Vars](roles/overcloud/README.md#input-vars)  
  * [Outputs](roles/overcloud/README.md#outputs)  


* Example:(when ran from /etc/dci-openstack/agent/hooks/running.yml)
```
cd /var/lib/dci-openstack-agent/repos/dci_osp_automation/
ansible-playbook overcloud.yaml \
    -i inventory/lab.yml  \
    -e @/etc/dci-openstack-agent/settings.yml \
    -e @/etc/dci-openstack-agent/theforeman-dci-vars.yml \
    -e @/etc/dci-openstack-agent/non-theforeman-dci-vars.yml
```
