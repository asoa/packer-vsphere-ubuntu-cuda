#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# disable nouveau
sudo touch /etc/modprobe.d/blacklist-nvidia-nouveau.conf
sudo touch /etc/modprobe.d/nvidia.conf
sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo bash -c "echo options nvidia NVreg_OpenRmEnableUnsupportedGpus=1 >  /etc/modprobe.d/nvidia.conf"
sudo update-initramfs -u -k $(uname -r)
# reboot