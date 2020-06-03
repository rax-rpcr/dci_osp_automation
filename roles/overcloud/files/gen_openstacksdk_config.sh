#!/bin/bash

if [ ! -d "/home/stack/.config" ]; then
  mkdir /home/stack/.config
fi

if [ ! -d "/home/stack/.config/openstack" ]; then
  mkdir /home/stack/.config/openstack
fi

. /home/stack/stackrc
cat << EOF > /home/stack/.config/openstack/clouds.yaml

clouds:

  ${OS_CLOUDNAME}:
    identity_api_version: ${OS_IDENTITY_API_VERSION}
    cacert: /etc/ssl/certs/ca-bundle.crt
    region_name: regionOne
    interface: internal
    nova_version: ${NOVA_VERSION}
    auth:
      auth_url: ${OS_AUTH_URL}
      username: ${OS_USERNAME}
      password: ${OS_PASSWORD}
      user_domain_name: ${OS_USER_DOMAIN_NAME}
      project_name: ${OS_PROJECT_NAME}
      project_domain_name: ${OS_PROJECT_DOMAIN_NAME}
EOF

. /home/stack/overcloudrc
cat << EOF >> /home/stack/.config/openstack/clouds.yaml

  ${OS_CLOUDNAME}:
    identity_api_version: ${OS_IDENTITY_API_VERSION}
    cacert: /etc/ssl/certs/ca-bundle.crt
    region_name: regionOne
    interface: internal
    nova_version: ${NOVA_VERSION}
    auth:
      auth_url: ${OS_AUTH_URL}
      username: ${OS_USERNAME}
      password: ${OS_PASSWORD}
      user_domain_name: ${OS_USER_DOMAIN_NAME}
      project_name: ${OS_PROJECT_NAME}
      project_domain_name: ${OS_PROJECT_DOMAIN_NAME}
EOF

