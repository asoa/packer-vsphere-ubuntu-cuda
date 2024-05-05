#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

linux_arch="x86_64"
cuda_version="545.29.06"
cuda_driver_name="NVIDIA-Linux-x86_64-545.29.06.run"
# download cuda toolkit
# wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
# sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
# wget -q https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb
# sudo dpkg -i cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb
# sudo cp /var/cuda-repo-ubuntu2204-12-4-local/cuda-*-keyring.gpg /usr/share/keyrings/
# sudo apt-get update
# sudo apt-get -y install cuda-toolkit-12-4
# # install driver
# sudo apt-get install -y nvidia-driver-550-open
# sudo apt-get install -y cuda-drivers-550


# wget https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda_12.4.1_550.54.15_linux.run
# chmod +x cuda_12.4.1_550.54.15_linux.run
wget -q https://download.nvidia.com/XFree86/Linux-${linux_arch}/${cuda_version}/${cuda_driver_name}.run
chmod +x ${cuda_driver_name}.run
sudo service gdm stop
apt-get -y install pkg-config libglvnd-dev
# ./cuda_12.4.1_550.54.15_linux.run --silent --driver --toolkit --run-nvidia-xconfig --override -m=kernel-open
./${cuda_driver_name}.run -q -s -m=kernel-open
sudo update-initramfs -c -k $(uname -r)