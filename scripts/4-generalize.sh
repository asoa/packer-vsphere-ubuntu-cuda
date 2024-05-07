#!/bin/bash

sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo truncate -s 0 /etc/machine-id
sudo rm /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
sudo rm -f /etc/netplan/*.yaml