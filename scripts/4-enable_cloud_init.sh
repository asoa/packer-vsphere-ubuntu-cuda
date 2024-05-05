#!/usr/bin/env bash

# create a cloud init config file to dynamically set a hostname
# https://cloudinit.readthedocs.io/en/latest/topics/examples.html#yaml-examples
echo ' - Enabling cloud-init ...'
iid="iid-$(openssl rand -hex 3)"
hostname="ubuntu-server-$(openssl rand -hex 3)"

mkdir -p /var/lib/cloud/seed/nocloud
cat <<EOF > /var/lib/cloud/seed/nocloud/meta-data
instance-id: $iid
EOF

cat <<EOF > /var/lib/cloud/seed/nocloud/user-data
#cloud-config
autoinstall:
  version: 1
  keyboard:
    layout: us
    variant: ''
  identity:
    hostname: $hostname
    username: ubuntu
    password: #{build_password_encrypted}#
runcmd:
  - |
    #!/usr/bin/env bash
    hostnamectl hostname $hostname
EOF


