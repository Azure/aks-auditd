#!/bin/sh

# Install auditd on VMSS worker node
echo "Installing auditd"
chroot /node apt-get update
chroot /node apt-get install auditd -y

# Make sure that auditd is running
chroot /node systemctl start auditd

