#!/bin/bash
# wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
cp orig_jammy-server-cloudimg-amd64.img jammy-server-cloudimg-amd64.img
apt update -y && apt install libguestfs-tools -y
virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent
virt-customize -a jammy-server-cloudimg-amd64.img --root-password password:Happy3232
# virt-customize -a jammy-server-cloudimg-amd64.img --firstboot-command 'apt install -y qemu-guest-agent && systemctl start qemu-guest-agent'
virt-customize -a jammy-server-cloudimg-amd64.img --firstboot-command 'ssh-keygen -A; systemctl restart ssh.service'
virt-customize -a jammy-server-cloudimg-amd64.img --firstboot-command '/usr/sbin/useradd --shell /bin/bash --home /home/tom --skel /etc/skel --create-home --password Happy3232 tom'
qm create 9000 --name "ubuntu-2204-cloudinit-template" --memory 4096 --sockets 2 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 9000 jammy-server-cloudimg-amd64.img local-zfs
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --ide2 local-zfs:cloudinit
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1
qm template 9000

