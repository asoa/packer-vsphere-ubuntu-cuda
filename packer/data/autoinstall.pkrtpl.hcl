#cloud-config

# Copyright 2023-2024 Broadcom. All rights reserved.
# SPDX-License-Identifier: BSD-2

# Ubuntu Server 22.04 LTS

version: 1
apt:
  geoip: true
  preserve_sources_list: false
  primary:
    - arches: [amd64, i386]
      uri: http://archive.ubuntu.com/ubuntu
    - arches: [default]
      uri: http://ports.ubuntu.com/ubuntu-ports
early-commands:
  - sudo systemctl stop ssh
locale: "en_US"
keyboard:
  layout: "us"
network:
  network:
    version: 2
    ethernets:
      ens192:
        dhcp4: true
identity:
  hostname: ubuntu-server
  username: ${build_username}
  password: ${build_password_encrypted}
ssh:
  install-server: true
  allow-pw: true
  authorized-keys:
    - ${ssh_public_key}
packages:
  - openssh-server
  - open-vm-tools
  - cloud-init
%{ for package in additional_packages ~}
  - ${package}
%{ endfor ~}
user-data:
  disable_root: false
  timezone: "UTC"
late-commands:
  - sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config
  - echo '${build_username} ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/${build_username}
  - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/${build_username}