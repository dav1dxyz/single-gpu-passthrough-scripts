#!/bin/bash
set -x

# Load config file
source "/etc/libvirt/hooks/kvm.conf"

# Unload VFIO-PCI Kernel Driver
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO
virsh nodedev-reattach $VIRSH_AUDIO

# Rebind vtconsoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Read nvidia x config
nvidia-xconfig --query-gpu-info > /dev/null 2>&1

# Bind EFI framebuffer
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# Reload nvidia modules
modprobe nvidia
modprobe nvidia_modeset
modprobe nvidia_uvm
modprobe nvidia_drm
modprobe drm_kms_helper
modprobe drm

systemctl restart getty@tty1
