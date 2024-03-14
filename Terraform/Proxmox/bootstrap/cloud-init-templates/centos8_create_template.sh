#!/bin/bash
# wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
cp orig_CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 
apt update -y && apt install libguestfs-tools -y
virt-customize -a CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --run-command "sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*"
virt-customize -a CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --run-command "sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*"
virt-customize -av CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --run-command "setenforce 0"
virt-customize -a CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --run-command "sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config"
virt-customize -a CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --run-command "sed -i 's/centos/tom/g' /etc/sudoers"
virt-customize -a CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --install qemu-guest-agent
virt-customize -a CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --root-password password:Happy3232
virt-customize -a CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --run-command 'useradd tom'
virt-customize -a CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --run-command 'mkdir -p /home/tom/.ssh'
virt-customize -a CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --ssh-inject tom:file:/home/tom/.ssh/id_tom_ed25519.pub
virt-customize -a CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --run-command 'chown -R tom:tom /home/tom'
# virt-customize -a CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --firstboot-command '/usr/sbin/useradd --shell /bin/bash --home /home/tom --skel /etc/skel --create-home --password Happy3232 tom'
qm create 8000 --name "centos8-cloudinit-template" --memory 4096 --sockets 2 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 8000 CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 local-zfs
qm set 8000 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-8000-disk-0
qm disk resize 8000 scsi0 30G
qm set 8000 --boot c --bootdisk scsi0
qm set 8000 --ide2 local-zfs:cloudin
qm set 8000 --serial0 socket --vga serial0
qm set 8000 --agent enabled=1
qm template 8000

