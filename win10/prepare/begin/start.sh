#!/bin/bash
set -x

# Kill bspwm
killall bspwm

# Load config file
source "/etc/libvirt/hooks/kvm.conf"

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind the EFI framebuffer (how the text shows on VTConsole)
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Avoid race condition
sleep 5

# Unbind all NVIDIA drivers
modprobe -r nvidia
modprobe -r nvidia_modeset
modprobe -r nvidia_uvm
modprobe -r nvidia_drm
modprobe -r drm_kms_helper
modprobe -r i2c_nvidia_gpu
modprobe -r drm

virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO
virsh nodedev-detach $VIRSH_AUDIO

modprobe vfio
modprobe vfio-pci
modprobe vfio_iommu_type1
