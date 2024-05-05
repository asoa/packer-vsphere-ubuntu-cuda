#!/bin/bash

# debian noninteractive
export DEBIAN_FRONTEND=noninteractive

KERNEL_VERSION="6.2"
INSTALL_CUDA="true"

if [ "$INSTALL_CUDA" = "true" ]; then
    # install cuda dependencies
    apt-get update -y && apt-get install -y linux-image-nvidia-$KERNEL_VERSION \
      linux-headers-nvidia-$KERNEL_VERSION \
      build-essential \
      gcc-12 
fi

# nvidia drivers were compiled with gcc-12; need to set gcc-12 as default to prevent
# compiler check errors
export CC=/usr/bin/gcc-12

# hold cuda dependencies
apt-mark hold linux-image-nvidia-$KERNEL_VERSION linux-headers-nvidia-$KERNEL_VERSION
sed -i 's/GRUB_DEFAULT=0/GRUB_DEFAULT="1>Ubuntu, with Linux 6.2.0-1015-nvidia"/' /etc/default/grub

